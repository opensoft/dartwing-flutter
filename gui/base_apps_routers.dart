import 'dart:convert';

import 'package:flutter/material.dart';

import 'organization/choose_document_repository_page.dart';
import 'organization/company_info_page.dart';
import 'organization/create_company_organization_page.dart';
import 'organization/document_repository_page.dart';
import 'organization/organizations_list_page.dart';
import 'organization/select_organization_type_page.dart';
import 'scanner_page.dart';

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
          builder: (_) => ScannerPage(
            pageTitle: jsonObject['pageTitle'],
            manualInputAllowed: jsonObject['manualInputAllowed'],
          ),
        );
      case organizationsListPage:
        return MaterialPageRoute(builder: (_) => const OrganizationsListPage());
      case selectOrganizationTypePage:
        return MaterialPageRoute(
          builder: (_) => const SelectOrganizationTypePage(),
        );
      case createCompanyOrganizationPage:
        return MaterialPageRoute(
          builder: (_) => CreateCompanyOrganizationPage(
            descriptionOfOrganization: settings.arguments.toString(),
          ),
        );
      case companyInfoPage:
        return MaterialPageRoute(
          builder: (_) =>
              CompanyInfoPage(companyName: settings.arguments.toString()),
        );
      case documentRepositoryPage:
        return MaterialPageRoute(
          builder: (_) => DocumentRepositoryPage(
            companyName: settings.arguments.toString(),
          ),
        );
      case chooseDocumentRepositoryPage:
        return MaterialPageRoute(
          builder: (_) => ChooseDocumentRepositoryPage(
            companyName: settings.arguments.toString(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: const Text('No Page Found'),
            ),
          ),
        );
    }
  }
}
