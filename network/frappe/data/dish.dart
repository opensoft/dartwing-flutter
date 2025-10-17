import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'dish.g.dart';

@JsonSerializable(explicitToJson: true)
class Dish {
  @JsonKey(includeIfNull: false)
  String? name;
  @JsonKey(includeIfNull: false, name: 'patient_id')
  String? patientId;
  String? location;
  @JsonKey(includeIfNull: false, name: 'number_of_wells', defaultValue: 24)
  int numberOfWells = 24;
  @JsonKey(includeIfNull: false, includeFromJson: false)
  Map<String, String> wells = {};

  Dish();

  factory Dish.fromJson(Map<String, dynamic> json) {
    Dish dish = _$DishFromJson(json);
    final raw = json['wells'];
    if (raw != null) {
      if (raw is String) {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          dish.wells = decoded.map(
            (k, v) => MapEntry(k.toString(), v.toString()),
          );
        }
      } else if (raw is Map) {
        dish.wells = raw.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    }
    return dish;
  }
  Map<String, dynamic> toJson() {
    var json = _$DishToJson(this);
    json["wells"] = wells;
    return json;
  }
}
