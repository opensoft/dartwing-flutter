import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../notification.dart';
import '../theme/dartwing_theme.dart';
import '../widgets/base_scaffold.dart';
import '../../network/dart_wing/data/organization.dart';
import '../../network/interfaces/i_dart_wing_api.dart';
import '../base_apps_routers.dart';

class CompanyInfoPage extends StatefulWidget {
  const CompanyInfoPage({super.key, required this.companyName});
  final String companyName;

  @override
  _CompanyInfoPageState createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  bool _loadingOverlayEnabled = false;
  final _focusNode = FocusNode();

  void _fetchOrganization() {
    setState(() {
      _loadingOverlayEnabled = true;
    });
    GetIt.I<IDartWingApi>()
        .fetchOrganization(widget.companyName)
        .then((company) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
    }).catchError((e) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
      showWarningNotification(context, e.toString());
    });
  }

  @override
  void initState() {
    _fetchOrganization();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(_focusNode));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DartwingTheme.of(context);

    return BaseScaffold(
      loadingOverlayEnabled: _loadingOverlayEnabled,
      appBar: AppBar(
        backgroundColor: theme.lightBackgroundColor,
        title: Row(children: [
          Expanded(child: Text("Company", textAlign: TextAlign.center)),
        ]),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                        onTap: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: SvgPicture.asset(
                                    'lib/dart_wing/gui/images/company_icon.svg',
                                    alignment: Alignment.center,
                                  )),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.companyName,
                                  style: const TextStyle(fontSize: 19),
                                ),
                              )),
                              Icon(Icons.navigate_next)
                            ]))))),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                        onTap: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "All Contacts",
                                  style: const TextStyle(fontSize: 19),
                                ),
                              )),
                              Icon(Icons.navigate_next)
                            ]))))),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                        onTap: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "All Departments",
                                  style: const TextStyle(fontSize: 19),
                                ),
                              )),
                              Icon(Icons.navigate_next)
                            ]))))),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                        onTap: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Legal",
                                  style: const TextStyle(fontSize: 19),
                                ),
                              )),
                              Icon(Icons.navigate_next)
                            ]))))),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                        onTap: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Industry",
                                  style: const TextStyle(fontSize: 19),
                                ),
                              )),
                              Icon(Icons.navigate_next)
                            ]))))),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                        onTap: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Tax",
                                  style: const TextStyle(fontSize: 19),
                                ),
                              )),
                              Icon(Icons.navigate_next)
                            ]))))),
            Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          BaseAppsRouters.documentRepositoryPage,
                          arguments: widget.companyName);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(children: [
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Document Repository",
                              style: const TextStyle(fontSize: 19),
                            ),
                          )),
                          Icon(Icons.navigate_next)
                        ])))),
          ])),
    );
  }
}
