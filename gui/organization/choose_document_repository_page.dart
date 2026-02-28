import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_state.dart';
import '../../core/logging/i_logger.dart';
import '../notification.dart';
import '../theme/dartwing_theme.dart';
import '../widgets/base_scaffold.dart';
import '../../network/dart_wing/data/folder.dart';
import '../../network/dart_wing/data/provider.dart';
import '../../network/interfaces/i_dart_wing_api.dart';

class ChooseDocumentRepositoryPage extends StatefulWidget {
  const ChooseDocumentRepositoryPage({super.key, required this.companyName});
  final String companyName;

  @override
  _ChooseDocumentRepositoryPageState createState() =>
      _ChooseDocumentRepositoryPageState();
}

class _ChooseDocumentRepositoryPageState
    extends State<ChooseDocumentRepositoryPage> {
  bool _loadingOverlayEnabled = false;

  List<Provider> _providers = [];
  Provider _currentProvider = Provider();

  List<Folder> _folders = [];

  final List<Folder> _selectedFolders = [];

  IDartWingApi get _dartWingApi => GetIt.I<IDartWingApi>();
  AppState get _appState => GetIt.I<AppState>();
  ILogger get _logger => GetIt.I<ILogger>();

  bool _canBeSelected() {
    return _selectedFolders.isNotEmpty
        ? _selectedFolders.last.canBeSelected
        : false;
  }

  String _currentPath() {
    List<String> folderNameList = [];
    for (var folder in _selectedFolders) {
      folderNameList.add(folder.name);
    }
    return folderNameList.join('/');
  }

  Future _saveFolderForDocumentRepository() {
    setState(() {
      _loadingOverlayEnabled = true;
    });
    return _dartWingApi
        .saveOrganizationPath(widget.companyName, _currentPath())
        .then((_) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
      Navigator.of(context).pop();
    }).catchError((e) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
      showWarningNotification(context, e.toString());
    });
  }

  void _fetchCompanyProviders() {
    setState(() {
      _loadingOverlayEnabled = true;
    });
    _dartWingApi
        .fetchOrganizationProviders(widget.companyName)
        .then((providers) {
      if (_currentProvider.name.isEmpty) {
        _currentProvider = Provider();
      }
      setState(() {
        _loadingOverlayEnabled = false;
        _providers = providers;
        _setProvider(providers.first);
      });
    }).catchError((e) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
      showWarningNotification(context, e.toString());
    });
  }

  Future _fetchFolders() {
    setState(() {
      _loadingOverlayEnabled = true;
    });
    return _dartWingApi
        .fetchFolders(_currentProvider.alias.toString(), widget.companyName,
            _currentPath())
        .then((folderResponse) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
      if (folderResponse.folders != null) {
        _folders = folderResponse.folders!;
      }

      if (folderResponse.redirectUrl != null &&
          folderResponse.redirectUrl!.isNotEmpty) {
        Uri uri = Uri.parse(folderResponse.redirectUrl!);

        final updatedQueryParams =
            Map<String, String>.from(uri.queryParameters);
        if (kIsWeb) {
          updatedQueryParams['redirect_uri'] = _appState.qaModeEnabled
              ? 'https://app-dev.ledgerlinc.com'
              : 'https://app.ledgerlinc.com';
        } else {
          updatedQueryParams['redirect_uri'] =
              'com.opensoft.ledgerlinc://login-callback';
        }
        Uri updatedUri = uri.replace(
          queryParameters: updatedQueryParams,
        );

        _logger.info(updatedUri.toString());
        launchUrl(updatedUri, mode: LaunchMode.externalApplication)
            .then((success) {
          Navigator.of(context).pop();
        });
      }
    }).catchError((e) {
      setState(() {
        _loadingOverlayEnabled = false;
      });
      showWarningNotification(context, e.toString());
    });
  }

  void _setProvider(Provider provider) {
    bool fetchFoldersNeeded = false;
    if (_currentProvider.alias != provider.alias) {
      fetchFoldersNeeded = true;
    }
    setState(() {
      _currentProvider = provider;
    });
    if (fetchFoldersNeeded) {
      _fetchFolders();
    }
  }

  @override
  void initState() {
    _providers.add(_currentProvider);
    _fetchCompanyProviders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DartwingTheme.of(context);

    return BaseScaffold(
      loadingOverlayEnabled: _loadingOverlayEnabled,
      appBar: AppBar(
        backgroundColor: theme.lightBackgroundColor,
        title: Row(children: [
          Expanded(
              child: Text("Choose Document Repository",
                  textAlign: TextAlign.center)),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (_selectedFolders.isNotEmpty) {
                    _selectedFolders.removeLast();
                  }
                  _fetchFolders();
                },
                tooltip: 'Back',
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(_currentPath(),
                          style: TextStyle(fontSize: 14)))),
              IconButton(
                iconSize: 25,
                icon: Icon(Icons.save),
                onPressed:
                    _canBeSelected() ? _saveFolderForDocumentRepository : null,
                tooltip: 'Save Directory',
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<Provider>(
                isExpanded: true,
                alignment: AlignmentDirectional.center,
                initialValue: _currentProvider,
                icon: const Icon(Icons.arrow_downward),
                iconEnabledColor: Colors.white,
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 22),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onChanged: (Provider? provider) {
                  _setProvider(provider!);
                },
                items: _providers
                    .map<DropdownMenuItem<Provider>>((Provider provider) {
                  return DropdownMenuItem<Provider>(
                    value: provider,
                    child: Center(
                      child: Text(
                        provider.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _folders.length,
              itemBuilder: (context, index) {
                final folder = _folders[index];
                return ListTile(
                    leading: Icon(Icons.folder),
                    title: Text(folder.displayName),
                    subtitle: Text(folder.folderType),
                    onTap: () {
                      _selectedFolders.add(folder);
                      _fetchFolders();
                    });
              },
            )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[200],
                      minimumSize: const Size.fromHeight(60),
                    ),
                    onPressed: _selectedFolders.isNotEmpty && _canBeSelected()
                        ? () {
                            _saveFolderForDocumentRepository();
                          }
                        : null,
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          "Select",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ]))),
          ],
        ),
      ),
    );
  }
}
