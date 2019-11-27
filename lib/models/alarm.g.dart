// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alarm _$AlarmFromJson(Map<String, dynamic> json) {
  return Alarm(
      id: json['id'] as int,
      text: json['text'] as String,
      days: (json['days'] as List)?.map((e) => e as int)?.toList(),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      enabled: json['enabled'] as bool,
      audio: json['audio'] as String);
}

Map<String, dynamic> _$AlarmToJson(Alarm instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'days': instance.days,
      'time': instance.time?.toIso8601String(),
      'enabled': instance.enabled,
      'audio': instance.audio
    };
