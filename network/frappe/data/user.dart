import 'package:json_annotation/json_annotation.dart';

import '../healthcare_api_helper.dart';
import 'role.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String? email;
  @JsonKey(includeIfNull: false, name: 'first_name')
  String? firstName;
  @JsonKey(includeIfNull: false, name: 'middle_name')
  String? middleName;
  @JsonKey(includeIfNull: false, name: 'last_name')
  String? lastName;
  @JsonKey(includeIfNull: false, name: 'full_name')
  String? fullName;
  String? language;
  @JsonKey(includeIfNull: false, name: 'send_welcome_email')
  int? sendWelcomeEmail;

  @JsonKey(includeIfNull: false)
  List<Role> roles = [];

  Role? getRole(Roles checkRole) {
    for (Role role in roles) {
      if (role.role.toLowerCase() == checkRole.name.toLowerCase()) {
        return role;
      }
    }
    return null;
  }

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
