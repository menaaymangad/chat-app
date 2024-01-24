import 'package:chatapp/constants/consts.dart';

class MessageModel {
  String message;
  String id;
  MessageModel({required this.message, required this.id});
  factory MessageModel.fromJson(json) {
    return MessageModel(
      message: json[KMessage],
      id: json['id'],
    );
  }
}
