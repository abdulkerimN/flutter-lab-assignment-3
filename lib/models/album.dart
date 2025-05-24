import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'album.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Album extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final int userId;
  
  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final String? thumbnailUrl;
  
  @HiveField(4)
  final String? url;

  const Album({
    required this.id,
    required this.userId,
    required this.title,
    this.thumbnailUrl,
    this.url,
  });

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumToJson(this);

  @override
  List<Object?> get props => [id, userId, title, thumbnailUrl, url];
} 