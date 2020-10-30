import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'participant_card.dart';

class CoursePage extends StatefulWidget {

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> with SingleTickerProviderStateMixin {
  final courseTabs = [
    Tab(text: 'About'),
    Tab(text: 'Tasks'),
    Tab(text: 'Chat'),
    Tab(text: 'Participants'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: courseTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final firstBoxes = [
    ParticipantCard(),
    ParticipantCard(),
    ParticipantCard(),
    ParticipantCard(),
    ParticipantCard(),
    ParticipantCard(),
    ParticipantCard(),
    ParticipantCard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: SvgPicture.asset('assets/course_default_picture.svg'),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: courseTabs,
              ),
            ),
          ];
        },
        body: new TabBarView(
          controller: _tabController,
          children: [
            Container(
              child: Center(
                child: Text('Course description'),
              ),
            ),
            Container(),
            Container(),
            CustomScrollView(
              slivers: [
                SliverList(
                delegate: SliverChildListDelegate(firstBoxes),
                ),
              ],
            ),
          ],  // <--- the array item is a ListView
        ),
      ),
    );
  }
}
