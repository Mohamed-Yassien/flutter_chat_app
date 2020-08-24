import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.userName, this.imageUrl,this.message, this.isMe, {this.key});

  final bool isMe;
  final String message;
  final Key key;
  final String userName;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: isMe ? Radius.circular(20) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(20),
                ),
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              ),
              width: 140,
              child: Text(
                message,
                style: TextStyle(
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline1.color),
              ),
            ),
          ],
        ),
        Positioned(
          left: isMe ? MediaQuery.of(context).size.width * .52 : null,
          right: !isMe ? MediaQuery.of(context).size.width * .52 : null,
          top:  -10,
          child: CircleAvatar(backgroundImage: NetworkImage(imageUrl),radius: 16,),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
