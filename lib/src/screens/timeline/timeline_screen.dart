import 'package:cie_photo_clash/src/blocs/data/data_bloc.dart';
import 'package:cie_photo_clash/src/model/post.dart';
import 'package:cie_photo_clash/src/screens/timeline/widget/post_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  void initState() {
    context.read<DataBloc>().add(FetchPostEvent(page: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: BlocBuilder<DataBloc, DataState>(
        buildWhen: (previous, current) =>
            current is PostsFetchedState || current is PostsLoadingState,
        builder: (context, state) {
          if (state is PostsFetchedState) {
            var now = DateTime.now();
            var date = DateTime(now.year, now.month, now.day);
            var today = date.millisecondsSinceEpoch;
            List<Post> posts =
                state.posts.where((post) => post.timestamp == today).toList();

            if (posts.isNotEmpty) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) =>
                    PostItemWidget(post: posts[index]),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/empty.svg',
                      width: 100,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'No uploads yet for today, check back later!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              );
            }
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
