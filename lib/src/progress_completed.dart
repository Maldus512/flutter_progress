import 'package:flutter/widgets.dart';

/// Replaces various properties of the [Config],
/// if [Config.progress] = [Config.maxProgress].
class ProgressCompleted {
  /// The completed message which replaces the [Config.message].
  final String? message;

  /// The widget which replaces the progress indicator.
  final Widget? body;

  /// Creates a progress completed config.
  const ProgressCompleted({
    this.message,
    this.body,
  });
}
