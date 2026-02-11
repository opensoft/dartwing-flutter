import 'package:json_annotation/json_annotation.dart';

part 'slot_event_request.g.dart';

@JsonSerializable(explicitToJson: true)
class SlotEventRequest {
  @JsonKey(includeIfNull: false)
  String? eventId;
  @JsonKey(
    includeIfNull: false,
    fromJson: _nullableIntFromJson,
    toJson: _nullableIntToJson,
  )
  int? slotNumber;
  @JsonKey(includeIfNull: false)
  String? status;
  @JsonKey(includeIfNull: false)
  String? dishExternalId;
  @JsonKey(includeIfNull: false)
  String? patientExternalId;
  @JsonKey(includeIfNull: false)
  String? timestamp;

  SlotEventRequest();

  factory SlotEventRequest.fromJson(Map<String, dynamic> json) =>
      _$SlotEventRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SlotEventRequestToJson(this);
}

int? _nullableIntFromJson(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

dynamic _nullableIntToJson(int? value) => value;
