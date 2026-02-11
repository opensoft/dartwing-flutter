// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommandStatusResponse _$CommandStatusResponseFromJson(
  Map<String, dynamic> json,
) => CommandStatusResponse()
  ..commandId = json['commandId'] as String?
  ..commandType = json['commandType'] as String?
  ..publishStatus = json['publishStatus'] as String?
  ..ackStatus = json['ackStatus'] as String?
  ..publishedAtUtc = json['publishedAtUtc'] as String?
  ..ackReceivedAtUtc = json['ackReceivedAtUtc'] as String?
  ..completedAtUtc = json['completedAtUtc'] as String?
  ..timeoutAtUtc = json['timeoutAtUtc'] as String?
  ..result = json['result'] as String?
  ..error = json['error'] as String?;

Map<String, dynamic> _$CommandStatusResponseToJson(
  CommandStatusResponse instance,
) => <String, dynamic>{
  'commandId': ?instance.commandId,
  'commandType': ?instance.commandType,
  'publishStatus': ?instance.publishStatus,
  'ackStatus': ?instance.ackStatus,
  'publishedAtUtc': ?instance.publishedAtUtc,
  'ackReceivedAtUtc': ?instance.ackReceivedAtUtc,
  'completedAtUtc': ?instance.completedAtUtc,
  'timeoutAtUtc': ?instance.timeoutAtUtc,
  'result': ?instance.result,
  'error': ?instance.error,
};
