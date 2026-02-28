import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../core/app_state.dart';
import '../theme/dartwing_theme.dart';

class BaseSideBar extends StatelessWidget {
  BaseSideBar({
    super.key,
    required SidebarXController controller,
    this.onPostLogout,
    this.additionalSidebarXItems = const [],
  }) : _controller = controller;
  final SidebarXController _controller;
  final void Function()? onPostLogout;
  List<SidebarXItem> additionalSidebarXItems = const [];

  AppState get _appState => GetIt.I<AppState>();

  void _logout(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (onPostLogout != null) {
      onPostLogout!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = DartwingTheme.of(context);

    List<SidebarXItem> sidebarItems = [];
    sidebarItems.addAll(additionalSidebarXItems);
    sidebarItems.addAll([
      SidebarXItem(
          icon: Icons.quora,
          label: tr("QA mode switch"),
          onTap: () {
            _appState.qaModeEnabled = !_appState.qaModeEnabled;
            _logout(context);
          }),
      SidebarXItem(
          icon: Icons.exit_to_app,
          label: tr('Logout'),
          onTap: () {
            _logout(context);
          }),
    ]);
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        itemTextPadding: const EdgeInsets.only(left: 10),
        selectedItemTextPadding: const EdgeInsets.only(left: 10),
        itemPadding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        selectedTextStyle: null,
        selectedItemDecoration: null,
      ),
      extendedTheme: const SidebarXTheme(width: 250),
      footerDivider: Divider(color: Colors.black.withOpacity(0.8), height: 1),
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 40,
          ),
          child: Column(children: [
            const Icon(
              Icons.person,
              size: 70,
              semanticLabel: "user",
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  _appState.applicationInfo.username,
                )),
            Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Text(
                  _appState.applicationInfo.userEmail,
                  style: const TextStyle(fontSize: 10),
                )),
          ]),
        );
      },
      items: sidebarItems,
    );
  }
}
