import 'package:flutter/material.dart';

class ParticipantCard extends StatelessWidget {
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
                backgroundImage: NetworkImage('https://w1.pngwing.com/pngs/743/500/png-transparent-circle-silhouette-logo-user-user-profile-green-facial-expression-nose-cartoon.png'),
                radius: 30.0,
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                'Name Name',
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
