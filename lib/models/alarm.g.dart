// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alarm _$AlarmFromJson(Map<String, dynamic> json) {
  return Alarm(
      id: json['id'] as int,
      text: json['text'] as String,
      day: json['day'] as int,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      enabled: json['enabled'] as bool,
      audio: json['audio'] as String,
      local: json['local'] as bool);
}

Map<String, dynamic> _$AlarmToJson(Alarm instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'enabled': instance.enabled,
      'audio': instance.audio,
      'local': instance.local
    };
