import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    return const Stream<List<ChatMessage>>.empty();
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    // ChatMessage => Map<String, dynamic>
    final docRef = await store.collection('chat').add({
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
      'userId': user.id,
      'userName': user.name,
      'userImageUrl': user.imageUrl,
    });

    final doc = await docRef.get();
    final data = doc.data()!;

    // Map<String, dynamic> => ChatMessage

    return ChatMessage(
        id: doc.id,
        text: data['text'],
        createdAt: DateTime.parse(data['createdAt']),
        userId: data['userId'],
        userName: data['userName'],
        userImageUrl: data['userImageUrl']);
  }
}

// .withConverter(
//   fromFirestore: fromFirestore,
//   toFirestore: toFirestore,
// )

// ChatMessage => Map<String, dynamic>

// Map<String, dynamic> => ChatMessage
ChatMessage _fromFirestore(
  DocumentSnapshot<Map<String, dynamic>> doc,
  SnapshotOptions? options,
) {
  return ChatMessage(
    id: doc.id,
    text: doc['text'],
    createdAt: DateTime.parse(doc['createdAt']),
    userId: doc['userId'],
    userName: doc['userName'],
    userImageUrl: doc['userImageUrl'],
  );
}
