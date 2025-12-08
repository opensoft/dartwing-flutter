import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../core/globals.dart';
import '../../network/paper_trail.dart';
import 'base_colors.dart';
import 'base_sidebar.dart';

class BaseScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigatorBar;
  final Widget body;
  String pageTitle;
  bool defaultAppMenuEnabled = false;
  List<SidebarXItem> additionalSidebarXItems = [];

  final void Function(String barcode)? onBarcodeFetched;
  final void Function()? onPostLogout;
  final bool loadingOverlayEnabled;
  Widget? floatingActionButton;
  bool canPop;

  BaseScaffold(
      {super.key,
      this.appBar,
      this.bottomNavigatorBar,
      required this.body,
      this.onBarcodeFetched,
      required this.loadingOverlayEnabled,
      this.floatingActionButton,
      this.canPop = true,
      this.pageTitle = '',
      this.onPostLogout,
      this.defaultAppMenuEnabled = false,
      this.additionalSidebarXItems = const []});

  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  final _sideBarController =
      SidebarXController(selectedIndex: 0, extended: true);
  final FocusNode _textNode = FocusNode();
  String _bufferForBarcode = "";
  bool _initFocus = false;
  final _key = GlobalKey<ScaffoldState>();

  RawKeyEvent _handleKey(RawKeyEvent key) {
    if (key is RawKeyDownEvent && key.character != null) {
      bool isControl = LogicalKeyboardKey.isControlCharacter(key.character!);
      bool isModifiers = key.data.isShiftPressed;
      bool isBackSpace = key.character == "\b";

      if (isBackSpace) {
        if (_bufferForBarcode.isNotEmpty) {
          _bufferForBarcode = _bufferForBarcode.replaceRange(
              _bufferForBarcode.length - 2, _bufferForBarcode.length - 1, '');
        }
      } else if (!(isControl && isModifiers)) {
        _bufferForBarcode += key.character!;
        //PaperTrailClient.sendInfoMessageToPaperTrail("Keyboard buffer: $_bufferForBarcode, character: ${key.character!} logicalKey: ${key.logicalKey!} physicalKey: ${key.physicalKey!} enter: ${key.character == "\n"} control: $isControl, modifiers: $isModifiers");
      }

      if (_bufferForBarcode
          .contains(Globals.applicationInfo.barcodeScanner.prefix)) {
        _bufferForBarcode = "";
      } else if ((_bufferForBarcode
                  .endsWith(Globals.applicationInfo.barcodeScanner.postfix) ||
              key.character == "\n" ||
              (isControl && !isModifiers && !isBackSpace)) &&
          _bufferForBarcode.length > 1) {
        String barcode = _bufferForBarcode
            .replaceAll(Globals.applicationInfo.barcodeScanner.postfix, '')
            .trim();
        _bufferForBarcode = "";
        PaperTrailClient.sendInfoMessageToPaperTrail(
            "Barcode: $barcode, character: ${key.character!} control: $isControl, modifiers: $isModifiers");
        PaperTrailClient.sendInfoMessageToPaperTrail(
            'QR or barcode (laser scanner): $barcode');
        if (widget.onBarcodeFetched != null) {
          widget.onBarcodeFetched!(barcode);
        }
      }
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    if (!_initFocus) {
      _initFocus = true;
      FocusScope.of(context).requestFocus(_textNode);
    }
    return Scaffold(
      key: _key,
      backgroundColor: BaseColors.backgroundColor, // const Color(0xFF605c7d)
      resizeToAvoidBottomInset: false,
      appBar: widget.appBar ??
          (widget.defaultAppMenuEnabled
              ? AppBar(
                  backgroundColor: BaseColors.lightBackgroundColor,
                  title: Text(widget.pageTitle),
                  leading: IconButton(
                    onPressed: () {
                      _key.currentState?.openDrawer();
                    },
                    icon: const Icon(Icons.menu),
                  ),
                )
              : null),
      bottomNavigationBar: widget.bottomNavigatorBar,
      floatingActionButton: widget.floatingActionButton,
      drawer: widget.defaultAppMenuEnabled
          ? BaseSideBar(
              controller: _sideBarController,
              additionalSidebarXItems: widget.additionalSidebarXItems,
              onPostLogout: widget.onPostLogout,
            )
          : null,
      body: PopScope(
        canPop: widget.canPop && !widget.loadingOverlayEnabled,
        child: RawKeyboardListener(
          focusNode: _textNode,
          onKey: (key) => _handleKey(key),
          child: Center(
            child: LoadingOverlay(
              isLoading: widget.loadingOverlayEnabled,
              child: SafeArea(
                left: false,
                right: false,
                child: widget.body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
