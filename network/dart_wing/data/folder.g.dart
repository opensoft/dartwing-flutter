// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Folder _$FolderFromJson(Map<String, dynamic> json) => Folder()
  ..id = json['id'] as String
  ..parentId = json['parentId'] as String?
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..displayName = json['displayName'] as String
  ..folderType = json['folderType'] as String
  ..canBeSelected = json['canBeSelected'] as bool;

Map<String, dynamic> _$FolderToJson(Folder instance) => <String, dynamic>{
  'id': instance.id,
  'parentId': ?instance.parentId,
  'name': instance.name,
  'description': instance.description,
  'displayName': instance.displayName,
  'folderType': instance.folderType,
  'canBeSelected': instance.canBeSelected,
};
