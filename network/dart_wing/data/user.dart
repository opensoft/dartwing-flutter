import 'package:json_annotation/json_annotation.dart';

import 'organization.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(includeIfNull: false)
  String? firstName;
  String? lastName;
  String email = '';

  @JsonKey(includeIfNull: false)
  String? phoneNumber;
  @JsonKey(includeIfNull: false)
  String? dateOfBirth;
  @JsonKey(includeIfNull: false)
  String? address;
  @JsonKey(includeIfNull: false)
  String? city;
  @JsonKey(includeIfNull: false)
  String? state;
  @JsonKey(includeIfNull: false)
  String? postalCode;
  @JsonKey(includeIfNull: false)
  String? country;
  @JsonKey(includeIfNull: false)
  String? gender;
  @JsonKey(defaultValue: [])
  List<Organization> companies = [];

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
