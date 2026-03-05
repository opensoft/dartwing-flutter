import 'dart:core';

import 'package:flutter/material.dart';

import '../base_apps_routers.dart';
import '../notification.dart';
import '../widgets/base_colors.dart';
import '../widgets/base_scaffold.dart';
import '../../network/dart_wing/dart_wing_api_helper.dart';
import '../../network/dart_wing/data/organization.dart';
import '../../network/network_clients.dart';

class CreateCompanyOrganizationPage extends StatefulWidget {
  const CreateCompanyOrganizationPage(
      {super.key, required this.descriptionOfOrganization});
  final String descriptionOfOrganization;

  @override
  State<CreateCompanyOrganizationPage> createState() =>
      _CreateCompanyOrganizationPageState();
}

class _CreateCompanyOrganizationPageState
    extends State<CreateCompanyOrganizationPage> {
  bool _loadingOverlayEnabled = false;
  final TextEditingController _organizationNameController =
      TextEditingController();
  final TextEditingController _organizationAbbrController =
      TextEditingController();
  final _focusNode = FocusNode();
  final Organization _organization = Organization();

  void _createCompany() {
    _organization.name = _organizationNameController.text;
    _organization.abbreviation = _organizationAbbrController.text;
    _organization.country = "United States";
    _organization.currency = "USD";
    _organization.companyType = OrganizationType.company;
    setState(() {
      _loadingOverlayEnabled = true;
    });
    NetworkClients.dartWingApi
        .createOrganization(_organization)
        .then((company) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loadingOverlayEnabled = false;
      });
      Navigator.of(context)
          .pushNamed(BaseAppsRouters.companyInfoPage, arguments: company.name);
    }).catchError((e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loadingOverlayEnabled = false;
      });
      showWarningNotification(context, e.toString());
    });
  }

  @override
  void initState() {
    _organization.companyType = OrganizationType.company;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(_focusNode));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _organizationNameController.dispose();
    _organizationAbbrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      loadingOverlayEnabled: _loadingOverlayEnabled,
      appBar: AppBar(
        backgroundColor: BaseColors.lightBackgroundColor,
        title: Row(children: [
          Expanded(
              child: Text(
                  widget.descriptionOfOrganization.toString().toUpperCase(),
                  textAlign: TextAlign.center)),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Flexible(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      //keyboardType: TextInputType.emailAddress,
                      controller: _organizationNameController,
                      //style: const TextStyle(color: Colors.white),
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: "Company Name",
                        //labelStyle: const TextStyle(color: Colors.grey),
                        hintText: "Company Name",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(),
                      ),
                    ))),
            Flexible(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      //keyboardType: TextInputType.emailAddress,
                      controller: _organizationAbbrController,
                      //style: const TextStyle(color: Colors.white),
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: "Abbreviation",
                        //labelStyle: const TextStyle(color: Colors.grey),
                        hintText: "Abbreviation",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(),
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[200],
                      minimumSize: const Size.fromHeight(60),
                    ),
                    onPressed: _organizationNameController.text.isNotEmpty &&
                            _organizationAbbrController.text.isNotEmpty
                        ? () {
                            _createCompany();
                          }
                        : null,
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          "Create",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ])))
          ],
        ),
      ),
    );
  }
}
