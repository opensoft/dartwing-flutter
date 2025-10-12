class AppInfo {
  AppInfo(
      {required this.label,
      required this.pageName,
      required this.icon,
      this.arguments});

  final String label;
  final String pageName;
  final String icon;
  Object? arguments;
}
