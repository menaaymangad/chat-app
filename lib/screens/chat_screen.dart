// ignore_for_file: must_be_immutable

import 'package:chatapp/constants/consts.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/widgets/chat_bubble.dart';
import 'package:chatapp/widgets/chat_bubble2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  static String id = 'ChatScreen';

  CollectionReference messages =
      FirebaseFirestore.instance.collection(KMessage);

  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();
  // ignore: prefer_typing_uninitialized_variables
  var email;
  @override
  Widget build(BuildContext context) {
    email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(KCreatedAt, descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messagesText = [];
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            messagesText.add(
              MessageModel.fromJson(snapshot.data!.docs[i]),
            );
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: KPrimaryColor,
              title: const Text(
                'Chat',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesText.length,
                    itemBuilder: (context, index) {
                      return messagesText[index].id == email
                          ? ChatBubble(messageModel: messagesText[index])
                          : ChatBubble2(messageModel: messagesText[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      addMessage(data);
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          addMessage(controller.text);
                        },
                        icon: const Icon(
                          Icons.send,
                          size: 32,
                          color: KPrimaryColor,
                        ),
                      ),
                      hintText: 'Enter your message',
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Loading...');
        }
      },
    );
  }

  void addMessage(String data) {
    messages.add({
      KMessage: data,
      KCreatedAt: DateTime.now(),
      'id': email,
    });
    controller.clear();
    _controller.animateTo(
      0,
      duration: const Duration(microseconds: 100),
      curve: Curves.easeIn,
    );
  }
}
