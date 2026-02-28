import 'package:flutter/material.dart';

import '../organization/choose_document_repository_page.dart';
import '../organization/company_info_page.dart';
import '../organization/create_company_organization_page.dart';
import '../organization/document_repository_page.dart';
import '../organization/organizations_list_page.dart';
import '../organization/select_organization_type_page.dart';
import '../scanner_page.dart';
import 'i_screen_registry.dart';

class DefaultScreenRegistry implements IScreenRegistry {
  @override
  Widget getScannerScreen({
    required String pageTitle,
    required bool manualInputAllowed,
  }) {
    return ScannerPage(
      pageTitle: pageTitle,
      manualInputAllowed: manualInputAllowed,
    );
  }

  @override
  Widget getOrganizationsListScreen() {
    return const OrganizationsListPage();
  }

  @override
  Widget getSelectOrganizationTypeScreen() {
    return const SelectOrganizationTypePage();
  }

  @override
  Widget getCreateCompanyOrganizationScreen({
    required String descriptionOfOrganization,
  }) {
    return CreateCompanyOrganizationPage(
      descriptionOfOrganization: descriptionOfOrganization,
    );
  }

  @override
  Widget getCompanyInfoScreen({required String companyName}) {
    return CompanyInfoPage(companyName: companyName);
  }

  @override
  Widget getDocumentRepositoryScreen({required String companyName}) {
    return DocumentRepositoryPage(companyName: companyName);
  }

  @override
  Widget getChooseDocumentRepositoryScreen({required String companyName}) {
    return ChooseDocumentRepositoryPage(companyName: companyName);
  }
}
