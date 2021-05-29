import 'package:cie_photo_clash/src/blocs/data/data_bloc.dart';
import 'package:cie_photo_clash/src/model/post.dart';
import 'package:cie_photo_clash/src/screens/timeline/widget/post_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            List<Post> posts = state.posts;
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) =>
                  PostItemWidget(post: posts[index]),
            );
          }
          return Text('');
        },
      ),
    );
  }
}
