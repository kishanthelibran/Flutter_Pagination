import 'package:flutter/material.dart';
import 'package:project/model.dart';

class Feedheader extends StatefulWidget {
  final int index;
  //final int _postlen;
  final AsyncSnapshot snapshot;
  Feedheader(this.index, this.snapshot);
  @override
  _FeedheaderState createState() => _FeedheaderState();
}

class _FeedheaderState extends State<Feedheader> {
  @override
  Widget build(BuildContext context) {
    NewsfeedModel _newsfeed = widget.snapshot.data[widget.index];
    String userid = _newsfeed.username;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(userid,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                //fontFamily: 'Roboto',
              )),
        ],
      ),
    );
  }
}
