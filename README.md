# flutter_progress

[![Pub Version](https://img.shields.io/pub/v/flutter_progress?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/flutter_progress)
[![Last commit](https://img.shields.io/github/last-commit/Bungeefan/flutter_progress?logo=git&logoColor=white)](https://github.com/Bungeefan/flutter_progress/commits/main)
[![Pull Requests](https://img.shields.io/github/issues-pr/Bungeefan/flutter_progress?logo=github)](https://github.com/Bungeefan/flutter_progress/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/Bungeefan/flutter_progress?logo=github)](https://github.com/Bungeefan/flutter_progress)

Highly customizable and light weight progress library including dynamic updates

## Examples

|                                              Normal Progress                                               |                                               Valuable Progress                                                |
|:----------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------:|
| ![Normal Progress](https://github.com/Bungeefan/flutter_progress/blob/assets/normal_progress.gif?raw=true) | ![Valuable Progress](https://github.com/Bungeefan/flutter_progress/blob/assets/valuable_progress.gif?raw=true) |

|                                                 Custom Body Progress                                                 |                                              Custom Progress                                               |
|:--------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------:|
| ![Custom Body Progress](https://github.com/Bungeefan/flutter_progress/blob/assets/custom_body_progress.gif?raw=true) | ![Custom Progress](https://github.com/Bungeefan/flutter_progress/blob/assets/custom_progress.gif?raw=true) |

## How to use

Add import

```dart
import 'package:flutter_progress/flutter_progress.dart';
```

Show dialog and assign it a global key to update it later.

All properties except the message are optional.

```dart
var dialogKey = GlobalKey<ProgressDialogState>();
showDialog(
  context: context,
  builder: (context) => ProgressDialog(
    key: dialogKey,
    config: const Config(
      message: "Starting download",
      maxProgress: 100,
      progressValueColor: const Color(0xff3550B4),
      progressBgColor: Colors.white70,
      progressType: ProgressType.valuable,
    ),
  ),
);
```

Dynamically update all available properties with the dialog key:

```dart
ProgressDialog.update(dialogKey,
  config: Config(
    message: "Downloading data",
    progress: i,
  ));
```

Dialog can be closed with `Navigator.pop(context)` or via the dialog key:

```dart
ProgressDialog.safeClose(dialogKey);
```

### Progress Completed Type

Use this to specify fields to be used when the progress is finished.

<img alt="Completed Progress" src="https://github.com/Bungeefan/flutter_progress/blob/assets/completed_progress.png?raw=true" width="400"/>

```dart
completed: ProgressCompleted(
  message: "Finished downloading!",
  body: Image.asset("assets/completed_check.png", width: ProgressDialog.loaderSize.width),
),
```

## Example DIO usage

```dart
var dialogKey = GlobalKey<ProgressDialogState>();
showDialog(
  context: context,
  builder: (context) => ProgressDialog(
    key: dialogKey,
    config: const Config(message: "Starting download", completed: ProgressCompleted(message: "Download finished")),
  ),
);
try {
  await Dio().download("http://ipv4.download.thinkbroadband.com/5MB.zip", "test.zip",
      onReceiveProgress: (count, total) {
        ProgressDialog.update(
          dialogKey,
          config: Config(message: "Downloading file...", progress: count, maxProgress: total),
        );
      });
} catch (e) {
  ProgressDialog.update(dialogKey, config: Config(message: "Download failed: $e"));
} finally {
  await Future.delayed(const Duration(seconds: 3));
  ProgressDialog.safeClose(dialogKey);
}
```
