import 'package:cached_network_image/cached_network_image.dart';
import 'package:cie_photo_clash/src/model/cie_user.dart';
import 'package:cie_photo_clash/src/model/like.dart';
import 'package:cie_photo_clash/src/repository/data_repository.dart';
import 'package:flutter/material.dart';

class RankWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Like>>(
        stream: DataRepository().allLikes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var now = DateTime.now();
            var date = DateTime(now.year, now.month, now.day);
            var today = date.millisecondsSinceEpoch;

            List<Like> allLikes = snapshot.data!
                .where((element) => element.time == today)
                .toList();
            List<String> postIds =
                allLikes.map((e) => e.postId).toSet().toList();
            List<List<Like>> groups = [];
            postIds.forEach((element) {
              var list = allLikes.where((e) => e.postId == element).toList();
              groups.add(list);
            });

            groups.sort((a, b) => b.length.compareTo(a.length));

            if (groups.length == 3) {
              return _buildThreeRankWidget(context, groups);
            } else if (groups.length > 3) {
              return _buildMultipleRankWidget(context, groups);
            } else if (groups.length == 2) {
              return _buildTwoRankWidget(context, groups);
            } else {
              return _buildOneRanklWidget(context, groups);
            }

            // print(groups.join(", "));
          }

          return SizedBox.shrink();
        });
  }

  Widget _buildThreeRankWidget(BuildContext context, List<List<Like>> groups) {
    print('${groups.map((e) => e.length)}');

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder<CIEUser>(
              stream: DataRepository().userDetails(groups[1][0].posterId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var cieUser = snapshot.data;
                  return Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          '2',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Text(
                          '▼',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 4,
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      cieUser!.photo))),
                        ),
                        Text(
                          '${cieUser.name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Text(
                          '${groups[1].length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  );
                } else {
                  // TODO: Return shimmerTemplate
                  return SizedBox.shrink();
                }
              }),
          Expanded(
            flex: 3,
            child: StreamBuilder<CIEUser>(
                stream: DataRepository().userDetails(groups[0][0].posterId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var cieUser = snapshot.data;
                    return Column(
                      children: [
                        Text(
                          '1',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Image.asset(
                          'assets/images/crown.png',
                          width: 50,
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 4,
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      cieUser!.photo))),
                        ),
                        Text(
                          '${cieUser.name}',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Text(
                          '${groups[0].length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    );
                  }
                  // TODO: Retuen Empty Template here
                  return SizedBox.shrink();
                }),
          ),
          StreamBuilder<CIEUser>(
              stream: DataRepository().userDetails(groups[2][0].posterId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var cieUser = snapshot.data;
                  return Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          '3',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Text(
                          '▼',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  width: 4,
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      cieUser!.photo))),
                        ),
                        Text(
                          '${cieUser.name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        Text(
                          '${groups[2].length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  );
                }
                // TODO: Return Empty template here
                return SizedBox.shrink();
              })
        ],
      ),
    );
  }

  Widget _buildMultipleRankWidget(
      BuildContext context, List<List<Like>> groups) {
    return Text('Multiple');
  }

  Widget _buildTwoRankWidget(BuildContext context, List<List<Like>> groups) {
    return Text('Tow');
  }

  Widget _buildOneRanklWidget(BuildContext context, List<List<Like>> groups) {
    return Text('One');
  }
}
