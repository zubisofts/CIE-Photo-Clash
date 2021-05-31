import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cie_photo_clash/src/blocs/auth/auth_bloc.dart';
import 'package:cie_photo_clash/src/model/cie_user.dart';
import 'package:cie_photo_clash/src/model/like.dart';
import 'package:cie_photo_clash/src/model/post.dart';
import 'package:cie_photo_clash/src/repository/data_repository.dart';
import 'package:cie_photo_clash/src/screens/timeline/post_prewier_screen.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class PostItemWidget extends StatefulWidget {
  final Post post;

  PostItemWidget({Key? key, required this.post}) : super(key: key);

  @override
  _PostItemWidgetState createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends State<PostItemWidget> {
  Color bgColor = Colors.black;

  void initPalette() async {
    final PaletteGenerator paletteGen =
        await PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(widget.post.imagePath));
    bgColor = paletteGen.dominantColor!.color;
  }

  @override
  void initState() {
    initPalette();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostPreviewScreen(
          post: widget.post,
          color: bgColor,
        ),
      )),
      child: Hero(
        tag: widget.post.id,
        child: Builder(builder: (context) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Container(
              width: size.width,
              child: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            widget.post.imagePath,
                          )),
                    ),
                    foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        color: Colors.black.withOpacity(0.4)),
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: StreamBuilder<CIEUser>(
                          stream:
                              DataRepository().userDetails(widget.post.userId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                child: Row(
                                  children: [
                                    Container(
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data!.photo,
                                          width: 40,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      snapshot.data!.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          }),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0)),
                      foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0)),
                          color: Colors.black.withOpacity(0.1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.post.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          StreamBuilder<List<Like>>(
                              stream: DataRepository().likes(widget.post.id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Like> likes = snapshot.data!;
                                  return Row(
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
                                              await DataRepository().unLike(
                                                  like.id, widget.post.id);
                                            } else {
                                              await DataRepository().addLike(Like(
                                                  id: '',
                                                  postId: widget.post.id,
                                                  userId: AuthBloc.uid,
                                                  posterId: widget.post.userId,
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
                                  );
                                }
                                return Row(
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
                                            postId: widget.post.id,
                                            userId: AuthBloc.uid,
                                            posterId: widget.post.userId,
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
                              })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
