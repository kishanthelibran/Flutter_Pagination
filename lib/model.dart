// To parse this JSON data, do
//
//     final newsfeedModel = newsfeedModelFromJson(jsonString);

import 'dart:async';
import 'dart:convert';

import 'package:project/service.dart';

// To parse this JSON data, do
//
//     final newsfeedModel = newsfeedModelFromJson(jsonString);

List<NewsfeedModel> newsfeedModelFromJson(String str) =>
    List<NewsfeedModel>.from(
        json.decode(str).map((x) => NewsfeedModel.fromJson(x)));

String newsfeedModelToJson(List<NewsfeedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsfeedModel {
  NewsfeedModel({
    this.caption,
    this.postId,
    this.postpath,
    this.timestamp,
    this.posttag,
    this.posttype,
    this.posthashtag,
    this.username,
    this.postLocation,
    this.lastEvaluatedKey,
    this.likeComment,
    this.like,
    this.postMedia,
    this.liked,
  });

  String caption;
  String postId;
  String postpath;
  DateTime timestamp;
  String posttag;
  String posttype;
  String posthashtag;
  String username;
  String postLocation;
  LastEvaluatedKey lastEvaluatedKey;
  List<LikeComment> likeComment;
  String like;
  List<String> postMedia;
  String liked;

  factory NewsfeedModel.fromJson(Map<String, dynamic> json) => NewsfeedModel(
        caption: json["caption"],
        postId: json["post_id"],
        postpath: json["postpath"],
        timestamp: DateTime.parse(json["timestamp"]),
        posttag: json["posttag"],
        posttype: json["posttype"],
        posthashtag: json["posthashtag"],
        username: json["username"],
        postLocation: json["post_location"],
        lastEvaluatedKey: json["LastEvaluatedKey"] == null
            ? null
            : LastEvaluatedKey.fromJson(json["LastEvaluatedKey"]),
        likeComment: List<LikeComment>.from(
            json["like_comment"].map((x) => LikeComment.fromJson(x))),
        like: json["like"] == null ? null : json["like"],
        postMedia: json["post_media"] == null
            ? null
            : List<String>.from(json["post_media"].map((x) => x)),
        liked: json["liked"] == null ? null : json["liked"],
      );

  Map<String, dynamic> toJson() => {
        "caption": caption,
        "post_id": postId,
        "postpath": postpath,
        "timestamp": timestamp.toIso8601String(),
        "posttag": posttag,
        "posttype": posttype,
        "posthashtag": posthashtag,
        "username": username,
        "post_location": postLocation,
        "LastEvaluatedKey":
            lastEvaluatedKey == null ? null : lastEvaluatedKey.toJson(),
        "like_comment": likeComment == null
            ? null
            : List<LikeComment>.from(likeComment.map((x) => x)),
        "like": like == null ? null : like,
        "post_media": postMedia == null
            ? null
            : List<dynamic>.from(postMedia.map((x) => x)),
        "liked": liked == null ? null : liked,
      };
}

class LastEvaluatedKey {
  LastEvaluatedKey({
    this.username,
    this.timestamp,
  });

  String username;
  DateTime timestamp;

  factory LastEvaluatedKey.fromJson(Map<String, dynamic> json) =>
      LastEvaluatedKey(
        username: json["username"],
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "timestamp": timestamp.toIso8601String(),
      };
}

class LikeComment {
  LikeComment({
    this.like,
    this.commentId,
  });

  String like;
  String commentId;

  factory LikeComment.fromJson(Map<String, dynamic> json) => LikeComment(
        like: json["like"],
        commentId: json["comment_id"],
      );

  Map<String, dynamic> toJson() => {
        "like": like,
        "comment_id": commentId,
      };
}

class PostsModel {
  Stream<List<NewsfeedModel>> stream;
  Service _userinfo = Service();

  bool hasMore;

  bool _isLoading;
  List<NewsfeedModel> _data;
  StreamController<List<NewsfeedModel>> _controller;
  String userid;
  String lastkey;

  PostsModel(this.userid, this.lastkey) {
    _data = <NewsfeedModel>[];
    _controller = StreamController<List<NewsfeedModel>>.broadcast();
    _isLoading = false;
    stream = _controller.stream.map((List<NewsfeedModel> postsData) {
      return postsData;
    });
    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    //refreshfeed.loadMore(clearCachedData: true);
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) {
    if (clearCachedData) {
      _data = <NewsfeedModel>[];
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return _userinfo.getUserInfo(userid, lastkey).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      if (postsData[0].lastEvaluatedKey.username == "") {
        lastkey = postsData[0].lastEvaluatedKey.username;
      } else {
        lastkey = json.encode(postsData[0].lastEvaluatedKey);
      }
      hasMore = (lastkey != "");

      _controller.add(_data);
    });
  }
}
