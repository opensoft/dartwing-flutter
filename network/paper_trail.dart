import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class PaperTrailClient {
  static const Duration _infoLogThrottleWindow = Duration(seconds: 10);
  static const int _maxInfoLogsPerWindow = 100;

  static void init(String appName, String appId, String host, int port) {
    _appName = appName;
    _appId = appId;
    _host = host;
    _port = port;
  }

  static String _appName = '';
  static String _appId = '';
  static String _host = '';
  static int _port = -1;
  static DateTime? _infoLogWindowStartedAt;
  static int _infoLogsSentInWindow = 0;
  static int _infoLogsDroppedInWindow = 0;

  static void sendInfoMessageToPaperTrail(String message) async {
    if (!_shouldSendInfoLog()) {
      return;
    }
    sendMessageToPaperTrail(message, "INFO");
  }

  static void sendWarningMessageToPaperTrail(String message) async {
    sendMessageToPaperTrail(message, "WARNING");
  }

  static void sendCriticalErrorMessageToPaperTrail(String message) async {
    sendMessageToPaperTrail(message, "CRITICAL ERROR");
  }

  static void sendMessageToPaperTrail(
    String message,
    String severityName,
  ) async {
    _resetInfoLogWindowIfNeeded();
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

  static bool _shouldSendInfoLog() {
    _resetInfoLogWindowIfNeeded();
    _infoLogWindowStartedAt ??= DateTime.now();
    if (_infoLogsSentInWindow < _maxInfoLogsPerWindow) {
      _infoLogsSentInWindow += 1;
      return true;
    }

    _infoLogsDroppedInWindow += 1;
    if (_infoLogsDroppedInWindow == 1) {
      debugPrint(
        'PaperTrail info log rate limit reached; suppressing additional info '
        'logs for ${_infoLogThrottleWindow.inSeconds}s.',
      );
    }
    return false;
  }

  static void _resetInfoLogWindowIfNeeded() {
    final DateTime? windowStartedAt = _infoLogWindowStartedAt;
    if (windowStartedAt == null) {
      return;
    }

    final DateTime now = DateTime.now();
    if (now.difference(windowStartedAt) < _infoLogThrottleWindow) {
      return;
    }

    if (_infoLogsDroppedInWindow > 0) {
      debugPrint(
        'PaperTrail info log throttle released after dropping '
        '$_infoLogsDroppedInWindow messages in the last '
        '${_infoLogThrottleWindow.inSeconds}s.',
      );
    }

    _infoLogWindowStartedAt = null;
    _infoLogsSentInWindow = 0;
    _infoLogsDroppedInWindow = 0;
  }
}
