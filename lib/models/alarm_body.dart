
import 'dart:typed_data';

class AlarmBody {
  int id;
  String time;
  String date;
  String description;
  String privacy;
  Uint8List file_url;


  AlarmBody(
      {
        this.id,
        this.time,
        this.date,
        this.description,
        this.privacy,
        this.file_url,});

  AlarmBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    date = json['date'];
    description = json['description'];
    privacy = json['privacy'];
    file_url = json['file_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['date'] = this.date;
    data['description'] = this.description;
    data['privacy'] = this.privacy;
    data['file_url'] = this.file_url;
    return data;
  }
}