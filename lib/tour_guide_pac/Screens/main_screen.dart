import 'package:flutter/material.dart';
import 'package:iter_tour_guide/tour_guide_pac/Screens/confirmed_requests.dart';
import 'package:iter_tour_guide/tour_guide_pac/Screens/profile_screen.dart';
import 'package:iter_tour_guide/tour_guide_pac/Screens/trip_requests.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/titles.dart';

class MainScreen extends StatefulWidget {
  final String uid;

  const MainScreen({Key key, this.uid}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int itemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        children: <Widget>[
          _bottomNavBarItem(0, "Profile"),
          _bottomNavBarItem(1, "Pending Requests"),
          _bottomNavBarItem(2, "Confirmed Requests"),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    Widget slogan;

    switch (itemIndex) {
      case 0:
        slogan = ProfileScreen(uid: widget.uid);
        break;
      case 1:
        slogan = Requests(uid: widget.uid);
        break;
      case 2:
        slogan = ConfirmedRequests(uid: widget.uid);
        break;

        break;
      default:
    }
    return slogan;
  }

  Widget _bottomNavBarItem(int index, String field) {
    return GestureDetector(
      onTap: () {
        setState(() {
          itemIndex = index;
          print(index);
        });
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(color: Colors.white),
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          children: <Widget>[
            index == itemIndex
                ? ClipRRect(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: 3,
                      color: Colors.deepPurple,
                    ),
                  )
                : SizedBox(height: 3),
            SizedBox(height: 12),
            SizedBox(height: 8),
            Titles(
              title: field,
            )
          ],
        ),
      ),
    );
  }
}
