import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'screen_registry/i_screen_registry.dart';

class BaseAppsRouters {
  static const String scannerPage = "scannerPage";

  static const String organizationsListPage = 'organizationsListPage';
  static const String selectOrganizationTypePage = 'selectOrganizationTypePage';
  static const String createCompanyOrganizationPage =
      'createCompanyOrganizationPage';
  static const String companyInfoPage = "companyInfoPage";
  static const String documentRepositoryPage = "documentRepositoryPage";
  static const String chooseDocumentRepositoryPage =
      "chooseDocumentRepositoryPage";
  static const String oneDriveExplorerPage = "oneDriveExplorerPage";

  IScreenRegistry get _screenRegistry => GetIt.I<IScreenRegistry>();

  @override
  static Future<dynamic> showScannerPage(
    BuildContext context,
    String pageTitle, {
    bool manualInputAllowed = true,
  }) {
    return Navigator.of(context).pushNamed(
      BaseAppsRouters.scannerPage,
      arguments: jsonEncode({
        'pageTitle': pageTitle,
        'manualInputAllowed': manualInputAllowed,
      }),
    );
  }

  @override
  Route<dynamic> generateRouters(RouteSettings settings) {
    switch (settings.name) {
      case scannerPage:
        var jsonObject = jsonDecode(settings.arguments.toString());
        return MaterialPageRoute(
          builder: (_) => _screenRegistry.getScannerScreen(
            pageTitle: jsonObject['pageTitle'],
            manualInputAllowed: jsonObject['manualInputAllowed'],
          ),
        );
      case organizationsListPage:
        return MaterialPageRoute(
          builder: (_) => _screenRegistry.getOrganizationsListScreen(),
        );
      case selectOrganizationTypePage:
        return MaterialPageRoute(
          builder: (_) => _screenRegistry.getSelectOrganizationTypeScreen(),
        );
      case createCompanyOrganizationPage:
        return MaterialPageRoute(
          builder: (_) =>
              _screenRegistry.getCreateCompanyOrganizationScreen(
            descriptionOfOrganization: settings.arguments.toString(),
          ),
        );
      case companyInfoPage:
        return MaterialPageRoute(
          builder: (_) => _screenRegistry.getCompanyInfoScreen(
            companyName: settings.arguments.toString(),
          ),
        );
      case documentRepositoryPage:
        return MaterialPageRoute(
          builder: (_) => _screenRegistry.getDocumentRepositoryScreen(
            companyName: settings.arguments.toString(),
          ),
        );
      case chooseDocumentRepositoryPage:
        return MaterialPageRoute(
          builder: (_) => _screenRegistry.getChooseDocumentRepositoryScreen(
            companyName: settings.arguments.toString(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('No Page Found')),
            body: const Center(child: Text('No Page Found')),
          ),
        );
    }
  }
}
