import 'package:json_annotation/json_annotation.dart';

part 'command_ack_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CommandAckRequest {
  @JsonKey(includeIfNull: false)
  String? commandId;
  @JsonKey(includeIfNull: false)
  String? ackType;
  @JsonKey(includeIfNull: false)
  String? result;
  @JsonKey(includeIfNull: false)
  String? error;
  @JsonKey(includeIfNull: false)
  String? timestamp;

  CommandAckRequest();

  factory CommandAckRequest.fromJson(Map<String, dynamic> json) =>
      _$CommandAckRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CommandAckRequestToJson(this);
}
