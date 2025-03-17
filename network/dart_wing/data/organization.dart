import 'package:json_annotation/json_annotation.dart';
import '../dart_wing_api_helper.dart';

part 'organization.g.dart';

@JsonSerializable(explicitToJson: true)
class Organization {
  @JsonKey(includeIfNull: false)
  String id = '';
  String name = '';
  OrganizationType type = OrganizationType.company;

  Organization();

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}
