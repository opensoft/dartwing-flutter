import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../core/logging/i_logger.dart';

void showInfoNotification(BuildContext context, String message) {
  GetIt.I<ILogger>().info(message);
  showNotification(context, message);
}

void showWarningNotification(BuildContext context, String message) {
  GetIt.I<ILogger>().warning(message);
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
