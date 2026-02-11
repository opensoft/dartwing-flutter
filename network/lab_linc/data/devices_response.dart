import 'package:json_annotation/json_annotation.dart';

import 'device_info.dart';

part 'devices_response.g.dart';

@JsonSerializable(explicitToJson: true)
class DevicesResponse {
  List<DeviceInfo> items = [];

  @JsonKey(defaultValue: 0, fromJson: _intFromJson, toJson: _intToJson)
  int totalCount = 0;

  @JsonKey(defaultValue: 0, fromJson: _intFromJson, toJson: _intToJson)
  int page = 0;

  @JsonKey(defaultValue: 0, fromJson: _intFromJson, toJson: _intToJson)
  int pageSize = 0;

  DevicesResponse();

  factory DevicesResponse.fromJson(Map<String, dynamic> json) =>
      _$DevicesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DevicesResponseToJson(this);
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
