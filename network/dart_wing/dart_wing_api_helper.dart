import 'package:json_annotation/json_annotation.dart';

enum OrganizationType {
  @JsonValue("Company")
  company,
  @JsonValue("Family")
  family,
  @JsonValue("Club")
  club,
  @JsonValue("Non profit")
  nonProfit
}
