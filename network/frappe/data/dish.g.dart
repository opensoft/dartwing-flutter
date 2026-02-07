// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dish _$DishFromJson(Map<String, dynamic> json) => Dish()
  ..name = json['name'] as String?
  ..patientId = json['patient_id'] as String?
  ..location = json['location'] as String?
  ..numberOfWells = (json['number_of_wells'] as num?)?.toInt() ?? 16;

Map<String, dynamic> _$DishToJson(Dish instance) => <String, dynamic>{
  'name': ?instance.name,
  'patient_id': ?instance.patientId,
  'location': instance.location,
  'number_of_wells': instance.numberOfWells,
};
