import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/models/shopping_grid.dart';
import 'package:yaanyo/models/shopping_task.dart';

final shoppingDatabaseServiceProvider =
    ChangeNotifierProvider<ShoppingDatabaseService>(
  (ref) => ShoppingDatabaseService(),
);

class ShoppingDatabaseService extends ChangeNotifier {
  final CollectionReference _shoppingCollection =
      FirebaseFirestore.instance.collection('shopping');

  Future createNewShoppingGrid({ShoppingGrid shoppingGrid}) async {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .doc(shoppingGrid.storeName)
        .set(shoppingGrid.toJson());
  }

  Stream<QuerySnapshot> getShoppingGridStream() {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    return _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future addShoppingTask({String storeName, ShoppingTask shoppingTask}) async {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .doc(storeName)
        .collection('shoppingTask')
        .doc(shoppingTask.taskLabel)
        .set(shoppingTask.toJson());
  }

  Stream<QuerySnapshot> getShoppingTaskStream(String storeName) {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    return _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .doc(storeName)
        .collection('shoppingTask')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future toggleShoppingTask(
      {ShoppingTask shoppingTask, String storeName}) async {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;
    return await _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .doc(storeName)
        .collection('shoppingTask')
        .doc(shoppingTask.taskLabel)
        .update(shoppingTask.toJson());
  }

  Future deleteShoppingGrid(
      {String storeName, List<String> gridTasksList}) async {
    final currentUserUID = FirebaseAuth.instance.currentUser.uid;

    /// deletes shoppingGrid document but does not delete its
    /// subcollections (shoppingTasks)
    /// https://firebase.google.com/docs/firestore/manage-data/delete-data
    _shoppingCollection
        .doc(currentUserUID)
        .collection('shoppingGrid')
        .doc(storeName)
        .delete()
        .whenComplete(() {
      /// loop in gridTask list to delete every entry otherwise re-creating a shoppingGrid
      /// with same old name will show old gridTask items since they are exist
      for (String task in gridTasksList) {
        _shoppingCollection
            .doc(currentUserUID)
            .collection('shoppingGrid')
            .doc(storeName)
            .collection('shoppingTask')
            .doc('$task')
            .delete();
      }
    });
  }
}
