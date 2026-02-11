import 'package:json_annotation/json_annotation.dart';

part 'auth_code_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthCodeResponse {
  String code = '';
  String expiresAtUtc = '';

  @JsonKey(defaultValue: 0, fromJson: _intFromJson, toJson: _intToJson)
  int expiresInSeconds = 0;

  AuthCodeResponse();

  factory AuthCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthCodeResponseToJson(this);
}

int _intFromJson(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

dynamic _intToJson(int value) => value;
