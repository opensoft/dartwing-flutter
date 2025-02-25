import 'dart:convert';

import 'package:flutter/material.dart';

import 'scanner_page.dart';
import 'widgets/login_page.dart';

class BaseAppsRouters {
  static const String scannerPage = "scannerPage";
  static const String loginPage = "loginPage";

  @override
  static Future<dynamic> showScannerPage(BuildContext context, String pageTitle,
      {bool manualInputAllowed = true}) {
    return Navigator.of(context).pushNamed(BaseAppsRouters.scannerPage,
        arguments: jsonEncode({
          'pageTitle': pageTitle,
          'manualInputAllowed': manualInputAllowed
        }));
  }

  @override
  Route<dynamic> generateRouters(RouteSettings settings) {
    switch (settings.name) {
      case scannerPage:
        var jsonObject = jsonDecode(settings.arguments.toString());
        return MaterialPageRoute(
            builder: (_) => ScannerPage(
                  pageTitle: jsonObject['pageTitle'],
                  manualInputAllowed: jsonObject['manualInputAllowed'],
                ));
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                    body: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'No Page Found',
                  ),
                )));
    }
  }
}
