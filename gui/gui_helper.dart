import 'package:dart_wing_mobile/dart_wing/network/dart_wing/dart_wing_api_helper.dart';

import 'data/organization_info.dart';

Map<OrganizationType, OrganizationInfo> organizationInfoByType = {
  OrganizationType.company:
      OrganizationInfo(label: "Company", icon: "images/company_icon.svg"),
  OrganizationType.family:
      OrganizationInfo(label: "Family", icon: "images/family_icon.svg"),
  OrganizationType.club:
      OrganizationInfo(label: "Club", icon: "images/club_icon.svg"),
  OrganizationType.nonProfit:
      OrganizationInfo(label: "Non profit", icon: "images/nonprofit_icon.svg")
};
