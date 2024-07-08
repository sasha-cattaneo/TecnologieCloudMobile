import 'package:flutter/material.dart';
import '/models/user.dart';
import 'package:my_tedx/styles/dimens.dart';

class SingleUserPage extends StatelessWidget {
  const SingleUserPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title : Text(user.username),
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
              "Password: ${user.password}",
              style: textTheme.bodyLarge,
            ),
            const SizedBox(
              height: Dimens.mainSpace,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tags",
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
    );
  }
}