library websocket_chat;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:websocket_chat/models/chat_message_model.dart';
import 'package:websocket_chat/tree_dots_animated.dart';

class WebsocketChat extends StatelessWidget {
  const WebsocketChat({
    required this.messages,
    required this.title,
    required this.hintText,
    required this.botName,
    required this.bubblePrimaryColor,
    required this.bubbleBotColor,
    required this.scrollController,
    required this.msgController,
    required this.onTap,
    required this.onChanged,
    required this.validator,
    required this.expiredTimeOut,
    required this.childTimeOut,
    required this.isWeb,
    this.showLeading = false,
    this.imageAvatar,
    this.textPrimaryColor,
    this.textBotColor,
    this.avatarBackGroundColor,
    this.appBarColor,
    this.appBarTextColor,
    this.actions,
    this.showHourMessageInUser = false,
    this.inputLength = 255,
    this.textContainerBuilder,
    this.likeButton,
    this.dislikeButton,
    this.copyButton,
    this.widgets,
    this.showPendingBotResponse = false,
    super.key,
  });

  final List<ChatMessageModel> messages;
  final String title;
  final String hintText;
  final String botName;
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
  final int inputLength;
  final bool expiredTimeOut;
  final Widget childTimeOut;
  final bool showLeading;
  final Widget Function(String, bool)? textContainerBuilder;
  final Function(ChatMessageModel)? likeButton;
  final Function(ChatMessageModel)? dislikeButton;
  final Function(ChatMessageModel)? copyButton;
  final bool isWeb;
  final Map<String, Widget Function(ChatMessageModel)>? widgets;
  final bool showPendingBotResponse;

