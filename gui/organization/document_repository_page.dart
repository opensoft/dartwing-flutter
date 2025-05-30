import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../network/dart_wing/data/organization.dart';
import '../base_apps_routers.dart';
import '../notification.dart';
import '../widgets/base_colors.dart';
import '../widgets/base_scaffold.dart';
import '../../network/network_clients.dart';

class DocumentRepositoryPage extends StatefulWidget {
  const DocumentRepositoryPage({super.key, required this.companyName});
  final String companyName;

  @override
  _DocumentRepositoryPageState createState() => _DocumentRepositoryPageState();
}

class _DocumentRepositoryPageState extends State<DocumentRepositoryPage> {
  bool _loadingOverlayEnabled = false;
  final _focusNode = FocusNode();

  final TextEditingController _folderPathController = TextEditingController();

  void _fetchOrganizationPath() {
    setState(() {
      _loadingOverlayEnabled = true;
    });
    NetworkClients.dartWingApi
        .fetchOrganizationPath(widget.companyName)
        .then((path) {
      setState(() {
        _folderPathController.text = path;
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
    _fetchOrganizationPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      loadingOverlayEnabled: _loadingOverlayEnabled,
      appBar: AppBar(
        backgroundColor: BaseColors.lightBackgroundColor,
        title: Row(children: [
          const Expanded(
              child: Text("Document Repository", textAlign: TextAlign.center)),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              PackageInfo.fromPlatform().then((packageInfo) {
                Navigator.of(context)
                    .pushNamed(BaseAppsRouters.oneDriveExplorerPage,
                        arguments: jsonEncode({
                          'clientId': '92a04c04-cc01-455d-87af-d083930583dd',
                          'redirectUrl': "${packageInfo.packageName}://auth"
                        }))
                    .then((_) {
                  _fetchOrganizationPath();
                });
              });

              return;
              Navigator.of(context)
                  .pushNamed(BaseAppsRouters.chooseDocumentRepositoryPage,
                      arguments: widget.companyName)
                  .then((_) {
                _fetchOrganizationPath();
              });
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Select",
                      style: TextStyle(fontSize: 16),
                    ))),
          )
        ]),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  readOnly: true,
                  //keyboardType: TextInputType.emailAddress,
                  controller: _folderPathController,
                  //style: const TextStyle(color: Colors.white),
                  onChanged: (_) {
                    setState(() {});
                  },
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: _folderPathController.text.isEmpty
                        ? "Please select folder"
                        : "Folder Path",
                    //labelStyle: const TextStyle(color: Colors.grey),
                    hintText: "Please select folder",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(),
                  ),
                )),
          ])),
    );
  }
}
