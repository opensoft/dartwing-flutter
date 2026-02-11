import 'package:json_annotation/json_annotation.dart';

part 'command_status_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CommandStatusResponse {
  @JsonKey(includeIfNull: false)
  String? commandId;
  @JsonKey(includeIfNull: false)
  String? commandType;
  @JsonKey(includeIfNull: false)
  String? publishStatus;
  @JsonKey(includeIfNull: false)
  String? ackStatus;
  @JsonKey(includeIfNull: false)
  String? publishedAtUtc;
  @JsonKey(includeIfNull: false)
  String? ackReceivedAtUtc;
  @JsonKey(includeIfNull: false)
  String? completedAtUtc;
  @JsonKey(includeIfNull: false)
  String? timeoutAtUtc;
  @JsonKey(includeIfNull: false)
  String? result;
  @JsonKey(includeIfNull: false)
  String? error;

  CommandStatusResponse();

  factory CommandStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$CommandStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommandStatusResponseToJson(this);
}
