import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress/flutter_progress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Progress Example',
      theme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Progress Example"),
      ),
      body: Center(
        child: visible
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => showExampleProgress(context),
                    child: const Text("Interactive Example"),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 50.0)),
                  OutlinedButton(
                    onPressed: () => showUpdatingProgress(context),
                    child: const Text("Updating Progress"),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 50.0)),
                  TextButton(
                    onPressed: () => showCustomProgress(context),
                    child: const Text("Custom Progress"),
                  ),
                  TextButton(
                    onPressed: () => showCustomBodyProgress(context),
                    child: const Text("Custom Body Progress"),
                  ),
                  TextButton(
                    onPressed: () => showSmallProgress(context),
                    child: const Text("Small Progress"),
                  ),
                  TextButton(
                    onPressed: () => downloadFile(context),
                    child: const Text("Download Example"),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void showExampleProgress(BuildContext context) async {
    setState(() {
      visible = false;
    });

    Config(
      completed: ProgressCompleted(
        message: "Finished downloading!",
        body: Image.asset(
          "assets/completed_check.png",
          width: ProgressDialog.loaderSize.width,
        ),
      ),
    );

    var dialogKey = GlobalKey<ProgressDialogState>();
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => ProgressDialog(
        key: dialogKey,
        config: Config(
          message: "Loading data",
          barrierDismissible: true,
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => ProgressDialog.update(dialogKey,
                  config: const Config(
                    message: "Loading data",
                    progress: 0,
                    progressType: ProgressType.normal,
                    progressValueColor: Colors.blueAccent,
                  )),
              child: const Text("Normal"),
            ),
            TextButton(
              onPressed: () => ProgressDialog.update(dialogKey,
                  config: const Config(
                    message: "Downloading data",
                    progress: 23,
                    maxProgress: 100,
                    progressType: ProgressType.valuable,
                    progressValueColor: Colors.blueAccent,
                  )),
              child: const Text("Valuable"),
            ),
            TextButton(
              onPressed: () => ProgressDialog.update(dialogKey,
                  config: const Config(
                    message: "Finished processing!",
                    progress: 100,
                    progressType: ProgressType.valuable,
                    barrierDismissible: true,
                  )),
              child: const Text("Completed"),
            ),
          ],
        ),
      ),
    );

    setState(() {
      visible = true;
    });
  }

  void showUpdatingProgress(BuildContext context) async {
    var dialogKey = GlobalKey<ProgressDialogState>();
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        key: dialogKey,
        config: const Config(
          message: "Starting download",
          maxProgress: 100,
          progressValueColor: Color(0xff3550B4),
          progressType: ProgressType.valuable,
          completed: ProgressCompleted(
            message: "Download successful",
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      ProgressDialog.update(dialogKey,
          config: Config(
            message: "Downloading data",
            progress: i,
          ));
    }
    await Future.delayed(const Duration(seconds: 2));

    ProgressDialog.safeClose(dialogKey);
  }

  void showCustomProgress(BuildContext context) async {
    var dialogKey = GlobalKey<ProgressDialogState>();
    bool cancel = false;
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Theme(
        data: ThemeData(
          brightness: Brightness.dark,
        ),
        child: ProgressDialog(
          key: dialogKey,
          config: Config(
            message: "Preparing file download",
            progressType: ProgressType.valuable,
            backgroundColor: const Color(0xff212121),
            progressValueColor: const Color(0xff3550B4),
            progressBgColor: Colors.white70,
            borderRadius: 25,
            barrierDismissible: false,
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
            valuePosition: ValuePosition.center,
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => cancel = true,
                // onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      ProgressDialog.update(dialogKey,
          config: Config(
            message: "Downloading file",
            progress: i,
          ));
      if (cancel) {
        break;
      }
    }
    ProgressDialog.update(
      dialogKey,
      config: Config(
        message: "Download ${cancel ? "canceled" : "successful"}",
        actions: [],
        contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));

    ProgressDialog.safeClose(dialogKey);
  }

  void showCustomBodyProgress(BuildContext context) async {
    var dialogKey = GlobalKey<ProgressDialogState>();
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        key: dialogKey,
        config: Config(
          message: "Preparing...",
          body: Image.asset(
            "assets/double_ring_loading_io.gif",
            width: 50,
          ),
          progressType: ProgressType.valuable,
          barrierDismissible: true,
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    ProgressDialog.safeClose(dialogKey);
  }

  void showSmallProgress(BuildContext context) async {
    var dialogKey = GlobalKey<ProgressDialogState>();
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        key: dialogKey,
        config: const Config(
          message: "Processing",
          progress: 69,
          progressType: ProgressType.valuable,
          valuePosition: ValuePosition.inProgress,
          messageTextStyle: TextStyle(
            fontWeight: FontWeight.w400,
          ),
          valueTextStyle: TextStyle(
            fontWeight: FontWeight.w400,
          ),
          barrierDismissible: true,
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    ProgressDialog.safeClose(dialogKey);
  }

  void downloadFile(BuildContext context) async {
    var dialogKey = GlobalKey<ProgressDialogState>();
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        key: dialogKey,
        config: Config(
          message: "Starting download",
          progressValueColor: Theme.of(context).colorScheme.primary,
          completed: ProgressCompleted(
            message: "Download finished",
            body: SvgPicture.asset(
              "assets/done_check.svg",
              width: ProgressDialog.loaderSize.width,
            ),
          ),
        ),
      ),
    );

    var directory = await getTemporaryDirectory();
    String downloadLocation = join(directory.path, "test.zip");

    try {
      log("Downloading test file to '$downloadLocation'");
      await Dio().download(
        options: Options(
          headers: {HttpHeaders.userAgentHeader: HttpClient().userAgent!},
        ),
        "http://ipv4.download.thinkbroadband.com/5MB.zip",
        downloadLocation,
        onReceiveProgress: (count, total) {
          ProgressDialog.update(dialogKey,
              config: Config(
                message: "Downloading file...",
                progress: count,
                maxProgress: total,
              ));
        },
      );
    } catch (e, stack) {
      log("Failed to download file", error: e.toString(), stackTrace: stack);
      ProgressDialog.update(dialogKey,
          config: Config(message: "Download failed: $e"));
    } finally {
      try {
        await File(downloadLocation).delete();
      } catch (e, stack) {
        log("Couldn't delete test file",
            error: e.toString(), stackTrace: stack);
      }

      await Future.delayed(const Duration(seconds: 3));
      ProgressDialog.safeClose(dialogKey);
    }
  }
}
