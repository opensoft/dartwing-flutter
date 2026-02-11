// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MqttConfigResponse _$MqttConfigResponseFromJson(Map<String, dynamic> json) =>
    MqttConfigResponse()
      ..commandTopic = json['commandTopic'] as String
      ..sessionTopic = json['sessionTopic'] as String
      ..responseTopic = json['responseTopic'] as String
      ..brokerHost = json['brokerHost'] as String
      ..brokerPort = json['brokerPort'] == null
          ? 0
          : _intFromJson(json['brokerPort']);

Map<String, dynamic> _$MqttConfigResponseToJson(MqttConfigResponse instance) =>
    <String, dynamic>{
      'commandTopic': instance.commandTopic,
      'sessionTopic': instance.sessionTopic,
      'responseTopic': instance.responseTopic,
      'brokerHost': instance.brokerHost,
      'brokerPort': _intToJson(instance.brokerPort),
    };
