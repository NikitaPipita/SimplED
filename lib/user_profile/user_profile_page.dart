import 'dart:io';

import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:flutter/material.dart';

import '../api_interection/authorized_user_info.dart';
import '../api_interection/data_models.dart';
import '../api_interection/json_web_token.dart';
import '../api_interection/preload_info.dart';
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

  CloudinaryClient _cloudinary;
  File _image;
  getPhotoFileFromTheChild(File value) => _image = value;

  TextEditingController _userFirstNameController;
  TextEditingController _userLastNameController;
  TextEditingController _userDescriptionController;

  void updateUserInfo() async{
    AuthorizedUserInfo.needToUpdateInformation = true;
    String imageUrl;
    if (_image != null) {
      var response = await _cloudinary.uploadImage(_image.path, folder: 'profile_pics');
      imageUrl = 'v' + response.version.toString() +
          '/' + response.public_id +
          '.' + response.format;
    }
    setState(() {
      _futureUser = patchUpdateUserInfo(
        AuthorizedUserInfo.userInfo.id,
        image: imageUrl,
        firstName: _userFirstNameController.text,
        lastName: _userLastNameController.text,
        biography: _userDescriptionController.text,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: profileTabs.length);

    _cloudinary = CloudinaryClient(
        PreloadInfo.apiKey,
        PreloadInfo.apiSecret,
        PreloadInfo.cloudName);

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
                        getPhotoFileFromTheChild,
                        _userFirstNameController,
                        _userLastNameController,
                        _userDescriptionController,
                      ),
                  ),
                );
                if (result == UpdateUserProfilePageFlag.update) {
                  updateUserInfo();
                }
              },
            ),
            title: Text("Profile"),
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                tooltip: 'Exit',
                onPressed: () {
                  JsonWebToken.accessToken = null;
                  JsonWebToken.refreshToken = null;
                  AuthorizedUserInfo.userInfo = null;
                  AuthorizedUserInfo.needToUpdateInformation = true;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 90.0, 8.0, 15.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          PreloadInfo.cloudUrl +
                          PreloadInfo.cloudName +
                          '/' +
                          AuthorizedUserInfo.userInfo.imageUrl
                      ),
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
        ],
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