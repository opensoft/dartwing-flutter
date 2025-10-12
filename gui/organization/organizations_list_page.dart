import 'dart:core';

import 'package:flutter/material.dart';

import '../../network/dart_wing/data/organization.dart';
import '../base_apps_routers.dart';
import '../notification.dart';
import '../widgets/base_colors.dart';
import '../widgets/base_scaffold.dart';
import '../../network/network_clients.dart';

class OrganizationsListPage extends StatefulWidget {
  const OrganizationsListPage({super.key});

  @override
  _OrganizationsListPageState createState() => _OrganizationsListPageState();
}

class _OrganizationsListPageState extends State<OrganizationsListPage> {
  bool _loadingOverlayEnabled = false;
  final _focusNode = FocusNode();

  List<Organization> _organizations = [];

  void _fetchOrganizations() {
    setState(() {
      _loadingOverlayEnabled = true;
    });
    NetworkClients.dartWingApi.fetchOrganizations().then((organizations) {
      setState(() {
        _organizations = organizations;
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
    _fetchOrganizations();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(_focusNode));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      loadingOverlayEnabled: _loadingOverlayEnabled,
      appBar: AppBar(
        backgroundColor: BaseColors.lightBackgroundColor,
        title: Row(children: [
          Expanded(child: Text("Organizations", textAlign: TextAlign.center)),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(BaseAppsRouters.selectOrganizationTypePage);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Add",
                      style: TextStyle(fontSize: 16),
                    ))),
          )
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  itemCount: _organizations.length,
                  separatorBuilder: (context, index) => const Divider(
                        indent: 8,
                        color: Colors.grey,
                      ),
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(
                              8), // Optional rounded corners
                        ),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(BaseAppsRouters.companyInfoPage,
                                      arguments: _organizations[i].name)
                                  .then((_) {
                                _fetchOrganizations();
                              });
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(children: [
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _organizations[i].name ?? '',
                                      style: const TextStyle(fontSize: 19),
                                    ),
                                  )),
                                  const Icon(Icons.navigate_next)
                                ]))));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
