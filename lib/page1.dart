import 'package:flutter/material.dart';
import 'package:project/handle_future_exception.dart';
import 'package:project/header.dart';
import 'package:project/model.dart';
import 'package:project/showImage.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();

  AsyncSnapshot<dynamic> snapshot;

  String _userid = "iron_man";

  String lastkey = "";

  PostsModel posts;

  bool hasrefreshed;

  //_data = List<NewsfeedModel>();

  @override
  void initState() {
    posts = PostsModel(_userid, lastkey);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        posts.loadMore();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
          //controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            //String _imgid = index.toString();

            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: .5,
                forceElevated: false,
                backgroundColor: Colors.white,
                expandedHeight: 70.0,
                floating: false,
                //snap: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  //centerTitle: true,
                  title: Align(
                    alignment: Alignment(-1.5, 0.9),
                    child: Text(
                      "ScrollView",
                      style: new TextStyle(
                          //fontFamily: "DancingScript-Bold",
                          letterSpacing: -.8,
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: StreamBuilder<List<NewsfeedModel>>(
              stream: posts.stream,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  if ((snapshot.data).length == 0) {
                    return Container(
                        alignment: Alignment(0, 0),
                        child: Text('Follow Someone to View Their Posts',
                            style: TextStyle(fontSize: 20)));
                  }
                  return new RefreshIndicator(
                      onRefresh: posts.refresh,
                      child: getListView(snapshot, context));
                  //return getListView(snapshot, context);
                }

                return StatusWidget(
                  snapshot: snapshot,
                  actionText: "Retry",
                  statusText: "unable to connect",
                  action: posts.refresh,
                );
              })),
    );
  }

  Widget getListView(snapshot, context) {
    //_data.addAll(snapshot.data);
    //setState(() {});
    var listview = ListView.separated(
        cacheExtent: 9999999,
        physics: const AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
        controller: scrollController,
        separatorBuilder: (context, index) => _drawPartition(),
        itemCount: snapshot.data.length + 1,
        itemBuilder: (context, index) {
          if ((index < snapshot.data.length &&
              snapshot.data[index].postpath != "thor/34354")) {
            NewsfeedModel _newsfeed = snapshot.data[index];

            return Container(
                child: Column(
              children: <Widget>[
                Feedheader(index, snapshot),
                ShowImages(index, _newsfeed),
                showCaption(index, _newsfeed),
                SizedBox(height: 50),
                SizedBox(height: 30),
              ],
            ));
          } else if (posts.hasMore) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 1.7),
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
                backgroundColor: Colors.white,
              )),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 1),
              child: Center(child: Text('nothing more to load!')),
            );
          }
        });
    return listview;
  }

  Widget showCaption(index, _newsfeed) {
    String _location = _newsfeed.postLocation;
    String _caption = _newsfeed.caption;
    return Column(
      children: <Widget>[
        _location != ""
            ? Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 16),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.grey[700],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15, left: 4),
                    //color: Colors.black12,
                    child: Text(_location,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 19)),
                  ),
                ],
              )
            : Container(),
        _location == "" && _caption != "" || _location != "" && _caption != ""
            ? SizedBox(height: 1.5)
            : Container(),
        _caption != ""
            ? Container(
                alignment: Alignment(-0.9, 0),
                padding: EdgeInsets.only(top: 8, right: 10),
                child: Text(_caption,
                    maxLines: 5,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)))
            : Container(),
        //SizedBox(height: SizeConfig.heightMultiplier * 1.5)
      ],
    );
  }

  Widget _drawPartition() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.8),
      child: Container(
        height: 10.5,
        width: 411,
        color: Colors.blueGrey[100],
      ),
    );
  }
}
