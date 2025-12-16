import 'package:flutter/material.dart';

import '../network/paper_trail.dart';

void showInfoNotification(BuildContext context, String message) {
  PaperTrailClient.sendInfoMessageToPaperTrail(message);
  showNotification(context, message);
}

void showWarningNotification(BuildContext context, String message) {
  PaperTrailClient.sendWarningMessageToPaperTrail(message);
  if (context.mounted) {
    showNotification(context, message, warning: true);
  }
}

void showNotification(BuildContext context, String message, {bool warning = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: warning ? Colors.redAccent : Colors.green,
      duration: const Duration(seconds: 10),
    ),
  );
}
