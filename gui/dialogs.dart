import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../network/paper_trail.dart';
import 'widgets/base_colors.dart';

class Dialogs {
  static TextEditingController _textController = TextEditingController();

  static Future<dynamic> showWarningDialog(
      BuildContext context, String message) {
    PaperTrailClient.sendWarningMessageToPaperTrail(message);
    return showBaseDialog(
        context, tr("Warning"), message, Colors.deepOrangeAccent);
  }

  static Future<dynamic> showInfoDialog(BuildContext context, String message,
      {String titleText = "Dialog",
      String okButtonText = "Ok",
      String cancelButtonText = "Cancel",
      String additionalButtonText = "",
      Color backgroundColor = Colors.white,
      bool textFieldEnabled = false}) {
    PaperTrailClient.sendInfoMessageToPaperTrail("$titleText: $message");
    return showSecondBaseDialog(context, message,
        titleText: tr(titleText),
        okButtonText: tr(okButtonText),
        cancelButtonText: tr(cancelButtonText),
        additionalButtonText: additionalButtonText,
        backgroundColor: backgroundColor,
        textFieldEnabled: textFieldEnabled);
  }

  static Future<dynamic> showBaseDialog(BuildContext context, String title,
      String message, Color backgroundColor) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(title,
              style: const TextStyle(
                fontSize: 25,
              )),
          content: Text(message,
              style: const TextStyle(
                fontSize: 16,
              )),
        );
      },
    );
  }

  static Future<dynamic> showSecondBaseDialog(
      BuildContext context, String message,
      {String titleText = "Dialog",
      String okButtonText = "",
      String cancelButtonText = "",
      String additionalButtonText = "",
      Color backgroundColor = BaseColors.lightBackgroundColor,
      bool textFieldEnabled = false}) {
    _textController.text = "";
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: backgroundColor,
              title: Text(tr(titleText),
                  style: const TextStyle(
                    fontSize: 25,
                  )),
              content: textFieldEnabled
                  ? Column(children: [
                      Text(message,
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          enabled: textFieldEnabled,
                          controller: _textController,
                          style: const TextStyle(fontSize: 35.0),
                          decoration: InputDecoration.collapsed(
                              hintText: tr("Enter text")),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ])
                  : Text(message,
                      style: const TextStyle(
                        fontSize: 16,
                      )),
              actions: <Widget>[
                Visibility(
                  visible: additionalButtonText.isNotEmpty,
                  child: ElevatedButton(
                    onPressed: () {
                      PaperTrailClient.sendInfoMessageToPaperTrail(
                          "$titleText: $additionalButtonText");
                      Navigator.pop(context, false);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.orangeAccent),
                    child: Text(additionalButtonText,
                        style: const TextStyle(
                          fontSize: 16,
                        )),
                  ),
                ),
                Visibility(
                  visible: cancelButtonText.isNotEmpty,
                  child: ElevatedButton(
                    onPressed: () {
                      PaperTrailClient.sendInfoMessageToPaperTrail(
                          "$titleText: $cancelButtonText");
                      Navigator.pop(context, null);
                    },
                    child: Text(cancelButtonText,
                        style: const TextStyle(
                          fontSize: 16,
                        )),
                  ),
                ),
                Visibility(
                  visible: okButtonText.isNotEmpty,
                  child: ElevatedButton(
                    onPressed: !textFieldEnabled ||
                            _textController.text.isNotEmpty
                        ? () {
                            PaperTrailClient.sendInfoMessageToPaperTrail(
                                "$titleText: $okButtonText");
                            Navigator.pop(context,
                                textFieldEnabled ? _textController.text : true);
                          }
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                    child: Text(okButtonText,
                        style: const TextStyle(
                          fontSize: 16,
                        )),
                  ),
                ),
              ],
            );
          });
        });
  }
}
