import 'package:json_annotation/json_annotation.dart';

import 'company.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(includeIfNull: false)
  String id = '';
  String name = '';
  String email = '';
  List<Company> companies = [];

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
