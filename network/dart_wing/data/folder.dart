import 'package:json_annotation/json_annotation.dart';

part 'folder.g.dart';

@JsonSerializable(explicitToJson: true)
class Folder {
  String id = '';
  @JsonKey(includeIfNull: false)
  String? parentId = '';
  String name = '';
  String? description = '';
  String displayName = '';
  String folderType = '';
  bool canBeSelected = false;

  Folder();

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);

  Map<String, dynamic> toJson() => _$FolderToJson(this);
}
