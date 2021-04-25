import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/model.dart';

class Service {
  //List<NewsfeedModel> scores;
  var len;
  Future<List<NewsfeedModel>> getUserInfo(
      String username, String lastkey) async {
    try {
      final String apiurl = "http://13.127.16.112:6000/user_timeline";
      final response = await http.post(apiurl,
          headers: {'Accept': 'application/json'},
          body: {"user_id": username, "exclusive_start_key": lastkey});
      if ((response.body).isNotEmpty && response.statusCode == 200) {
        final resdata = jsonDecode(response.body);

        //Map<String, dynamic> output = jsonDecode(response.body);
        //Map<String, dynamic> streetsList =
        //  new Map<String, dynamic>.from(resdata);
        //len = resdata.length;
        List<NewsfeedModel> scores = List<NewsfeedModel>.from(
            resdata.map((item) => NewsfeedModel.fromJson(item)).toList());

        len = scores.length;

        //res = newsfeedModelFromJson(resdata);
        //_newsModel = new NewsfeedModel.fromJson(resdata);

        return scores;
      }
    } catch (Exception) {
      //scores = null;
      return null;
    }
    return null;
  }
}
