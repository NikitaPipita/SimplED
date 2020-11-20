import 'package:flutter/material.dart';
import 'package:simpleed/api_interection/requests.dart';
import 'package:simpleed/course_view/course_task/task_card.dart';

import '../api_interection/data_models.dart';
import '../api_interection/preload_info.dart';
import '../user_courses/course_creation_page.dart';
import 'course_card.dart';
import 'course_task/task_list.dart';
import 'participant_card.dart';

class CoursePage extends StatefulWidget {
  final Course courseInfo;
  final CourseViewType status;
  final Function userCoursesPageUpdate;

  CoursePage(this.courseInfo, this.status, {this.userCoursesPageUpdate});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage>
    with SingleTickerProviderStateMixin {

  final courseTabs = [
    Tab(text: 'About'),
    Tab(text: 'Tasks'),
    Tab(text: 'Chat'),
    Tab(text: 'Participants'),
  ];

  TabController _tabController;

  Future _futureCourseTasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: courseTabs.length);

    _futureCourseTasks = getCourseTasks(widget.courseInfo.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final participants = [
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
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: true,
              actions: widget.status == CourseViewType.created
                  ? [
                      IconButton(
                        icon: Icon(Icons.create),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CourseCreationPage(
                                        widget.userCoursesPageUpdate,
                                        courseInfo: widget.courseInfo,
                                      )
                              )
                          );
                        },
                      )
                    ]
                  : [],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                    PreloadInfo.cloudUrl +
                    PreloadInfo.cloudName +
                    '/' +
                    widget.courseInfo.imageUrl),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: courseTabs,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            aboutCourse(),
            taskListFutureBuilder(),
            Container(),
            CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(participants),
                ),
              ],
            ),
          ], // <--- the array item is a ListView
        ),
      ),
    );
  }

  Widget aboutCourse() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.courseInfo.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 6.0,
            ),
            RichText(
              text: TextSpan(
                text: 'Teaching language: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
                children: <TextSpan> [
                  TextSpan(
                    text: PreloadInfo
                        .coursesLanguages[widget.courseInfo.language],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            RichText(
              text: TextSpan(
                text: 'Start date: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
                children: <TextSpan> [
                  TextSpan(
                    text: widget.courseInfo.startDate,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              widget.courseInfo.description,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskListFutureBuilder() {
    TaskListViewType taskListViewType = widget.status == CourseViewType.created
        ? TaskListViewType.creator
        : TaskListViewType.participant;
    var taskList = <Widget>[];
    return FutureBuilder(
      future: _futureCourseTasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (Task task in snapshot.data) {
            taskList
                .add(TaskCard(widget.courseInfo.id, taskListViewType, task));
          }
          return TaskList(widget.courseInfo.id, taskListViewType, taskList);
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
}
