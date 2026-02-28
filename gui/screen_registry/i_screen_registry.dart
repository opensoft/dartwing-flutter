import 'package:flutter/material.dart';

abstract class IScreenRegistry {
  Widget getScannerScreen({
    required String pageTitle,
    required bool manualInputAllowed,
  });
  Widget getOrganizationsListScreen();
  Widget getSelectOrganizationTypeScreen();
  Widget getCreateCompanyOrganizationScreen({
    required String descriptionOfOrganization,
  });
  Widget getCompanyInfoScreen({required String companyName});
  Widget getDocumentRepositoryScreen({required String companyName});
  Widget getChooseDocumentRepositoryScreen({required String companyName});
}
