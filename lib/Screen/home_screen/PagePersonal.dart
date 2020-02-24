import 'package:async_loader/async_loader.dart';
import 'package:done_app/Screen/add_date_screen/check_password_dialog.dart';
import 'package:done_app/models/alarm_body.dart';
import 'package:done_app/tags/Tags.dart';
import 'package:done_app/utils/database.dart';
import 'package:done_app/widgets/alarm_tile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PagePerson extends StatefulWidget {
  @override
  _PagePersonState createState() => _PagePersonState();
}

class _PagePersonState extends State<PagePerson> {
  DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var _asyncLoaderalarms = new AsyncLoader(
      key: asyncLoaderStateAlarms,
      initState: () async => await getAlarmsData(),
      renderLoad: () => Padding(
        padding: const EdgeInsets.only(top: 48.0),
        child: Center(child: new CircularProgressIndicator()),
      ),
      renderError: ([error]) => getNoConnectionWidget(),
      renderSuccess: ({data}) => setAlarmssData(data),
    );

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(),
        Center(
            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: width * 0.05),
                width: width,
                height: height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Tags.colorPrimary, Tags.colorEndGradient],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [.3, .9])),
                child: SmartRefresher(
                  header: WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: SingleChildScrollView(child: _asyncLoaderalarms),
                )))
      ],
    );
  }

  final GlobalKey<AsyncLoaderState> asyncLoaderStateAlarms =
      new GlobalKey<AsyncLoaderState>(debugLabel: "__RIKEY1__");

  //swipe refresh
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    asyncLoaderStateAlarms.currentState.reloadState();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch

    asyncLoaderStateAlarms.currentState.reloadState();
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length+1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Widget getNoConnectionWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 60.0,
          child: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('assets/images/wifi.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        new Text("No Internet Connection"),
        new FlatButton(
            color: Colors.red,
            child: new Text(
              'retry',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _onRefresh();
            })
      ],
    );
  }

  bool access = false;

  setAlarmssData(List<AlarmBody> data) {
    return data.length != 0
        ? (access
            ? ListView.builder(
                shrinkWrap: true,
                physics: PageScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) => AlarmTile(data[index]),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: <Widget>[
                      Text('Not Authorized !!',
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9))),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 15),
                        child: Container(
                          child: RaisedButton(
                            onPressed: () async {

                              showDialog(
                                context: context,
                                builder: (_) => CheckPasswordDialog(),
                              ).then((val) {
                                setState(() {
                                  access = CheckPasswordDialog.access;
                                });
                              });
                            },
                            color: Tags.colorPrimary,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => CheckPasswordDialog(),
                                ).then((val) {
                                  setState(() {
                                    access = CheckPasswordDialog.access;
                                  });
                                });
                              },
                              child: Text(
                                "Show",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.white)),
                          ),
                          width: 150,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        : Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: <Widget>[
                  Text('Empty Alarm',
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9))),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 15),
                    child: Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/addDateScreen");
                        },
                        color: Tags.colorPrimary,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/addDateScreen");
                          },
                          child: Text(
                            "Add Alarm !!",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.white)),
                      ),
                      width: 150,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  getAlarmsData() async {
    List<AlarmBody> alarms = await dbHelper.getproducts();
    List<AlarmBody> alarmsPersonal = [];

    for (int i = 0; i < alarms.length; i++) {
      AlarmBody item = alarms[i];
      if (item.privacy == 'Personal') alarmsPersonal.add(item);
    }
    return alarmsPersonal;
  }


}
