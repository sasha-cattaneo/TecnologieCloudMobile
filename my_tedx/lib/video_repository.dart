import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/video.dart';


Future<List<Video>> initEmptyListVideo() async {

  Iterable list = json.decode("[]");
  var talks = list.map((model) => Video.fromJSON(model)).toList();
  return talks;

}

Future<Video> getSingleVideo (String videoId) async {
  var url = Uri.parse("https://htmetgixmi.execute-api.us-east-1.amazonaws.com/default/get_talk");
  var v;
  final http.Response response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'id': videoId
    }),
  );
  if (response.statusCode == 200) {
    v = Video.fromJSON(json.decode(response.body)[0]); 
    return v;
  } else {
    throw Exception('Failed to load watch next');
  }
}

Future<List<Video>> getWatchNextById(String id) async {
  var url = Uri.parse('https://l5k80yitd9.execute-api.us-east-1.amazonaws.com/default/Get_Watch_Next_by_Id');

  final http.Response response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'id': id
    }),
  );
  if (response.statusCode == 200) {
    var l = json.decode(response.body);
    Iterable list;
    if(l.length != 0)
      list = l[0]["related_videos"];
    else
      list = l;
    var videos = list.map((model) => Video.fromJSON(model)).toList();
    return videos;
  } else {
    throw Exception('Failed to load watch next');
  }
      
}
