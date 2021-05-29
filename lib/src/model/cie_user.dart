import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class CIEUser extends Equatable {
  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  /// The user photo
  final String photo;
  CIEUser({
    required this.email,
    required this.id,
    required this.name,
    required this.photo,
  });

  /// Empty user which represents an unauthenticated user.
  static var empty = CIEUser(email: '', id: '', name: '', photo: '');

  

  CIEUser copyWith({
    String? email,
    String? id,
    String? name,
    String? photo,
  }) {
    return CIEUser(
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'id': id,
      'name': name,
      'photo': photo,
    };
  }

  factory CIEUser.fromMap(Map<String, dynamic> map) {
    return CIEUser(
      email: map['email'],
      id: map['id'],
      name: map['name'],
      photo: map['photo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CIEUser.fromJson(String source) => CIEUser.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [email, id, name, photo];
}
