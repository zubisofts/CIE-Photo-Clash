import 'dart:convert';

import 'package:equatable/equatable.dart';

class Like extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String posterId;
  final int time;
  Like({
    required this.id,
    required this.postId,
    required this.userId,
    required this.posterId,
    required this.time,
  });

  Like copyWith({
    String? id,
    String? postId,
    String? userId,
    String? posterId,
    int? time,
  }) {
    return Like(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      posterId: posterId ?? this.posterId,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'posterId': posterId,
      'time': time,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'],
      postId: map['postId'],
      userId: map['userId'],
      posterId: map['posterId'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Like.fromJson(String source) => Like.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      postId,
      userId,
      posterId,
      time,
    ];
  }
}
