import 'package:json_annotation/json_annotation.dart';

import 'folder.dart';

part 'folder_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FolderResponse {
  @JsonKey(includeIfNull: false)
  List<Folder>? folders;
  @JsonKey(includeIfNull: false)
  String? redirectUrl;

  FolderResponse();

  factory FolderResponse.fromJson(Map<String, dynamic> json) =>
      _$FolderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FolderResponseToJson(this);
}
