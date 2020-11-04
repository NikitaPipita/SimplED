import 'package:flutter/material.dart';

import '../api_interection/authorized_user_info.dart';
import '../api_interection/data_models.dart';
import '../api_interection/requests.dart';
import 'achievements_card.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {

  Future<User> _futureUser;

  final profileTabs = [
    Tab(text: 'About me'),
    Tab(text: 'Achievements'),
  ];
  TabController _tabController;

  TextEditingController _userFirstNameController;
  TextEditingController _userLastNameController;
  TextEditingController _userDescriptionController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: profileTabs.length);

    _userFirstNameController = TextEditingController();
    _userFirstNameController.text = AuthorizedUserInfo.userInfo.firstName;

    _userLastNameController = TextEditingController();
    _userLastNameController.text = AuthorizedUserInfo.userInfo.lastName;

    _userDescriptionController = TextEditingController();
    _userDescriptionController.text = AuthorizedUserInfo.userInfo.biography;
  }

  @override
  void dispose() {
    _tabController.dispose();

    _userFirstNameController.dispose();
    _userLastNameController.dispose();
    _userDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AuthorizedUserInfo.needToUpdateInformation) {
      return FutureBuilder(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AuthorizedUserInfo.needToUpdateInformation = false;
            AuthorizedUserInfo.userInfo = snapshot.data;
            return profileNestedScrollView();
          } else if (snapshot.hasError) {
            return Center(
                child: Text("${snapshot.error}")
            );
          }
          return Center(
              child: CircularProgressIndicator()
          );
        },
      );
    }
    return profileNestedScrollView();
  }

  Widget profileNestedScrollView() {
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
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      EditProfilePage(
                        _userFirstNameController,
                        _userLastNameController,
                        _userDescriptionController,
                      ),
                  ),
                );

                if (result == 'update') {
                  AuthorizedUserInfo.needToUpdateInformation = true;
                  setState(() {
                    _futureUser = patchUpdateUserInfo(
                      AuthorizedUserInfo.userInfo.id,
                      firstName: _userFirstNameController.text,
                      lastName: _userLastNameController.text,
                      biography: _userDescriptionController.text,
                    );
                  });
                }
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
                  children: [
                    CircleAvatar(
                      //TODO: Fix photo view
//                      backgroundImage: NetworkImage(AuthorizedUserInfo.userInfo.imageUrl),
                      backgroundImage: NetworkImage('https://w1.pngwing.com/pngs/743/500/png-transparent-circle-silhouette-logo-user-user-profile-green-facial-expression-nose-cartoon.png'),
                      radius: 150.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      AuthorizedUserInfo.userInfo.firstName +
                          " " +
                          AuthorizedUserInfo.userInfo.lastName,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      AuthorizedUserInfo.userInfo.email,
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

class ProfileDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AuthorizedUserInfo.userInfo.biography,
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