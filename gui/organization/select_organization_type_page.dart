import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../base_apps_routers.dart';
import '../gui_helper.dart';
import '../widgets/base_colors.dart';
import '../widgets/base_scaffold.dart';
import '../../network/dart_wing/dart_wing_api_helper.dart';

class SelectOrganizationTypePage extends StatefulWidget {
  const SelectOrganizationTypePage({super.key});

  @override
  State<SelectOrganizationTypePage> createState() =>
      _SelectOrganizationTypePageState();
}

class _SelectOrganizationTypePageState
    extends State<SelectOrganizationTypePage> {
  final bool _loadingOverlayEnabled = false;
  final TextEditingController _organizationDescriptionController =
      TextEditingController();
  final _focusNode = FocusNode();
  OrganizationType? _selectedOrganizationType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => FocusScope.of(context).requestFocus(_focusNode),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _organizationDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      loadingOverlayEnabled: _loadingOverlayEnabled,
      appBar: AppBar(
        backgroundColor: BaseColors.lightBackgroundColor,
        title: Row(
          children: [
            Expanded(
              child: Text("Add Organization", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            RadioGroup<OrganizationType>(
              groupValue: _selectedOrganizationType,
              onChanged: (OrganizationType? value) {
                setState(() {
                  _selectedOrganizationType = value;
                });
              },
              child: Column(
                children: <Widget>[
                  RadioListTile<OrganizationType>(
                    secondary: SvgPicture.asset(
                      'lib/dart_wing/gui/images/company_icon.svg',
                      alignment: Alignment.center,
                      //width: 50,
                    ),
                    title: Text(
                      organizationInfoByType[OrganizationType.company]!.label,
                    ),
                    value: OrganizationType.company,
                  ),
                  RadioListTile<OrganizationType>(
                    secondary: SvgPicture.asset(
                      'lib/dart_wing/gui/images/family_icon.svg',
                      alignment: Alignment.center,
                      //width: 50,
                    ),
                    title: Text(
                      organizationInfoByType[OrganizationType.family]!.label,
                    ),
                    value: OrganizationType.family,
                  ),
                  RadioListTile<OrganizationType>(
                    secondary: SvgPicture.asset(
                      'lib/dart_wing/gui/images/club_icon.svg',
                      alignment: Alignment.center,
                      //width: 50,
                    ),
                    title: Text(
                      organizationInfoByType[OrganizationType.club]!.label,
                    ),
                    value: OrganizationType.club,
                  ),
                  RadioListTile<OrganizationType>(
                    secondary: SvgPicture.asset(
                      'lib/dart_wing/gui/images/nonprofit_icon.svg',
                      alignment: Alignment.center,
                      //width: 50,
                    ),
                    title: Text(
                      organizationInfoByType[OrganizationType.nonProfit]!.label,
                    ),
                    value: OrganizationType.nonProfit,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  //keyboardType: TextInputType.emailAddress,
                  controller: _organizationDescriptionController,
                  //style: const TextStyle(color: Colors.white),
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: "Description",
                    //labelStyle: const TextStyle(color: Colors.grey),
                    hintText: "Description",
                    //hintStyle: const TextStyle(color: Colors.white24),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[200],
                  minimumSize: const Size.fromHeight(60),
                ),
                onPressed: _selectedOrganizationType != null
                    ? () {
                        if (_selectedOrganizationType ==
                            OrganizationType.company) {
                          Navigator.of(context).pushNamed(
                            BaseAppsRouters.createCompanyOrganizationPage,
                            arguments: _organizationDescriptionController.text,
                          );
                        } else if (_selectedOrganizationType ==
                            OrganizationType.family) {
                          Navigator.of(context).pushNamed(
                            BaseAppsRouters.createCompanyOrganizationPage,
                            arguments: _organizationDescriptionController.text,
                          );
                        } else if (_selectedOrganizationType ==
                            OrganizationType.club) {
                          Navigator.of(context).pushNamed(
                            BaseAppsRouters.createCompanyOrganizationPage,
                            arguments: _organizationDescriptionController.text,
                          );
                        } else if (_selectedOrganizationType ==
                            OrganizationType.nonProfit) {
                          Navigator.of(context).pushNamed(
                            BaseAppsRouters.createCompanyOrganizationPage,
                            arguments: _organizationDescriptionController.text,
                          );
                        }
                      }
                    : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Add",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
