import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cie_photo_clash/src/blocs/auth/auth_bloc.dart';
import 'package:cie_photo_clash/src/model/cie_user.dart';
import 'package:cie_photo_clash/src/model/like.dart';
import 'package:cie_photo_clash/src/model/post.dart';
import 'package:cie_photo_clash/src/repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'data_event.dart';

part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  late DataRepository dataRepository;
  late StreamSubscription<List<Post>> _postsStateChangesSubscription;
  late StreamSubscription<CIEUser> _userDetailsChangesSubscription;
  late StreamSubscription<List<Like>> _likesChangeSubscription;

  DataBloc({required this.dataRepository}) : super(DataInitial()) {
    _postsStateChangesSubscription =
        dataRepository.posts.call(page: 1).listen((posts) {
      add(PostFetchedEvent(posts: posts));
    });
  }

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is UserDataEvent) {
      yield* _mapUserDataEventToState(event.uid);
    }

    if (event is FetchUsersEvent) {
      yield* _mapFetchUsersEventToState();
    }

    if (event is FetchUserDetailsEvent) {
      _userDetailsChangesSubscription =
          dataRepository.userDetails(event.uid).listen((user) {
        add(UserFetchedEvent(user: user));
      });
    }

    if (event is UserFetchedEvent) {
      yield UserDataState(user: event.user);
    }

    if (event is SearchUserEvent) {
      yield* _mapSearchUserEventToState(event.query);
    }

    if (event is AddPostEvent) {
      yield* _mapAddPostEventToState(event.post, event.photo);
    }

    if (event is FetchPostEvent) {
      yield* _mapFetchPostsEventToState(page: event.page);
    }

    if (event is PostFetchedEvent) {
      yield PostsFetchedState(posts: event.posts);
    }

    // if (event is EditPostEvent) {
    //   yield* _mapEditPostEventToState(event.data, event.postId);
    // }

    // if (event is FetchLikesEvent) {
    //   _likesChangeSubscription =
    //       MessagingRepository().likes(event.postId).listen((likes) {
    //     add(LikesFetchedEvent(likes));
    //   });
    // }

    if (event is LikesFetchedEvent) {
      yield LikesLoadedState(likes: event.likes);
    }

    // if (event is AddLikeEvent) {
    //   MessagingRepository().addLike(event.like);
    // }

    // if (event is RemoveLikeEvent) {
    //   MessagingRepository().unLike(event.likeId, event.postId);
    // }

    // if (event is DeleteCommentEvent) {
    //   MessagingRepository().deleteComent(event.commentId, event.postId);
    // }
  }

  @override
  Future<void> close() {
    _postsStateChangesSubscription.cancel();
    _userDetailsChangesSubscription.cancel();
    ;
    _likesChangeSubscription.cancel();
    return super.close();
  }

  Stream<DataState> _mapUserDataEventToState(String uid) async* {
    try {
      yield UserDetailsLoadingState();
      var user = await dataRepository.user(uid);
      yield UserDataState(user: user.data);
    } on FirebaseException catch (e) {
      print(
          '****************************Fetch User Data Error*************************');
    }
  }

  Stream<DataState> _mapFetchUsersEventToState() async* {
    yield UsersLoadingState();
    var res = await dataRepository.users();
    if (res.error) {
    } else {
      yield UsersFetchedState(users: res.data);
    }
  }

  Stream<DataState> _mapSearchUserEventToState(String query) async* {
    yield UsersLoadingState();
    var usersRes = await dataRepository.searchUsers(query, uid: AuthBloc.uid);
    if (usersRes.error) {
    } else {
      yield UsersFetchedState(users: usersRes.data);
    }
  }

  Stream<DataState> _mapAddPostEventToState(Post post, File file) async* {
    try {
      yield PostSavingState();
      var postRes =
          await dataRepository.savePost(post, uid: AuthBloc.uid, photo: file);
      if (postRes.error) {
        yield PostSaveErrorState(postRes.data);
      } else {
        yield PostSavedState(postRes.data);
      }
    } catch (e) {
      print('Error saving POST:$e');
    }
  }

  Stream<DataState> _mapFetchPostsEventToState({required int page}) async* {
    _postsStateChangesSubscription.cancel();
    _postsStateChangesSubscription =
        dataRepository.posts.call(page: page).listen((posts) {
      add(PostFetchedEvent(posts: posts));
    });
  }
}
