import 'package:flutter/material.dart';

import 'course_card.dart';

class CourseList extends StatelessWidget {

  final courseList = <Widget>[
    CourseCard(),
    CourseCard(),
    CourseCard(),
    CourseCard(),
    CourseCard(),
    CourseCard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 10.0),
                child: Column(
                  children: [
                    SearchTextField(),
                  ],
                ),
              ),
            ),
          ),
          //TODO: Replace with API request.
          SliverList(
            delegate: SliverChildListDelegate(courseList),
          ),
        ],
      ),
    );
  }
}


class SearchTextField extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {

  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search Course...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90.0),
          borderSide: BorderSide(),
        ),
      ),
      //TODO: Send new request to the server.
      //TODO: Replace course list with new values and set new state.
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        print(_searchController.text);
      },
    );
  }
}
