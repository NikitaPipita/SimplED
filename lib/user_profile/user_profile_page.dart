import 'package:flutter/material.dart';

import 'achievements_card.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {

  final profileTabs = [
    Tab(text: 'About me'),
    Tab(text: 'Achievements'),
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: profileTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder:
          (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 470.0,
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.edit),
              //TODO: implement page reload after closing the profile edit page
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            title: Text("Profile"),
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                tooltip: 'Exit',
                //TODO: implement exit from profile
                onPressed: () { /* ... */ },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 90.0, 8.0, 15.0),
                child: Column(
                  //TODO: Replace with user profile info
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://w1.pngwing.com/pngs/743/500/png-transparent-circle-silhouette-logo-user-user-profile-green-facial-expression-nose-cartoon.png'),
                      radius: 150.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Name Name',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      'email@gmail.com',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: profileTabs,
            ),
          ),
        ];
      },
      body: new TabBarView(
        controller: _tabController,
        children: [
          ProfileDescription(),
          AchievementsList(),
        ],  // <--- the array item is a ListView
      ),
    );
  }
}

class ProfileDescription extends StatefulWidget {
  @override
  _ProfileDescriptionState createState() => _ProfileDescriptionState();
}

class _ProfileDescriptionState extends State<ProfileDescription> {
  @override
  Widget build(BuildContext context) {
    //TODO: Replace with API request
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            ),
          ),
        ),
      ],
    );
  }
}


class AchievementsList extends StatefulWidget {
  @override
  _AchievementsListState createState() => _AchievementsListState();
}

class _AchievementsListState extends State<AchievementsList> {

  final firstBoxes = [
    AchievementCard(),
    AchievementCard(),
    AchievementCard(),
    AchievementCard(),
    AchievementCard(),
    AchievementCard(),
    AchievementCard(),
    AchievementCard(),
  ];

  @override
  Widget build(BuildContext context) {
    //TODO: Replace with API request
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(firstBoxes),
        ),
      ],
    );
  }
}