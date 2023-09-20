library websocket_chat;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:websocket_chat/models/chat_message_model.dart';
import 'package:websocket_chat/tree_dots_animated.dart';

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
    this.imageAvatar,
    this.textPrimaryColor,
    this.textBotColor,
    this.avatarBackGroundColor,
    this.appBarColor,
    this.appBarTextColor,
    this.actions,
    this.showHourMessageInUser = false,
    super.key,
  });

  final List<ChatMessageModel> messages;
  final String title;
  final String hintText;
  final Color bubblePrimaryColor;
  final Color bubbleBotColor;
  final ScrollController scrollController;
  final TextEditingController msgController;
  final Color? textPrimaryColor;
  final Color? textBotColor;
  final Widget? imageAvatar;
  final Color? avatarBackGroundColor;
  final Color? appBarColor;
  final Color? appBarTextColor;
  final List<Widget>? actions;
  final bool? showHourMessageInUser;

  final Function() onTap;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30,),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: appBarTextColor ?? Colors.white
          ),
        ),
        actions: actions,
        backgroundColor: appBarColor ?? Colors.black,
        elevation: 1,
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height*.9,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _chat(context),
              if (messages.isNotEmpty && messages.last.isMe) ...[
                _botWriting(),
              ],
              _inputMessage(context)
            ],
          )
      ),
    );
  }

  Widget _botWriting() {
    return const Padding(
      padding: EdgeInsets.only(
        left: 47,
        top: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Escribiendo',
            style: TextStyle(
                fontSize: 12
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: TreeDotsAnimated(
              size: 2,
              color: Colors.black,
              curve: Curves.easeInOut,
            ),
          )
        ],
      ),
    );
  }

  Widget _inputMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        bottom: 20,
      ),
      width: MediaQuery.of(context).size.width,
      child: Container(
        width: MediaQuery.of(context).size.width * .7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child:  Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxHeight: 120.0,
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border:  OutlineInputBorder(
                     borderSide: const BorderSide(width: 1),
                     borderRadius: BorderRadius.circular(30)
                    ),
              
                    focusedBorder:  OutlineInputBorder(
                     borderSide: const BorderSide(width: 1),
                     borderRadius: BorderRadius.circular(30)
                    ),
                    suffixIcon: InkWell(
                onTap: onTap,
                child: Icon(Icons.send, color: bubblePrimaryColor)
                        ),
                      hintText: hintText),
                  controller: msgController,
                  
                  
                ),
              ),
            )),
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: user? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(!user)...[
            Container(
              margin: const EdgeInsets.only(left: 10.0, bottom: 30, right: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: avatarBackGroundColor ?? Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: imageAvatar ?? const SizedBox(),
                )
              ),
            )
    
          ],
          Column(
            crossAxisAlignment: user? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if(showHourMessageInUser! || !user)...[
                Container(
                  margin: EdgeInsets.only(top:8, left: user? 0 : 8, right: user? 16 : 0),
                  child: Text(
                    'Bot',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
              Container(
                margin: user
                    ? const EdgeInsets.only(top: 20, right: 20, bottom: 10)
                    : const EdgeInsets.only(top: 8, left: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(user? 10 : 0),
                    topRight: Radius.circular(user? 0 : 10),
                    bottomLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.25),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                        style: TextStyle(
                          color: user? textPrimaryColor ??  Colors.white 
                            : textBotColor?? Colors.black
                        ),
                        textAlign: !user ? TextAlign.start : TextAlign.end,
                      ),
                      const SizedBox(height: 4,),
                    ],
                    
                  ),
    
                ),
              ),
              if(showHourMessageInUser! || !user)...[
                Container(
                  margin: EdgeInsets.only(top:8, left: user? 0 : 8, right: user? 16 : 0),
                  child: Text(
                    DateFormat('h:mm', 'es').format(message.date),
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    textAlign: TextAlign.start,
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
