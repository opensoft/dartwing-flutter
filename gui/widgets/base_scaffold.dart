import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../core/app_state.dart';
import '../../core/logging/i_logger.dart';
import '../theme/dartwing_theme.dart';
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
  bool enableKeyboardListener;

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
      this.additionalSidebarXItems = const [],
      this.enableKeyboardListener = true});

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

  AppState get _appState => GetIt.I<AppState>();
  ILogger get _logger => GetIt.I<ILogger>();

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
      }

      if (_bufferForBarcode
          .contains(_appState.applicationInfo.barcodeScanner.prefix)) {
        _bufferForBarcode = "";
      } else if ((_bufferForBarcode
                  .endsWith(_appState.applicationInfo.barcodeScanner.postfix) ||
              key.character == "\n" ||
              (isControl && !isModifiers && !isBackSpace)) &&
          _bufferForBarcode.length > 1) {
        String barcode = _bufferForBarcode
            .replaceAll(_appState.applicationInfo.barcodeScanner.postfix, '')
            .trim();
        _bufferForBarcode = "";
        _logger.info(
            "Barcode: $barcode, character: ${key.character!} control: $isControl, modifiers: $isModifiers");
        _logger.info('QR or barcode (laser scanner): $barcode');
        if (widget.onBarcodeFetched != null) {
          widget.onBarcodeFetched!(barcode);
        }
      }
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    final theme = DartwingTheme.of(context);

    if (!_initFocus && widget.enableKeyboardListener) {
      _initFocus = true;
      FocusScope.of(context).requestFocus(_textNode);
    }

    Widget bodyContent = Center(
      child: LoadingOverlay(
        isLoading: widget.loadingOverlayEnabled,
        child: SafeArea(
          left: false,
          right: false,
          child: widget.body,
        ),
      ),
    );

    if (widget.enableKeyboardListener) {
      bodyContent = RawKeyboardListener(
        focusNode: _textNode,
        onKey: (key) => _handleKey(key),
        child: bodyContent,
      );
    }

    return Scaffold(
      key: _key,
      backgroundColor: theme.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: widget.appBar ??
          (widget.defaultAppMenuEnabled
              ? AppBar(
                  backgroundColor: theme.lightBackgroundColor,
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
        child: bodyContent,
      ),
    );
  }
}
