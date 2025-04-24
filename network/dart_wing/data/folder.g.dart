// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Folder _$FolderFromJson(Map<String, dynamic> json) => Folder()
  ..id = json['id'] as String
  ..parentId = json['parentId'] as String?
  ..name = json['name'] as String
  ..description = json['description'] as String
  ..canBeSelected = json['canBeSelected'] as bool;

Map<String, dynamic> _$FolderToJson(Folder instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('parentId', instance.parentId);
  val['name'] = instance.name;
  val['description'] = instance.description;
  val['canBeSelected'] = instance.canBeSelected;
  return val;
}
