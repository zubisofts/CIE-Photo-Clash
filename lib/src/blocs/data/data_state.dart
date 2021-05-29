part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataInitial extends DataState {}

class DataErrorState extends DataState {}

class DataLoadingState extends DataState {}

class UsersLoadingState extends DataState {}

class UserDetailsLoadingState extends DataState {}

class PostsLoadingState extends DataState {}

class UserDataState extends DataState {
  final CIEUser user;
  UserDataState({required this.user});

  @override
  List<Object> get props => [user];
}

class UsersFetchedState extends DataState {
  final List<CIEUser> users;
  UsersFetchedState({required this.users});

  @override
  List<Object> get props => [users];
}

class PostSavingState extends DataState {}

class PostEditingState extends DataState {}

class PostSavedState extends DataState {
  final String postId;

  PostSavedState(this.postId);

  @override
  List<Object> get props => [postId];
}

class PostSaveErrorState extends DataState {
  final String error;

  PostSaveErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class PostsFetchedState extends DataState {
  final List<Post> posts;

  PostsFetchedState({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostEditedState extends DataState {}

class PostEditErrorState extends DataState {}

class FetchUserGamesLoading extends DataState {}

class LikesLoadedState extends DataState {
  final List<Like> likes;
  LikesLoadedState({required this.likes});
  @override
  List<Object> get props => [likes];
}
