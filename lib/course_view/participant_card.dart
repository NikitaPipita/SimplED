import 'package:flutter/material.dart';

import '../api_interaction/data_models.dart';
import '../api_interaction/preload_info.dart';

class ParticipantCard extends StatelessWidget {
  final User user;

  ParticipantCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(PreloadInfo.cloudUrl +
                    PreloadInfo.cloudName +
                    '/' +
                    user.imageUrl),
                radius: 30.0,
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                user.firstName + ' ' + user.lastName,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
