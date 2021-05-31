import 'package:cie_photo_clash/src/screens/leaderbaord/widgets/rank_widget.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(16.0),
        // decoration: BoxDecoration(color: Color(0xFF071d13)),
        child: Column(
          children: [
            Center(
              child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.black.withOpacity(0.2)),
                  child: Text(
                    'Today',
                    style: TextStyle(color: Colors.black),
                  )),
            ),
            SizedBox(
              height: 32,
            ),
            RankWidget(),
          ],
        ),
      ),
    );
  }
}
