import 'package:flutter/material.dart';
import '/models/video.dart';
import '/video_repository.dart';
import 'package:my_tedx/styles/dimens.dart';

class SingleVideoPage extends StatelessWidget {
  const SingleVideoPage({super.key, required this.videoId,required this.videoTitle});

  final String videoId;
  final String videoTitle;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title : Text(videoTitle),
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
                  children: [
                    Center(
                      child: Image.network(
                        myVideo.urlImage,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.mainSpace,
                    ),
                    Text(
                      "Speaker: ${myVideo.speaker}",
                      style: textTheme.bodyLarge,
                    ),
                    Text(
                      "Duration: ${myVideo.duration}",
                      style: textTheme.bodyLarge,
                    ),
                    Text(
                      "Published at: ${myVideo.publishedAt}",
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: Dimens.mainSpace,
                    ),
                    Text(
                      myVideo.description,
                      style: textTheme.bodyLarge,
                    )
                  ]
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