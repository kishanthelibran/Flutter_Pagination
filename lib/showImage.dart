import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:project/imageService.dart';
import 'package:project/model.dart';

class ShowImages extends StatefulWidget {
  final int index;
  final NewsfeedModel _newsfeed;
  ShowImages(this.index, this._newsfeed);
  @override
  _ShowImagesState createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  bool _fetched = false;

  ImageService imageservice = ImageService();

  var response;

  Future postdata;

  @override
  void initState() {
    super.initState();
    refresh();
    //getimagedata(widget._newsfeed.username, widget._newsfeed.postId);
    //media.refresh();
  }

  getimagedata(username, postid) async {
    //refresh();
    response = await imageservice.getpicdata(username, postid);
    if (response != null) {
      if (mounted) {
        setState(() {
          _fetched = true;
        });
      }
    }
    //return response;
  }

  Future<void> refreshLoader({bool clearCachedData = false}) {
    response = getimagedata(widget._newsfeed.username, widget._newsfeed.postId);
    return response;
  }

  Future<void> refresh() {
    response = refreshLoader(clearCachedData: true);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    //getimagedata(widget._newsfeed.username, widget._newsfeed.postId);
    return _fetched
        ? getImage(response, context)
        : Container(
            width: 411,
            height: 400,
          );
  }

  Widget getImage(data, context) {
    String _imgdata = data[0]['media'];
    Uint8List _bytes = base64.decode(_imgdata);
    return SizedBox(
      width: 411,
      height: 400,
      child: Container(
          color: Colors.grey[300],
          //constraints: BoxConstraints(maxHeight: 411, maxWidth: 711),
          child: Image.memory(
            _bytes,
            width: 411,
            fit: BoxFit.cover,
          )),
    );
  }
}
