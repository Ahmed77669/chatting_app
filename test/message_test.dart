import 'package:chating_app/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {
  test('class should be instantiated correctly', () {
    final timestamp = Timestamp.now();
    final message = Message(
      senderId: '2323237',
      senderEmail: 'ssdsdsds@gmail.com',
      senderName: 'Ahmed Yousef',
      receiverId: '2424248',
      message: 'Hello!',
      timestamp: timestamp,
      imageUrl: 'http://firestore.com/image.png',
    );

    expect(message.senderId, '2323237');
    expect(message.senderEmail, 'user@gmail.com');
    expect(message.senderName, 'Ahmed Yousef');
    expect(message.receiverId, '2424248');
    expect(message.message, 'Hello!');
    expect(message.timestamp, timestamp);
    expect(message.imageUrl, 'http://firestore.com/image.png');
  });

}