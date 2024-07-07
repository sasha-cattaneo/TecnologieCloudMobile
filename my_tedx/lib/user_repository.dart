import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/user.dart';


Future<List<User>> initEmptyListUser() async {

  Iterable list = json.decode("[]");
  var talks = list.map((model) => User.fromJSON(model)).toList();
  return talks;

}

Future<User> getSingleUser (String videoId) async {
  var url = Uri.parse("https://htmetgixmi.execute-api.us-east-1.amazonaws.com/default/get_talk");
  var u;
  final http.Response response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'id': videoId
    }),
  );
  if (response.statusCode == 200) {
    u = User.fromJSON(json.decode(response.body)[0]); 
    return u;
  } else {
    throw Exception('Failed to load watch next');
  }
}

Future<List<User>> createUserList(String tag1, String tag2, String tag3, String? scoreLevel) async {
  var url = Uri.parse('https://3peeyt1nx0.execute-api.us-east-1.amazonaws.com/default/create_userList_by_tags');
  List<Map<String,String>> tags = [
    {"tag": tag1},
    {"tag": tag2},
    {"tag": tag3}
  ]; 

  final http.Response response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'tags': tags,
      'scoreLevel': (scoreLevel == null)? scoreLevel : 0,
    }),
  );
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    var users = list.map((model) => User.fromJSON(model)).toList();
    return users;
  } else {
    throw Exception('Failed to load watch next');
  }
      
}
