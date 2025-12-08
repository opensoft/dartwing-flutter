import 'package:json_annotation/json_annotation.dart';

part 'provider.g.dart';

@JsonSerializable(explicitToJson: true)
class Provider {
  @JsonKey(includeIfNull: false)
  String name = '';
  @JsonKey(includeIfNull: false)
  String? alias;

  Provider();

  factory Provider.fromJson(Map<String, dynamic> json) =>
      _$ProviderFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderToJson(this);
}
