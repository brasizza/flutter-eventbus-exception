// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AlbumModelError {
  int albumId;
  int id;
  String url;
  String thumbnailUrl;
  AlbumModelError({
    required this.albumId,
    required this.id,
    required this.url,
    required this.thumbnailUrl,
  });

  AlbumModelError copyWith({
    int? albumId,
    int? id,
    String? url,
    String? thumbnailUrl,
  }) {
    return AlbumModelError(
      albumId: albumId ?? this.albumId,
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'albumId': albumId,
      'id': id,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory AlbumModelError.fromMap(Map<String, dynamic> map) {
    return AlbumModelError(
      albumId: map['albumid'] as int,
      id: map['id'] as int,
      url: map['url'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlbumModelError.fromJson(String source) => AlbumModelError.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AlbumModelError(albumId: $albumId, id: $id, url: $url, thumbnailUrl: $thumbnailUrl)';
  }

  @override
  bool operator ==(covariant AlbumModelError other) {
    if (identical(this, other)) return true;

    return other.albumId == albumId && other.id == id && other.url == url && other.thumbnailUrl == thumbnailUrl;
  }

  @override
  int get hashCode {
    return albumId.hashCode ^ id.hashCode ^ url.hashCode ^ thumbnailUrl.hashCode;
  }
}
