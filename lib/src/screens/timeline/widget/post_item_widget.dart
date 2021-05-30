import 'package:cached_network_image/cached_network_image.dart';
import 'package:cie_photo_clash/src/blocs/auth/auth_bloc.dart';
import 'package:cie_photo_clash/src/model/cie_user.dart';
import 'package:cie_photo_clash/src/model/like.dart';
import 'package:cie_photo_clash/src/model/post.dart';
import 'package:cie_photo_clash/src/repository/data_repository.dart';
import 'package:flutter/material.dart';

class PostItemWidget extends StatelessWidget {
  final Post post;

  const PostItemWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                    image: CachedNetworkImageProvider(post.imagePath)),
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
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                width: size.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                child: StreamBuilder<CIEUser>(
                    stream: DataRepository().userDetails(post.userId),
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
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                width: size.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0)),
                    color: Colors.black.withOpacity(0.1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<List<Like>>(
                        stream: DataRepository().likes(post.id),
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
                                  onTap: () {
                                    try {
                                      if (likes
                                              .where((like) =>
                                                  like.userId == AuthBloc.uid)
                                              .length >
                                          0) {
                                        Like like = likes
                                            .where((like) =>
                                                like.userId == AuthBloc.uid)
                                            .last;
                                        DataRepository()
                                            .unLike(like.id, post.id);
                                      } else {
                                        DataRepository().addLike(Like(
                                            id: '',
                                            postId: post.id,
                                            userId: AuthBloc.uid,
                                            time: DateTime.now()
                                                .millisecondsSinceEpoch));
                                      }
                                    } catch (e) {}
                                  },
                                  child: Image.asset(
                                    'assets/images/approve.png',
                                    width: 32.0,
                                    color: likes
                                                .where((like) =>
                                                    like.userId == AuthBloc.uid)
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
                                '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              InkWell(
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.redAccent,
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
  }
}
