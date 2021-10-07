// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageData _$MessageDataFromJson(Map<String, dynamic> json) {
  return MessageData(
    messageId: json['messageId'] as String?,
    read: json['read'] as bool?,
    sentTime: json['sentTime'] as String?,
    data: (json['data'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    notification: (json['notification'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$MessageDataToJson(MessageData instance) => <String, dynamic>{
      'messageId': instance.messageId,
      'read': instance.read,
      'sentTime': instance.sentTime,
      'data': instance.data,
      'notification': instance.notification,
    };
