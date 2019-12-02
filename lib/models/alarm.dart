import 'package:json_annotation/json_annotation.dart';
part 'alarm.g.dart';

@JsonSerializable(explicitToJson: true)

class Alarm {
  int id;
  String text;
  List<int> days;
  DateTime time;
  bool enabled;
  String audio;
  //Timer t;

  Alarm({this.id, this.text, this.days, this.time, this.enabled, this.audio}){
    if(enabled){

    }
  }

  factory Alarm.fromJson(Map<String, dynamic> json){
      return Alarm(id: json["id"], text: json["text"], days: json["days"], time: DateTime.parse(json["time"]), enabled: json["enabled"], audio: json["audio"]);
    }

//  factory Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);

   Map<String, dynamic> toJson() => _$AlarmToJson(this);

   void disable(){
     //removes the timer

     //sets enabled to be false;
   }
}