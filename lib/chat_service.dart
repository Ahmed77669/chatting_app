import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chating_app/message.dart';

class chat_service {
  Stream<List<Map<String, dynamic>>> getUserData() {
    return FirebaseFirestore.instance
        .collection('Users')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data() as Map<String, dynamic>;
        return user;
      }).toList();
    });
  }


  Future<void> sendMessage(String receiverID, String message,
      {String? imageUrl}) async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    final String? currentUserName =
        FirebaseAuth.instance.currentUser!.displayName;

    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail!,
      senderName: currentUserName!,
      receiverId: receiverID,
      message: message,
      timestamp: timestamp,
      imageUrl: imageUrl,
    );

    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatId = ids.join('_');

    await FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Stream to get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatId = ids.join('_');

    return FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
