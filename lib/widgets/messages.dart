import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final doc = chatSnapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: doc.length,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment:
                    doc[index]['userId'] == futureSnapshot.data.uid
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: doc[index]['userId'] == futureSnapshot.data.uid
                        ? const EdgeInsets.only(right: 20)
                        : const EdgeInsets.only(left: 20),
                    child: Text(
                      doc[index]['username'],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  MessageBubble(
                    doc[index]['username'],
                    doc[index]['user_image'],
                    doc[index]['text'],
                    doc[index]['userId'] == futureSnapshot.data.uid,
                    key: ValueKey(doc[index].documentID),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
