import 'package:json_annotation/json_annotation.dart';

part 'papertrail_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class PapertrailSettings {
  String host = '';
  int port = -1;

  PapertrailSettings();

  factory PapertrailSettings.fromJson(Map<String, dynamic> json) =>
      _$PapertrailSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$PapertrailSettingsToJson(this);
}
