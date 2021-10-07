import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageData {
  String? messageId;

  bool? read;

  String? sentTime;

  Map<String, String>? data;

  Map<String, String>? notification;

  MessageData({
    this.messageId,
    this.read,
    this.sentTime,
    this.data,
    this.notification,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) => _$MessageDataFromJson(json);

  factory MessageData.readMessage(bool value, MessageData data) => MessageData(
        messageId: data.messageId,
        read: value,
        sentTime: data.sentTime,
        data: data.data,
        notification: data.notification,
      );

  Map<String, dynamic> toJson() => _$MessageDataToJson(this);
}
