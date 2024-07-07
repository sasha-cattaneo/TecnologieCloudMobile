import 'package:flutter/material.dart';
import '/models/user.dart';
import 'package:my_tedx/styles/dimens.dart';

class SingleUserPage extends StatelessWidget {
  SingleUserPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title : Text("${user.username}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.mainPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                user.image,
              ),
            ),
            Text(
              "Password: ${user.password}"
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tag",
                  style: textTheme.titleLarge,
                ),
                Wrap(
                  runSpacing: Dimens.smallPadding,
                  spacing: Dimens.smallPadding,
                  children: user.tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag.tag),
                        ),
                      )
                      .toList(),
                )
              ],
            ),

          ],
        )
      )
      // body: FutureBuilder<Video>(
      //   future: getSingleVideo(videoId),
      //   builder: (_, AsyncSnapshot<Video> snapshot){
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       if (snapshot.hasData) {
      //         Video myVideo = snapshot.data!;
      //         return SingleChildScrollView(
      //           padding: const EdgeInsets.all(Dimens.mainPadding),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Center(
      //                 child: Image.network(
      //                   myVideo.urlImage,
      //                 ),
      //               ),
      //               Text(
      //                 "Speaker: ${myVideo.speaker}",
      //                 // style: TextTheme.bodyLarge,
      //               ),
      //               Text(
      //                 "Duration: ${myVideo.duration}",
      //                 // style: TextTheme.bodyLarge,
      //               ),
      //               Text(
      //                 "Published at: ${myVideo.publishedAt}",
      //                 // style: TextTheme.bodyLarge,
      //               ),
      //               Text(
      //                 myVideo.description,
      //                 // style: TextTheme.bodyLarge,
      //               )
                    
                    
      //             ],
                  
      //             )
      //         );
      //     } else if (snapshot.hasError) {
      //       return Text("main.dart[212] ${snapshot.error}");
      //     }
      //     return const CircularProgressIndicator();
      //   } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //   }
      //   }
      // )
    );
  }
}