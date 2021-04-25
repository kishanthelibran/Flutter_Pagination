import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:async/async.dart';

class ImageService {
  int len;
  var resdata;
  Future<List> getpicdata(String username, String postid) async {
    final String apiurl = "http://13.127.16.112:4000/getFollowing";
    final response = await http.post(apiurl,
        headers: {'Accept': 'application/json'},
        body: {"user_id": username, "post_id": postid});
    if ((response.body).isNotEmpty && response.statusCode == 200) {
      resdata = json.decode(response.body);
      len = resdata.length;
      return resdata;
    } else {
      resdata = 0;
      return resdata;
    }
  }
}
