import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cie_photo_clash/src/blocs/auth/auth_bloc.dart';
import 'package:cie_photo_clash/src/model/like.dart';
import 'package:cie_photo_clash/src/model/post.dart';
import 'package:cie_photo_clash/src/repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PostPreviewScreen extends StatelessWidget {
  final Post post;
  final Color color;
  const PostPreviewScreen({Key? key, required this.post, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Hero(
      tag: post.id,
      child: Scaffold(
        backgroundColor: color,
        body: Container(
            child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              InteractiveViewer(
                child: Center(
                  child: CachedNetworkImage(imageUrl: post.imagePath),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 45.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.1)),
                        child: IconButton(
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.1)),
                      child: IconButton(
                          padding: EdgeInsets.all(8.0),
                          onPressed: () {
                            showMaterialModalBottomSheet(
                                context: context,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                )),
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.all(16.0),
                                            height: 4.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                color: Colors.grey),
                                          ),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.favorite_border,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          title: Text(
                                            'Add to favourites',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.save_alt_outlined,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          title: Text(
                                            'Save Image',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.share,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          title: Text(
                                            'Share Image',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.more_horiz_outlined,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
              Positioned(
                  width: MediaQuery.of(context).size.width,
                  bottom: 0.0,
                  child: Builder(builder: (context) {
                    return Container(
                      child: Center(
                        child: StreamBuilder<List<Like>>(
                            stream: DataRepository().likes(post.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Like> likes = snapshot.data!;
                                return Container(
                                  padding: EdgeInsets.all(16.0),
                                  margin: EdgeInsets.all(32.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.black.withOpacity(0.3)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${snapshot.data!.length}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          try {
                                            if (likes
                                                    .where((like) =>
                                                        like.userId ==
                                                        AuthBloc.uid)
                                                    .length >
                                                0) {
                                              Like like = likes
                                                  .where((like) =>
                                                      like.userId ==
                                                      AuthBloc.uid)
                                                  .last;
                                              await DataRepository()
                                                  .unLike(like.id, post.id);
                                            } else {
                                              await DataRepository().addLike(Like(
                                                  id: '',
                                                  postId: post.id,
                                                  userId: AuthBloc.uid,
                                                  posterId: post.userId,
                                                  time: DateTime.now()
                                                      .millisecondsSinceEpoch));
                                              AssetsAudioPlayer.newPlayer()
                                                  .open(
                                                Audio("assets/files/kiss.wav"),
                                                autoStart: true,
                                                showNotification: false,
                                              );
                                            }
                                          } catch (e) {}
                                        },
                                        child: Image.asset(
                                          'assets/images/approve.png',
                                          width: 32.0,
                                          color: likes
                                                      .where((like) =>
                                                          like.userId ==
                                                          AuthBloc.uid)
                                                      .length >
                                                  0
                                              ? Colors.yellow
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await DataRepository().addLike(Like(
                                          id: '',
                                          postId: post.id,
                                          userId: AuthBloc.uid,
                                          posterId: post.userId,
                                          time: DateTime.now()
                                              .millisecondsSinceEpoch));
                                      AssetsAudioPlayer.newPlayer().open(
                                        Audio("assets/files/kiss.wav"),
                                        autoStart: true,
                                        showNotification: false,
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/images/approve.png',
                                      width: 32.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    );
                  }))
            ],
          ),
        )),
      ),
    );
  }
}
