import 'package:json_annotation/json_annotation.dart';
part 'alarm.g.dart';

@JsonSerializable(explicitToJson: true)
class Alarm {
  int id;
  String text;
  // List<int> days;
  int day;
//  DateTime time;
  int hour;
  int minute;
  bool enabled;
  String audio;
  bool local = true;
  double vibrationLevel = 0.0;
  double soundLevel = 0.0;
  //Timer t;

  Alarm(
      {this.id,
      this.text,
      this.day,
      this.hour,
      this.minute,
      this.enabled,
      this.audio,
      this.local,
      this.soundLevel,
      this.vibrationLevel}) {
    //   if(enabled){

    // }
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
        id: json["id"],
        text: json["text"],
        day: json["day"],
        hour: json["hour"],
        minute: json["minute"],
        enabled: json["enabled"],
        audio: json["audio"],
        local: json["local"],
        vibrationLevel: json['vibrationLevel'],
        soundLevel: json['soundLevel']);
  }

  Map<String, dynamic> toJson() => _$AlarmToJson(this);

  void disable() {
    //removes the timer

    //sets enabled to be false;
  }
}
