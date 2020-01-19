import 'package:done_app/tags/Tags.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: width * 0.05),
        width: width,
        height: height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Tags.colorPrimary, Tags.colorEndGradient],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [.3, .9])),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 45),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 26.0,
                          color: Colors.white,
                        ),
                      )),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        "assets/images/done_logo.png",
                        width: 220,
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("/profileScreen");
                                  },
                                  child: _getIcons('Profile', Icons.person)),
                              _getIcons('Language', Icons.language),
                              InkWell(
                                  onTap: () {},
                                  child: _getCustomIcons('Contact Us',
                                      "assets/images/contact.png")),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pushNamed("/termsScreen",arguments: 2);

                                },
                                  child: _getIcons(
                                      'About Us', Icons.info_outline)),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        "/termsScreen",
                                        arguments: 1);
                                  },
                                  child: _getCustomIcons(
                                      "Terms", "assets/images/terms.png")),
                              _getIcons('Rate', Icons.star),
                              _getIcons('Share', Icons.share),
                              _getCustomIcons(
                                  "Logout", "assets/images/logout.png")
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getIcons(String title, IconData iconData) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            size: 24.0,
            color: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 13.0, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _getCustomIcons(String title, String iconAssetName) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            iconAssetName,
            width: 24.0,
            height: 24.0,
            color: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 13.0, color: Colors.white),
          )
        ],
      ),
    );
  }
}
