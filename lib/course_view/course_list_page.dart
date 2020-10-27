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
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PickDateButton(),
                      ],
                    )
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


class PickDateButton extends StatefulWidget {
  @override
  _PickDateButtonState createState() => _PickDateButtonState();
}

class _PickDateButtonState extends State<PickDateButton> {

  DateTime _selectedDate = DateTime.now();

  void changeSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(_selectedDate.year.toString() + '-'
          + _selectedDate.month.toString() + '-'
          + _selectedDate.day.toString()),
      onPressed: () {
        showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        ).then((date) => changeSelectedDate(date));
      },
    );
  }
}
