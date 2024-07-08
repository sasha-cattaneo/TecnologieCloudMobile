import 'package:flutter/material.dart';
import 'talk_repository.dart';
import 'video_repository.dart';
import 'user_repository.dart';
import 'models/talk.dart';
import 'models/video.dart';
import 'models/user.dart';
import 'pages/single_video_page.dart';
import 'pages/single_user_page.dart';
import 'package:my_tedx/styles/dimens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTEDx',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.title = 'MyTEDx'
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controllerTag = TextEditingController();
  final TextEditingController _controllerId = TextEditingController();
  final TextEditingController _controllerTagUser1 = TextEditingController();
  final TextEditingController _controllerTagUser2 = TextEditingController();
  final TextEditingController _controllerTagUser3 = TextEditingController();
  late Future<List<Talk>> _talks;
  late Future<List<Video>> _videos;
  late Future<List<User>> _users;
  int page = 1;
  int init = 0;

  final List<String> scoreLevel = <String>['0', '1', '2'];
  final List<String> scoreLevelText = <String>['Low','Medium','High'];
  String? scoreLevelSelected;

  @override
  void initState() {
    super.initState();
    _talks = initEmptyListTalk();
    _videos = initEmptyListVideo();
    _users = initEmptyListUser();
    init = 0;
  }

  void _getTalksByTag() async {
    setState(() {
      init = 1;
      _talks = getTalksByTag(_controllerTag.text, page);
    });
  }
  void _getWatchNextById() async {
    setState(() {
      init = 2;
      _videos = getWatchNextById(_controllerId.text);
    });
  }
  void _createUserList() async {
    setState(() {
      init = 3;
      _users = createUserList(_controllerTagUser1.text, _controllerTagUser2.text, _controllerTagUser3.text, scoreLevelSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My TedX App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My TEDx App'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context){
            switch(init){
              case 0: {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimens.mainPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: _controllerTag,
                        decoration:
                            const InputDecoration(hintText: 'Enter your favorite tag'),
                      ),
                      ElevatedButton(
                        child: const Text('Search by tag'),
                        onPressed: () {
                          page = 1;
                          _getTalksByTag();
                        },
                      ),
                      TextField(
                        controller: _controllerId,
                        decoration:
                            const InputDecoration(hintText: 'Enter your talk ID'),
                      ),
                      ElevatedButton(
                        child: const Text('Search by ID'),
                        onPressed: () {
                          _getWatchNextById();
                        },
                      ),
                      TextField(
                        controller: _controllerTagUser1,
                        decoration:
                            const InputDecoration(hintText: 'Enter your first tag'),
                      ),
                      TextField(
                        controller: _controllerTagUser2,
                        decoration:
                            const InputDecoration(hintText: 'Enter your second tag'),
                      ),
                      TextField(
                        controller: _controllerTagUser3,
                        decoration:
                            const InputDecoration(hintText: 'Enter your third tag'),
                      ),
                      DropdownButton<String>(
                        value: scoreLevelSelected,
                        hint: const Text("Select a precision level"),
                        items: scoreLevel.map<DropdownMenuItem<String>>((String value){
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(scoreLevelText[int.parse(value)]),
                          );
                        }).toList(),
                        onChanged: (String? newValue){
                          setState(() {
                            scoreLevelSelected = newValue;
                          });
                        }
                        ),
                      ElevatedButton(
                        child: const Text('Create user list'),
                        onPressed: () {
                          _createUserList();
                        },
                      ),
                    ],
                  ),
                );
                 
              }
              case 1:{
                return FutureBuilder<List<Talk>>(
                  future: _talks,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scaffold(
                          appBar: AppBar(
                            title: Text("#${_controllerTag.text}"),
                          ),
                          body: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: ListTile(
                                    subtitle:
                                        Text(snapshot.data![index].mainSpeaker),
                                    title: Text(snapshot.data![index].title)),
                                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(snapshot.data![index].details))),
                              );
                            },
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.centerDocked,
                          floatingActionButton: FloatingActionButton(
                            child: const Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              if (snapshot.data!.length >= 6) {
                                page = page + 1;
                                _getTalksByTag();
                              }
                            },
                          ),
                          bottomNavigationBar: BottomAppBar(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.home),
                                  onPressed: () {
                                    setState(() {
                                      init = 0;
                                      page = 1;
                                      _controllerTag.text = "";
                                    });
                                  },
                                )
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return const CircularProgressIndicator();
                  },
                );
              }
              case 2:{
                return FutureBuilder<List<Video>>(
                  future: _videos,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scaffold(
                          appBar: AppBar(
                            title: Text("#${_controllerId.text}"),
                          ),
                          body: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: ListTile(
                                    subtitle:
                                        Text(snapshot.data![index].speaker),
                                    title: Text(snapshot.data![index].title)),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingleVideoPage(
                                          videoId: snapshot.data![index].id,
                                          videoTitle: snapshot.data![index].title,
                                        ),
                                      ),
                                    ),
                              );
                            },
                          ),
                          bottomNavigationBar: BottomAppBar(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.home),
                                  onPressed: () {
                                    setState(() {
                                      init = 0;
                                      _controllerId.text = "";
                                    });
                                  },
                                )
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return const CircularProgressIndicator();
                  },
                );
              }
              case 3:{
                var t = "#";
                (_controllerTagUser1.text != "") ? t+="[${_controllerTagUser1.text}]" : t=t;
                (_controllerTagUser2.text != "") ? t+="[${_controllerTagUser2.text}]" : t=t;
                (_controllerTagUser3.text != "") ? t+="[${_controllerTagUser3.text}]" : t=t;

                return FutureBuilder<List<User>>(
                  future: _users,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scaffold(
                          appBar: AppBar(
                            title: Text(
                              t,
                            ),
                          ),
                          body: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: ListTile(
                                    title: Text(snapshot.data![index].username.substring(1)),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingleUserPage(
                                          user: snapshot.data![index],
                                        ),
                                      ),
                                    ),
                                ),
                              );
                            },
                          ),
                          bottomNavigationBar: BottomAppBar(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.home),
                                  onPressed: () {
                                    setState(() {
                                      init = 0;
                                      _controllerId.text = "";
                                    });
                                  },
                                )
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return const CircularProgressIndicator();
                  },
                );
              }
            }
          return Container();
          })
        ),
      ),
    );
  }
}