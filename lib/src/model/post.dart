import 'dart:convert';

import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String userId;
  final String imagePath;
  final String title;
  final String voteId;
  final int timestamp;
  Post({
    required this.id,
    required this.userId,
    required this.imagePath,
    required this.title,
    required this.voteId,
    required this.timestamp,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? imagePath,
    String? title,
    String? voteId,
    int? timestamp,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      voteId: voteId ?? this.voteId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'imagePath': imagePath,
      'title': title,
      'voteId': voteId,
      'timestamp': timestamp,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['userId'],
      imagePath: map['imagePath'],
      title: map['title'],
      voteId: map['voteId'],
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      userId,
      imagePath,
      title,
      voteId,
      timestamp,
    ];
  }
}
