library websocket_chat;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:websocket_chat/models/chat_message_model.dart';

class WebsocketChat extends StatelessWidget {
  const WebsocketChat({
    required this.messages,
    required this.title,
    required this.hintText,
    required this.bubblePrimaryColor,
    required this.bubbleBotColor,
    required this.scrollController,
    required this.msgController,
    required this.onTap,
    super.key,
  });

  final List<ChatMessageModel> messages;
  final String title;
  final String hintText;
  final Color bubblePrimaryColor;
  final Color bubbleBotColor;
  final ScrollController scrollController;
  final TextEditingController msgController;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 1,
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height*.9,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _chat(context),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Color(0xfff6f6f6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child:  Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 10, bottom: 10),
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration.collapsed(
                                  hintText: hintText),
                              controller: msgController,
                            ),
                          )),
                    ),
                    InkWell(
                        onTap: onTap,
                        child: Icon(Icons.send, color: bubblePrimaryColor)
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }

  Widget _chat(BuildContext context) {
    return Expanded(
        child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: messages.isEmpty?
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .14),
                child: const Text(
                  "Aún no tienes una conversación",
                  style: TextStyle(color: Colors.orange, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shrinkWrap: true,
              itemCount: messages.length, //docs.length,
              itemBuilder: (BuildContext context, int index) {
                //bool showDate = false;
                return itemMessage(messages[index], index, context);
              },
            )
        )
    );
  }

  Widget itemMessage(ChatMessageModel message, int index, BuildContext context) {
    bool user = message.isMe;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: user
                ? const EdgeInsets.only(top: 20, right: 20)
                : const EdgeInsets.only(top: 20, left: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: user ? bubblePrimaryColor : bubbleBotColor,
            ),
            width: MediaQuery.of(context).size.width * .7,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18, right: 18, bottom: 7, top: 12),
              child: Column(
                crossAxisAlignment:
                !user ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(
                    message.message,
                    style: const TextStyle(color: Colors.white),
                    textAlign: !user ? TextAlign.start : TextAlign.end,
                  ),
                  const SizedBox(height: 4,),
                  Text(
                    DateFormat('dd MMM h:mm a', 'es').format(message.date),
                    style: const TextStyle(fontSize: 8, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),

            ),
          ),
        ],
      ),
    );
  }
}
