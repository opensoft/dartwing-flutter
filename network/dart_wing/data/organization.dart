import 'package:json_annotation/json_annotation.dart';
import '../dart_wing_api_helper.dart';

part 'organization.g.dart';

@JsonSerializable(explicitToJson: true)
class Organization {
  @JsonKey(includeIfNull: false)
  String? id;
  @JsonKey(includeIfNull: false)
  String? name;
  @JsonKey(includeIfNull: false)
  String? abbreviation;
  @JsonKey(includeIfNull: false)
  String? currency;
  @JsonKey(includeIfNull: false)
  String? country;
  @JsonKey(includeIfNull: false)
  String? domain;
  @JsonKey(includeIfNull: false)
  bool? isEnabled;
  @JsonKey(includeIfNull: false)
  OrganizationType? companyType;
  @JsonKey(includeIfNull: false)
  String? microsoftSharepointFolderPath;
  @JsonKey(defaultValue: [])
  List<String> invoicesWhitelist = [];
  @JsonKey(includeIfNull: false)
  List<String>? permissions;
  String frappeSiteUrl = '';

  Organization();

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}
