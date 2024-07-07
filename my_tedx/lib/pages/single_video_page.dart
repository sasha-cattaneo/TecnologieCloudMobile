import 'package:flutter/material.dart';
import '/models/video.dart';
import '/video_repository.dart';
import 'package:my_tedx/styles/dimens.dart';

class SingleVideoPage extends StatelessWidget {
  SingleVideoPage({super.key, required this.videoId,required this.videoTitle});

  final String videoId;
  final String videoTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("$videoTitle"),
      ),
      body: FutureBuilder<Video>(
        future: getSingleVideo(videoId),
        builder: (_, AsyncSnapshot<Video> snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Video myVideo = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(Dimens.mainPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        myVideo.urlImage,
                      ),
                    ),
                    Text(
                      "Speaker: ${myVideo.speaker}",
                      // style: TextTheme.bodyLarge,
                    ),
                    Text(
                      "Duration: ${myVideo.duration}",
                      // style: TextTheme.bodyLarge,
                    ),
                    Text(
                      "Published at: ${myVideo.publishedAt}",
                      // style: TextTheme.bodyLarge,
                    ),
                    Text(
                      myVideo.description,
                      // style: TextTheme.bodyLarge,
                    )
                    
                    
                  ],
                  
                  )
              );
          } else if (snapshot.hasError) {
            return Text("main.dart[212] ${snapshot.error}");
          }
          return const CircularProgressIndicator();
        } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
        }
      )
    );
  }
}