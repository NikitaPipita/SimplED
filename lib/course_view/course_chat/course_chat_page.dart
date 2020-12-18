import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../api_interaction/data_models.dart';
import '../../api_interaction/authorized_user_info.dart';
import '../../api_interaction/requests.dart';

enum MessageType {
  received,
  sent,
}

class ChatPage extends StatelessWidget {
  final Course course;

  final messages = <MessageCard>[];
  final messageReceivedKey = GlobalKey<MessagesReceivedState>();

  ChatPage(this.course);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder(
        future: getAllPreviousMessages(course.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (PreviousMessage message in snapshot.data) {
              messages.add(MessageCard(
                  message.user.id,
                  message.user.firstName + ' ' + message.user.lastName,
                  message.text));
            }
            return Column(
              children: [
                Expanded(
                    child: MessagesReceived(course, messages,
                        key: messageReceivedKey)),
                SendMessage(messageReceivedKey),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MessagesReceived extends StatefulWidget {
  final Course course;
  final List<MessageCard> previousMessages;

  MessagesReceived(this.course, this.previousMessages, {Key key})
      : super(key: key);

  @override
  MessagesReceivedState createState() => MessagesReceivedState();
}

class MessagesReceivedState extends State<MessagesReceived> {
  WebSocketChannel channel;

  var messages = <MessageCard>[];

  @override
  void initState() {
    channel = WebSocketChannel.connect(
      Uri.parse(
          'wss://simpled-api.herokuapp.com/chat/${widget.course.id.toString()}/'),
    );
    messages.addAll(widget.previousMessages);
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var message = Message.fromJson(jsonDecode(snapshot.data));
              messages.add(
                  MessageCard(message.userId, message.userName, message.text));
            } else if (snapshot.hasError) {
              print(snapshot.error);
            }
            return Column(
              children: messages,
            );
          },
        ),
      ),
    );
  }
}

class SendMessage extends StatefulWidget {
  final GlobalKey<MessagesReceivedState> messagesReceivedKey;

  SendMessage(this.messagesReceivedKey);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Message',
                ),
                maxLines: null,
              ),
            ),
            FlatButton(
              child: Icon(
                Icons.send_outlined,
              ),
              onPressed: () {
                if (messageController.text != '') {
                  var messageData = jsonEncode(<String, dynamic>{
                    'sender_id': AuthorizedUserInfo.userInfo.id,
                    'full_name': AuthorizedUserInfo.userInfo.firstName +
                        ' ' +
                        AuthorizedUserInfo.userInfo.lastName,
                    'text': messageController.text.trim(),
                  });
                  widget.messagesReceivedKey.currentState.channel.sink
                      .add(messageData);
                  messageController.text = '';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final int userId;
  final String userName;
  final String messageText;

  MessageCard(this.userId, this.userName, this.messageText);

  @override
  Widget build(BuildContext context) {
    MessageType messageType = userId == AuthorizedUserInfo.userInfo.id
        ? MessageType.sent
        : MessageType.received;

    return Card(
      color: messageType == MessageType.received
          ? Colors.white54
          : Colors.blue[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: messageType == MessageType.received
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Column(
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                messageText,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
