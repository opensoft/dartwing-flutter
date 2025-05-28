import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_onedrive/flutter_onedrive.dart';
import 'package:flutter_onedrive/onedrive_file.dart';
//import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../notification.dart';
import '../widgets/base_colors.dart';
import '../widgets/base_scaffold.dart';

class OneDriveExplorerPage extends StatefulWidget {
  const OneDriveExplorerPage(
      {super.key, required this.clientId, required this.redirectUrl});
  final String clientId;
  final String redirectUrl;

  @override
  _OneDriveExplorerPageState createState() => _OneDriveExplorerPageState();
}

class _OneDriveExplorerPageState extends State<OneDriveExplorerPage> {
  late final OneDrive _oneDrive;

  String _currentPath = '/';
  List<OnedriveFile> files = [];
  bool _loadingOverlayEnabled = false;

  @override
  void initState() {
    super.initState();
    _oneDrive =
        OneDrive(clientID: widget.clientId, redirectURL: widget.redirectUrl);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _oneDrive.connect(context).then((success) {
        if (success) {
          _loadFiles();
        }
      }).catchError((e) {
        showWarningNotification(context, e.toString());
      });
    });
  }

  Future<void> _loadFiles() async {
    setState(() {
      _loadingOverlayEnabled = true;
    });
    try {
      final listedFiles = await _oneDrive.listFiles(_currentPath);
      setState(() {
        files = listedFiles;
      });
    } catch (e) {
      _showError('Failed to load files: $e');
    } finally {
      setState(() {
        _loadingOverlayEnabled = false;
      });
    }
  }

  Future<void> _uploadFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final localPath = result.files.single.path!;
      final fileName = result.files.single.name;
      final remotePath = path.join(_currentPath, fileName);
      try {
        final fileBytes = await File(localPath).readAsBytes();
        await _oneDrive.push(fileBytes, remotePath);
        _loadFiles();
      } catch (e) {
        _showError('Upload failed: $e');
      }
    }
  }

  Future<void> _downloadFile(OnedriveFile file) async {
    try {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        _showError('Storage permission denied. Cannot download the file.');
        return;
      }

      // Use the Downloads directory if possible, else fallback to documents directory
      Directory? downloadsDir;

      try {
        downloadsDir = await getDownloadsDirectory();
      } catch (_) {
        // If getDownloadsDirectory is unavailable (e.g., on iOS), fallback
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null || !await downloadsDir.exists()) {
        _showError('Unable to access a downloads folder.');
        return;
      }

      final localPath = path.join(downloadsDir.path, file.name);
      final response = await _oneDrive.pull(file.path);

      if (response.isSuccess) {
        final fileOnDevice = File(localPath);
        await fileOnDevice.create(recursive: true);
        await fileOnDevice.writeAsBytes(response.bodyBytes?.toList() ?? []);
        _showMessage('Downloaded to $localPath', localPath);
      } else {
        _showError('Download failed: ${response.message}');
      }
    } catch (e) {
      _showError('Download failed: $e');
    }
  }

  Future<void> _deleteFile(OnedriveFile file) async {
    try {
      await _oneDrive.deleteFile(file.path);
      _loadFiles();
    } catch (e) {
      _showError('Delete failed: $e');
    }
  }

  Future<void> _createDirectory() async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Directory'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Directory Name'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final dirName = controller.text.trim();
              if (dirName.isNotEmpty) {
                final dirPath = path.join(_currentPath, dirName);
                try {
                  await _oneDrive.createDirectory(dirPath);
                  _loadFiles();
                } catch (e) {
                  _showError('Create directory failed: $e');
                }
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text('Create'),
          ),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel')),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void _showMessage(String message, String? filePath) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: filePath == null
            ? null
            : SnackBarAction(
                label: 'Open',
                onPressed: () {
                  //OpenFile.open(filePath);
                },
              ),
      ),
    );
  }

  void _enterDirectory(OnedriveFile file) {
    setState(() {
      _currentPath = file.path;
    });
    _loadFiles();
  }

  Future<void> _refresh() async {
    await _loadFiles();
  }

  Future<void> _disconnect() async {
    await _oneDrive.disconnect();
    Navigator.of(context).pop();
  }

  void _saveDirectory() {
    Navigator.of(context).pop(_currentPath);
  }

  Widget _pathWidget() {
    return Row(children: [
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(_currentPath, style: TextStyle(fontSize: 20)))),
      IconButton(
        icon: Icon(Icons.save),
        onPressed: _saveDirectory,
        tooltip: 'Save Directory',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BaseScaffold(
          loadingOverlayEnabled: _loadingOverlayEnabled,
          appBar: AppBar(
            backgroundColor: BaseColors.lightBackgroundColor,
            title: Text('Choose Repository', style: TextStyle(fontSize: 17)),
            actions: [
              IconButton(
                icon: Icon(Icons.create_new_folder),
                onPressed: _createDirectory,
                tooltip: 'New Directory',
              ),
              IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _refresh,
                  tooltip: 'Refresh'),
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: _disconnect,
                  tooltip: 'Disconnect'),
            ],
          ),
          body: _loadingOverlayEnabled
              ? Center(child: CircularProgressIndicator())
              : files.isEmpty
                  ? Center(
                      child: Column(
                          children: [_pathWidget(), Text('No files here')]))
                  : Column(children: [
                      _pathWidget(),
                      Expanded(
                          child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          return ListTile(
                            leading: Icon(file.isFolder
                                ? Icons.folder
                                : Icons.insert_drive_file),
                            title: Text(file.name),
                            subtitle: Text(file.isFolder
                                ? 'Directory'
                                : '${file.size} bytes'),
                            onTap: () {
                              if (file.isFolder) {
                                _enterDirectory(file);
                              } else {
                                _downloadFile(file);
                              }
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteFile(file),
                            ),
                          );
                        },
                      )),
                    ])),
    );
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }
    // fallback for older devices
    final storageStatus = await Permission.manageExternalStorage.request();
    if (storageStatus.isGranted) {
      return true;
    }
    // fallback for older devices
    return await Permission.storage.request().isGranted;
  }

  Future<bool> _onWillPop() async {
    if (_currentPath == '/' || _currentPath.isEmpty) {
      return true;
    } else {
      _goOneLevelUp();
      return false;
    }
  }

  void _goOneLevelUp() {
    if (_currentPath == '/' || _currentPath.isEmpty) {
      return;
    }
    final parentPath = path.dirname(_currentPath);
    setState(() {
      _currentPath = (parentPath == '.' || parentPath == '') ? '/' : parentPath;
    });
    _loadFiles();
  }
}
