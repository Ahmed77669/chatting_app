import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String senderName;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String? imageUrl;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.senderName,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.imageUrl,
  });


  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'senderName': senderName,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
    };
  }
}
