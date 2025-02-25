import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../core/globals.dart';
import 'base_colors.dart';

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

  void _logout(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (onPostLogout != null) {
      onPostLogout!();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SidebarXItem> sidebarItems = [];
    sidebarItems.addAll(additionalSidebarXItems);
    sidebarItems.addAll([
      SidebarXItem(
          icon: Icons.quora,
          label: tr("QA mode switch"),
          onTap: () {
            Globals.qaModeEnabled = !Globals.qaModeEnabled;
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
      theme: const SidebarXTheme(
        itemTextPadding: EdgeInsets.only(left: 10),
        selectedItemTextPadding: EdgeInsets.only(left: 10),
        itemPadding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: BaseColors.backgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        textStyle: TextStyle(color: Colors.white),
        selectedTextStyle: TextStyle(color: Colors.green),
      ),
      extendedTheme: const SidebarXTheme(width: 250),
      footerDivider: Divider(color: Colors.white.withOpacity(0.8), height: 1),
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 40,
          ),
          child: Column(children: [
            const Icon(
              Icons.person,
              size: 70,
              color: Colors.white,
              semanticLabel: "user",
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  Globals.applicationInfo.username,
                  style: const TextStyle(color: Colors.white),
                )),
            Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Text(
                  Globals.applicationInfo.userEmail,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                )),
          ]),
        );
      },
      items: sidebarItems,
    );
  }
}
