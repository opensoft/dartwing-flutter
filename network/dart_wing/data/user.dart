import 'package:json_annotation/json_annotation.dart';

import 'company.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(includeIfNull: false)
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String dateOfBirth = '';
  String address = '';
  String city = '';
  String state = '';
  String postalCode = '';
  String country = '';
  String gender = '';

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
