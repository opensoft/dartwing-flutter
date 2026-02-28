import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../base_apps_routers.dart';
import '../notification.dart';
import '../theme/dartwing_theme.dart';
import '../widgets/base_scaffold.dart';
import '../../network/interfaces/i_dart_wing_api.dart';

class DocumentRepositoryPage extends StatefulWidget {
  const DocumentRepositoryPage({super.key, required this.companyName});
  final String companyName;

  @override
  _DocumentRepositoryPageState createState() => _DocumentRepositoryPageState();
}

class _DocumentRepositoryPageState extends State<DocumentRepositoryPage> {
  bool _loadingOverlayEnabled = false;

  final TextEditingController _folderPathController = TextEditingController();

  IDartWingApi get _dartWingApi => GetIt.I<IDartWingApi>();

  void _fetchOrganizationPath() {
    setState(() {
      _loadingOverlayEnabled = true;
    });
    _dartWingApi
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
  void dispose() {
    _folderPathController.dispose();
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
          const Expanded(
              child: Text("Document Repository", textAlign: TextAlign.center)),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
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
                  controller: _folderPathController,
                  onChanged: (_) {
                    setState(() {});
                  },
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: _folderPathController.text.isEmpty
                        ? "Please select folder"
                        : "Folder Path",
                    hintText: "Please select folder",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(),
                  ),
                )),
          ])),
    );
  }
}
