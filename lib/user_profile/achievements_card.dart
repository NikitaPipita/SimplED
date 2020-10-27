import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
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
                backgroundImage: NetworkImage('https://banner2.cleanpng.com/20180420/oqe/kisspng-computer-icons-achievement-clip-art-learning-from-other-5ada58f92ed920.8491334515242590651919.jpg'),
                radius: 30.0,
              ),
              SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Achievement title',
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    'Description',
                    maxLines: 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
