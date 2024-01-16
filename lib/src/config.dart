import 'package:flutter/material.dart';

import 'progress_completed.dart';

export 'progress_completed.dart';

/// Used with [Config] to define the type of the [Config.progress] indicator.
enum ProgressType {
  /// Shows a indeterminate progress, as long as [Config.progress] is `0`.
  normal,

  /// Shows a determinate progress, even if [Config.progress] is `0`.
  valuable,
}

/// Used with [Config] to define the type of the [Config.progress] label.
enum ValueType {
  /// Displays the value label as number. (e.g. 34/100)
  number,

  /// Displays the percentage of the progress.
  ///
  /// Therefore even if [Config.maxProgress] is not equals 100, it will grow towards 100%.
  percentage,
}

/// Used with [Config] to define the position of the [Config.progress] label.
enum ValuePosition {
  /// Hides the value.
  none,

  /// Shows the value centered under the message.
  center,

  /// Shows the value on the bottom right end of the dialog.
  right,

  /// Shows the value inside the progress indicator.
  inProgress,
}

/// The immutable config for the [ProgressDialog].
class Config {
  /// The message in this dialog.
  final String? message;

  /// The value of the progress.
  ///
  /// (Default: `0`)
  final int? progress;

  /// The maximum value of the progress.
  ///
  /// (Default: `100`)
  final int? maxProgress;

  /// See [AlertDialog.actions].
  final List<Widget>? actions;

  /// See [AlertDialog.actionsAlignment].
  final MainAxisAlignment? actionsAlignment;

  /// See [AlertDialog.actionsPadding].
  final EdgeInsetsGeometry? actionsPadding;

  /// The background color of this dialog.
  ///
  /// See [AlertDialog.backgroundColor].
  final Color? backgroundColor;

  /// Whether this dialog closes when the back button or screen is clicked.
  ///
  /// (Default: `false`)
  final bool? barrierDismissible;

  /// The widget that replaces the progress loader.
  final Widget? body;

  /// The border radius of this dialog.
  ///
  /// (Default: `15.0`)
  final double? borderRadius;

  /// See [AlertDialog.buttonPadding].
  final EdgeInsetsGeometry? buttonPadding;

  /// The completed config which gets used when [progress] = [maxProgress].
  final ProgressCompleted? completed;

  /// See [AlertDialog.contentPadding].
  final EdgeInsetsGeometry? contentPadding;

  /// The elevation of this dialog.
  ///
  /// See [AlertDialog.elevation].
  ///
  /// (Default: `5.0`)
  final double? elevation;

  /// See [Text.maxLines].
  final int? messageMaxLines;

  /// Whether and how the [message] should overflow.
  ///
  /// See [Text.overflow].
  final TextOverflow? messageOverflow;

  /// The [TextAlign] for the [message].
  ///
  /// (Default: [TextAlign.center])
  final TextAlign? messageTextAlign;

  /// The [TextStyle] for the [message].
  final TextStyle? messageTextStyle;

  /// The progress bar type.
  ///
  /// (Default: [ProgressType.normal])
  final ProgressType? progressType;

  /// The color for the progress indicator.
  ///
  /// (Default: [ThemeData.colorScheme] => [ColorScheme.primary])
  final Color? progressValueColor;

  /// The background color for the progress indicator.
  ///
  /// (Default: [ThemeData.colorScheme] => [ColorScheme.background])
  final Color? progressBgColor;

  /// Type of the progress value.
  ///
  /// (Default: [ValueType.percentage])
  final ValueType? valueType;

  /// Location of the progress value.
  ///
  /// (Default: [ValuePosition.right])
  final ValuePosition? valuePosition;

  /// The [TextStyle] for the progress value.
  final TextStyle? valueTextStyle;

  /// Creates a config.
  ///
  /// The [message] argument must not be null during initialization.
  const Config({
    this.message,
    this.progress,
    this.maxProgress,
    this.actions,
    this.actionsAlignment,
    this.actionsPadding,
    this.backgroundColor,
    this.barrierDismissible,
    this.body,
    this.borderRadius,
    this.buttonPadding,
    this.completed,
    this.contentPadding,
    this.elevation,
    this.messageMaxLines,
    this.messageOverflow,
    this.messageTextAlign,
    this.messageTextStyle,
    this.progressType,
    this.progressValueColor,
    this.progressBgColor,
    this.valueType,
    this.valuePosition,
    this.valueTextStyle,
  });

  /// Returns a new config that is a combination of this config and the default config.
  Config withDefaults() {
    return const Config(
      progress: 0,
      maxProgress: 100,
      progressType: ProgressType.normal,
      valueType: ValueType.percentage,
      valuePosition: ValuePosition.right,
      messageTextAlign: TextAlign.center,
      barrierDismissible: false,
      borderRadius: 15.0,
      elevation: 5.0,
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    ).merge(this);
  }

  /// Returns a new config that is a combination of this config and the given [other] config.
  Config merge(Config? other) {
    if (other == null) return this;

    return Config(
      message: other.message ?? message,
      progress: other.progress ?? progress,
      maxProgress: other.maxProgress ?? maxProgress,
      actions: other.actions ?? actions,
      actionsPadding: other.actionsPadding ?? actionsPadding,
      actionsAlignment: other.actionsAlignment ?? actionsAlignment,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      barrierDismissible: other.barrierDismissible ?? barrierDismissible,
      body: other.body ?? body,
      borderRadius: other.borderRadius ?? borderRadius,
      buttonPadding: other.buttonPadding ?? buttonPadding,
      completed: other.completed ?? completed,
      contentPadding: other.contentPadding ?? contentPadding,
      elevation: other.elevation ?? elevation,
      messageMaxLines: other.messageMaxLines ?? messageMaxLines,
      messageOverflow: other.messageOverflow ?? messageOverflow,
      messageTextAlign: other.messageTextAlign ?? messageTextAlign,
      messageTextStyle: other.messageTextStyle ?? messageTextStyle,
      progressType: other.progressType ?? progressType,
      progressValueColor: other.progressValueColor ?? progressValueColor,
      progressBgColor: other.progressBgColor ?? progressBgColor,
      valueType: other.valueType ?? valueType,
      valuePosition: other.valuePosition ?? valuePosition,
      valueTextStyle: other.valueTextStyle ?? valueTextStyle,
    );
  }
}
