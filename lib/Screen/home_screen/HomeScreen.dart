import 'package:done_app/Screen/home_screen/PagePersonal.dart';
import 'package:done_app/Screen/home_screen/PagePublic.dart';
import 'package:done_app/tags/Tags.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  TabController _tabController;
  double width, height;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0,length:2, vsync: this);

  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Tags.colorPrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.white,

          tabs: [
            Tab(
              text: "Personal",
            ),
            Tab(
              text: "Public",
            ),
          ],
          labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
          unselectedLabelStyle: TextStyle(color: Colors.white60, fontSize: 15.0),
        ),
        actions: <Widget>[
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).pushNamed("/addDateScreen");

            },
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 26,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).pushNamed("/settingScreen");
            },
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 26,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: TabBarView(
          controller: _tabController,
          children: [
            PagePerson(),
            PagePublic()
          ]),
    );
  }
}
