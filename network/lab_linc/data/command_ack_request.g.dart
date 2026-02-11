// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_ack_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommandAckRequest _$CommandAckRequestFromJson(Map<String, dynamic> json) =>
    CommandAckRequest()
      ..commandId = json['commandId'] as String?
      ..ackType = json['ackType'] as String?
      ..result = json['result'] as String?
      ..error = json['error'] as String?
      ..timestamp = json['timestamp'] as String?;

Map<String, dynamic> _$CommandAckRequestToJson(CommandAckRequest instance) =>
    <String, dynamic>{
      'commandId': ?instance.commandId,
      'ackType': ?instance.ackType,
      'result': ?instance.result,
      'error': ?instance.error,
      'timestamp': ?instance.timestamp,
    };
