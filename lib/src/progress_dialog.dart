import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'config.dart';

/// A stateful Progress dialog
///
/// This snippet shows an example usage of the dialog with an initial style config.
///
/// ```dart
/// var dialogKey = GlobalKey<ProgressDialogState>();
/// showDialog(
///   context: context,
///   builder: (context) => ProgressDialog(
///     key: dialogKey,
///     config: const Config(
///       message: "Loading",
///       progressValueColor: Color(0xff3550B4),
///     ),
///   ),
/// );
/// ```
///
/// It can later be updated via the assigned global key.
///
/// ```dart
/// ProgressDialog.update(
///   dialogKey,
///   config: const Config(
///     message: "Loading successful",
///     progress: 100,
///   ),
/// );
/// ```
///
/// At the end, it can be safely closed via the same key.
///
/// ```dart
/// ProgressDialog.safeClose(dialogKey);
/// ```
class ProgressDialog extends StatefulWidget {
  /// Default size for non-custom loader
  static const Size loaderSize = Size(41.0, 41.0);

  /// Configures this dialog
  final Config config;

  /// Creates an ProgressDialog.
  const ProgressDialog({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<ProgressDialog> createState() => ProgressDialogState();

  /// Shortcut for safe updating.
  ///
  /// ```dart
  /// key.currentState?.update(config: config);
  /// ```
  static void update(
    GlobalKey<ProgressDialogState> key, {
    required Config config,
  }) {
    key.currentState?.update(config: config);
  }

  /// Pops the dialog safely.
  static void safeClose(GlobalKey<ProgressDialogState> key) {
    if (key.currentWidget != null && key.currentContext != null) {
      try {
        if (Navigator.canPop(key.currentContext!)) {
          Navigator.pop(key.currentContext!);
        }
      } catch (e, stackTrace) {
        log(
          "Error while trying to safely close progress dialog",
          error: e,
          stackTrace: stackTrace,
        );
      }
    }
  }
}

class ProgressDialogState extends State<ProgressDialog> {
  late Config _config;

  @override
  void initState() {
    super.initState();

    _config = widget.config.withDefaults();
    if (_config.message == null) {
      throw Exception("Message has to be set during initialization");
    }
  }

  /// Sets a new (partly filled) config to update the state.
  ///
  /// The [config] is being merged with the already existing config.
  void update({required Config config}) {
    _config = _config.merge(config);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _config.barrierDismissible!,
      child: AlertDialog(
        backgroundColor: _config.backgroundColor,
        elevation: _config.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_config.borderRadius!),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _config.maxProgress! > 0 &&
                        _config.progress == _config.maxProgress
                    ? _createCompletedLoader()
                    : _createLoader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: _createMessageWidget(),
                  ),
                ),
              ],
            ),
            _config.valuePosition != ValuePosition.none &&
                    (_config.progress! > 0 ||
                        _config.progressType == ProgressType.valuable) &&
                    (_config.valuePosition == ValuePosition.right ||
                        _config.valuePosition == ValuePosition.center)
                ? Align(
                    alignment: _config.valuePosition == ValuePosition.right
                        ? Alignment.bottomRight
                        : Alignment.bottomCenter,
                    child: _createValueWidget(),
                  )
                : const SizedBox.shrink()
          ],
        ),
        contentPadding: _config.contentPadding!,
        buttonPadding: _config.buttonPadding,
        actions: _config.actions,
        actionsPadding: _config.actionsPadding!,
        actionsAlignment: _config.actionsAlignment,
      ),
    );
  }

  Color _getEffectiveProgressValueColor() {
    return _config.progressValueColor ?? Theme.of(context).colorScheme.primary;
  }

  Widget _createCompletedLoader() {
    return _config.completed?.body != null
        ? _config.completed!.body!
        : SizedBox.fromSize(
            size: ProgressDialog.loaderSize,
            child: SvgPicture.asset(
              'assets/completed_check.svg',
              theme: SvgTheme(currentColor: _getEffectiveProgressValueColor()),
              package: "flutter_progress",
            ),
          );
  }

  Widget _createLoader() {
    return _config.body ??
        SizedBox.fromSize(
          size: ProgressDialog.loaderSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                    _getEffectiveProgressValueColor()),
                backgroundColor: _config.progressBgColor ??
                    Theme.of(context).colorScheme.background,
                value: (_config.progressType == ProgressType.normal ||
                        _config.progress == 0 ||
                        _config.maxProgress == 0
                    ? null
                    : _config.progress! / _config.maxProgress!),
              ),
              if (_config.valuePosition == ValuePosition.inProgress)
                _createValueWidget(),
            ],
          ),
        );
  }

  Widget _createMessageWidget() {
    return DefaultTextStyle.merge(
      style: const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
      ).merge(_config.messageTextStyle),
      child: Text(
        _config.progress == _config.maxProgress!
            ? _config.completed?.message ?? _config.message!
            : _config.message!,
        textAlign: _config.messageTextAlign,
        maxLines: _config.messageMaxLines,
        overflow: _config.messageOverflow,
      ),
    );
  }

  Widget _createValueWidget() {
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize:
            _config.valuePosition != ValuePosition.inProgress ? 15.0 : 13.0,
        fontWeight: _config.valuePosition != ValuePosition.inProgress
            ? FontWeight.normal
            : FontWeight.bold,
      ).merge(_config.valueTextStyle),
      child: Text(
        _config.valueType == ValueType.number
            ? '${_config.progress}/${_config.maxProgress}'
            : "${_config.maxProgress! > 0 ? "${(_config.progress! / _config.maxProgress! * 100).round()}" : "0"}%",
      ),
    );
  }
}