  final Function() onTap;
  final Function(String) onChanged;
  final String? Function(String?) validator;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showLeading ? IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30,),
        ) : null,
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
      backgroundColor: Colors.white,
      body: SizedBox(
          height: MediaQuery.of(context).size.height*.9,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _chat(context),
              if ((messages.isNotEmpty && messages.last.isMe) ||
                  showPendingBotResponse) ...[
                expiredTimeOut? childTimeOut : _botWriting(),
              ],
              _InputMessageWidget(
                messages: messages,
                validator: validator,
                onChanged: onChanged,
                isWeb: isWeb,
                inputLength: inputLength,
                onTap: onTap,
                hintText: hintText,
                msgController: msgController,
                bubblePrimaryColor: bubblePrimaryColor,
              )
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

  String? _resolveWidgetTag(ChatMessageModel message) {
    try {
      final dynamic payload = message.message;
      if (payload is Map && payload.isNotEmpty) {
        final dynamic widgetTag = payload.keys.first;
        if (widgetTag is String && widgetTag.isNotEmpty) {
          return widgetTag;
        }
      }
    } on FormatException {
      final RegExpMatch? match = RegExp(
        "^\\s*\\{\\s*['\"]([^'\"]+)['\"]\\s*:",
      ).firstMatch(message.message);

      return match?.group(1);
    }

    return null;
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
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: const CupertinoActivityIndicator(),
                ),
              ),
            )
                : ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shrinkWrap: true,
              itemCount: messages.length, //docs.length,
              itemBuilder: (BuildContext context, int index) {
                final ChatMessageModel chatMessage = messages[index];
                //bool showDate = false;
                if (chatMessage.messageType == 4) {
                  final String? widgetTag = _resolveWidgetTag(chatMessage);
                  final Widget Function(ChatMessageModel)? widgetBuilder =
                      widgetTag != null && widgets != null
                          ? widgets![widgetTag]
                          : null;

                  return widgetBuilder?.call(chatMessage) ?? const SizedBox();
                }
                return itemMessage(chatMessage, index, context);
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
                child: imageAvatar ?? const SizedBox(),
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
                    botName,
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
                      textContainerBuilder != null
                          ? textContainerBuilder!(message.message, user)
                          : _defaultTextContainerBuilder(message.message, user),
                      const SizedBox(height: 4,),
                    ],
                    
                  ),
    
                ),
              ),
            
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(showHourMessageInUser! || !user)...[
                    Container(
                      margin: EdgeInsets.only(top: index==0 || (likeButton==null && dislikeButton==null) ? 8 : 0 ,left: user? 0 : 8, right: user? 16 : 10),
                      child: Text(
                        DateFormat('h:mm', 'es').format(message.date),
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                  if(!user && index != 0 && likeButton != null)...[
                    IconButton(
                      onPressed: () => likeButton!(message),
                      iconSize: 21,
                      icon: Icon(
                        message.isLiked ? Icons.thumb_up :
                        Icons.thumb_up_alt_outlined
                      ),
                      color: message.isLiked  ? Colors.grey[700] : Colors.grey[500],
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    
                  ],
                  if(!user && index != 0 && dislikeButton != null)...[
                    IconButton(
                      onPressed: () => dislikeButton!(message),
                      iconSize: 21,
                      icon: Icon(
                        message.isDisliked ? Icons.thumb_down :
                        Icons.thumb_down_alt_outlined
                      ),
                      color: message.isDisliked  ? Colors.grey[700] : Colors.grey[500],
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ],
              ),
            ],
          ),
          if(!user && index != 0 && copyButton != null) ...[
            IconButton(
              onPressed: () => copyButton!(message),
              iconSize: 22,
              icon: const Icon(Icons.copy_all_outlined),
              color: Colors.grey[600],
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }

  Widget _defaultTextContainerBuilder(String message, bool isUser) {
    return Text(
      message,
      style: TextStyle(
        color: isUser ? textPrimaryColor ??  Colors.white 
          : textBotColor ?? Colors.black
      ),
      textAlign: !isUser ? TextAlign.start : TextAlign.end,
    );
  }
}

class _InputMessageWidget extends StatefulWidget {
  const _InputMessageWidget({
    required this.messages,
    required this.validator,
    required this.onChanged,
    required this.isWeb,
    required this.inputLength,
    required this.onTap,
    required this.hintText,
    required this.msgController,
    required this.bubblePrimaryColor,
  });

  final List<ChatMessageModel> messages;
  final String? Function(String?) validator;
  final Function(String) onChanged;
  final bool isWeb;
  final int inputLength;
  final Function() onTap;
  final String hintText;
  final TextEditingController msgController;
  final Color bubblePrimaryColor;

  @override
  State<_InputMessageWidget> createState() => _InputMessageWidgetState();
}

class _InputMessageWidgetState extends State<_InputMessageWidget> {
  bool _isSending = false;

  void _handleTap() {
    if (_isSending || widget.msgController.text.trim().isEmpty) return;

    setState(() {
      _isSending = true;
    });

    // Invoke the parent onTap logic
    widget.onTap();
    
    // Disable button for a short time to prevent double taps
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
        child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxHeight: 120.0,
                ),
                child: TextFormField(
                  enabled: widget.messages.isNotEmpty,
                  validator: widget.validator,
                  onChanged: widget.onChanged,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: widget.isWeb ? TextInputAction.send : null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.inputLength),
                  ],
                  onFieldSubmitted: widget.isWeb ? (_) => _handleTap() : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                     borderSide: const BorderSide(width: 1),
                     borderRadius: BorderRadius.circular(30)
                    ),
              
                    focusedBorder: OutlineInputBorder(
                     borderSide: const BorderSide(width: 1),
                     borderRadius: BorderRadius.circular(30)
                    ),
                    suffixIcon: InkWell(
                      onTap: _isSending ? null : _handleTap,
                      child: Icon(
                        Icons.send,
                        color: _isSending ? Colors.grey : widget.bubblePrimaryColor,
                      ),
                    ),
                      hintText: widget.hintText,
                  ),
                  controller: widget.msgController,
                ),
              ),
            )),
      ),
    );
  }
}

