import 'package:json_annotation/json_annotation.dart';

part 'mqtt_config_response.g.dart';

@JsonSerializable(explicitToJson: true)
class MqttConfigResponse {
  String commandTopic = '';
  String sessionTopic = '';
  String responseTopic = '';
  String brokerHost = '';

  @JsonKey(defaultValue: 0, fromJson: _intFromJson, toJson: _intToJson)
  int brokerPort = 0;

  MqttConfigResponse();

  factory MqttConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$MqttConfigResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConfigResponseToJson(this);
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
