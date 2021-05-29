part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class UserDataEvent extends DataEvent {
  final String uid;

  UserDataEvent({required this.uid});

  @override
  List<Object> get props => [uid];
}

class FetchUsersEvent extends DataEvent {
  @override
  List<Object> get props => [];
}

class FetchUserDetailsEvent extends DataEvent {
  final String uid;

  FetchUserDetailsEvent({required this.uid});

  @override
  List<Object> get props => [uid];
}

class UserFetchedEvent extends DataEvent {
  final CIEUser user;

  UserFetchedEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class SearchUserEvent extends DataEvent {
  final String query;

  SearchUserEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class AddPostEvent extends DataEvent {
  final Post post;
  final File photo;

  AddPostEvent(this.post, this.photo);

  @override
  List<Object> get props => [post, photo];
}

class EditPostEvent extends DataEvent {
  final Map<String, dynamic> data;
  final String postId;

  EditPostEvent(this.data, this.postId);

  @override
  List<Object> get props => [data];
}

class FetchPostEvent extends DataEvent {
  final int page;

  FetchPostEvent({required this.page});
  @override
  List<Object> get props => [];
}

class PostFetchedEvent extends DataEvent {
  final List<Post> posts;

  PostFetchedEvent({required this.posts});

  @override
  List<Object> get props => [posts];
}

class AddLikeEvent extends DataEvent {
  final Like like;

  AddLikeEvent(
    this.like,
  );

  @override
  List<Object> get props => [like];
}

class RemoveLikeEvent extends DataEvent {
  final String likeId;
  final String postId;

  RemoveLikeEvent({required this.likeId, required this.postId});

  @override
  List<Object> get props => [likeId, postId];
}
class FetchLikesEvent extends DataEvent {
  final String postId;
  FetchLikesEvent(this.postId);
  @override
  List<Object> get props => [postId];
}

class LikesFetchedEvent extends DataEvent {
  final List<Like> likes;
  LikesFetchedEvent(this.likes);
  @override
  List<Object> get props => [likes];
}
