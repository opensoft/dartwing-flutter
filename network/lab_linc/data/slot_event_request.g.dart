// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotEventRequest _$SlotEventRequestFromJson(Map<String, dynamic> json) =>
    SlotEventRequest()
      ..eventId = json['eventId'] as String?
      ..slotNumber = _nullableIntFromJson(json['slotNumber'])
      ..status = json['status'] as String?
      ..dishExternalId = json['dishExternalId'] as String?
      ..patientExternalId = json['patientExternalId'] as String?
      ..timestamp = json['timestamp'] as String?;

Map<String, dynamic> _$SlotEventRequestToJson(SlotEventRequest instance) =>
    <String, dynamic>{
      'eventId': ?instance.eventId,
      'slotNumber': ?_nullableIntToJson(instance.slotNumber),
      'status': ?instance.status,
      'dishExternalId': ?instance.dishExternalId,
      'patientExternalId': ?instance.patientExternalId,
      'timestamp': ?instance.timestamp,
    };
