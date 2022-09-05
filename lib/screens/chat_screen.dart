import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
var logged_in_user;
final _store = FirebaseFirestore.instance;
var msgsid = 0;

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  String message_txt;

  void messageStream() async {
    await for (var snapshot in _store.collection("message").snapshots()) {
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }

  void getCureentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        logged_in_user = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCureentuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StBuilder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        //Do something with the user input.
                        message_txt = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      textController.clear();
                      _store.collection("message").add({
                        'text': message_txt,
                        'sender': logged_in_user.email,
                        'id': msgsid
                      });
                      msgsid++;
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _store.collection("message").snapshots(),
        builder: (context, snapshot) {
          List<chatBubble> chatBubbles = [];
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              backgroundColor: Colors.blueGrey.shade800,
            );
          }
          var msgdata = snapshot.data.docs.sort(snapshot.data.docs.);
          for (var doc in msgdata) {
            chatBubbles.add(chatBubble(
              isMe: logged_in_user.email == doc.get('sender'),
              msgsender: doc.get('sender'),
              msgtext: doc.get('text'),
            ));
            print(doc.get('text'));
          }
          return Expanded(
            child: ListView(
              children: chatBubbles,
              reverse: true,
              //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            ),
          );
        });
  }
}

class chatBubble extends StatelessWidget {
  chatBubble({this.msgtext, this.msgsender, this.isMe});
  final String msgtext, msgsender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          msgsender,
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            color: isMe ? Colors.blueGrey.shade500 : Colors.blueGrey.shade700,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                this.msgtext,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
