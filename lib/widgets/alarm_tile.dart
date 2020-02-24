
import 'dart:io';
import 'dart:typed_data';

import 'package:done_app/models/alarm_body.dart';
import 'package:done_app/tags/Tags.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_record/flutter_record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmTile extends StatefulWidget {
  AlarmBody alarnBody;
  AlarmTile(this.alarnBody);

  @override
  _AlarmTileState createState() => _AlarmTileState(alarnBody);
}

class _AlarmTileState extends State<AlarmTile> {
  double spinner = 0;
  AlarmBody alarnBody;
  FlutterRecord _flutterRecord;

  _AlarmTileState(this.alarnBody);
  @override
  Widget build(BuildContext context) {
    _flutterRecord = FlutterRecord();

    return Padding(
      padding: const EdgeInsets.only(right: 8,left: 8,top: 2),
      child: GestureDetector(
        onTap: (){
//          Navigator.push(context, MaterialPageRoute(builder: (context) {return OrderDetailsPage(alarnBody);},),);
        },
        child: Row(
          children: <Widget>[
            Image.asset("assets/images/check.png",height: 50,
            width: 50,color: Colors.white,),
            Flexible(
              flex: 2,
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Time: ',style: TextStyle(color: Tags.colorPrimaryDark,fontSize: 18, fontWeight: FontWeight.bold)),
                          Expanded(
                              flex: 1,child: Container(
                              child:  Text(alarnBody.time.toString(),style: TextStyle(color: Tags.colorPrimary,fontSize: 18,)))),

                          InkWell(
                            onTap: () async {

//                              await Share.file("Share sound", "record.aac", alarnBody.file_url, "*/*", text: "");
                              _createFileFromString(alarnBody.file_url);
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset('assets/images/share.png',
                                    width: 30.0, height: 30.0,
                                color: Tags.colorPrimaryDark,),
                              ),),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Details: ',style: TextStyle(color: Tags.colorPrimaryDark, fontSize: 18,fontWeight: FontWeight.bold)),
                        ],
                      ),Row(
                        children: <Widget>[
                          Text(alarnBody.description,style: TextStyle(color: Tags.colorPrimary,fontSize: 18,)),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _createFileFromString(Uint8List bytes) async {
    Map<PermissionGroup, PermissionStatus>
    permissions = await PermissionHandler()
        .requestPermissions(
        [PermissionGroup.storage]);

    String dir = (await DownloadsPathProvider.downloadsDirectory).path;
    String fullPath = '$dir/record.aac';
    print("local file full path ${fullPath}");
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    print(file.path);

    _flutterRecord.setVolume(1.0);
    _flutterRecord.startPlayer(path: file.path);
//    final result = await ImageGallerySaver.saveImage(bytes);
//    print(result);

    return file.path;
  }
}