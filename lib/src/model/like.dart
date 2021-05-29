
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Like extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final int time;
  Like({
    required this.id,
    required this.postId,
    required this.userId,
    required this.time,
  });
  

  Like copyWith({
    String? id,
    String? postId,
    String? userId,
    int? time,
  }) {
    return Like(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'time': time,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'],
      postId: map['postId'],
      userId: map['userId'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Like.fromJson(String source) => Like.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, postId, userId, time];
}
