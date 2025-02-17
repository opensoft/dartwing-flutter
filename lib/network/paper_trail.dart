import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class PaperTrailClient {
  static init(String appName, String appId, String host, int port) {
    _appName = appName;
    _appId = appId;
    _host = host;
    _port = port;
  }

  static String _appName = '';
  static String _appId = '';
  static String _host = '';
  static int _port = -1;

  static void sendInfoMessageToPaperTrail(String message) async {
    sendMessageToPaperTrail(message, "INFO");
  }

  static void sendWarningMessageToPaperTrail(String message) async {
    sendMessageToPaperTrail(message, "WARNING");
  }

  static void sendCriticalErrorMessageToPaperTrail(String message) async {
    sendMessageToPaperTrail(message, "CRITICAL ERROR");
  }

  static void sendMessageToPaperTrail(
      String message, String severityName) async {
    message = message.replaceAll('\r\n', ' ');
    message = message.replaceAll('\n', ' ');
    var newFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    String dateTime = newFormat.format(DateTime.now());
    String logLine = "$dateTime $_appName $_appId $severityName | $message\r\n";
    debugPrint(logLine);
    if (!kIsWeb && _host.isNotEmpty && _port > -1) {
      Socket socket = await Socket.connect(_host, _port);
      socket.add(utf8.encode(logLine));
      socket.close();
    }
  }
}
