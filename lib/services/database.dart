import 'package:brew_crew/model/brew.dart';
import 'package:brew_crew/model/user.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return uid != null
        ? await brewCollection
            .doc(uid)
            .set({'sugars': sugars, 'name': name, 'strength': strength})
        : null;
  }

  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Brew(
            name: doc.get('name'),
            sugars: doc.get('sugars'),
            strength: doc.get('strength')))
        .toList();
  }

  //CustomUserData model from snapshot
  CustomUserData _customUserDataFromSnapshot(
      DocumentSnapshot documentSnapshot) {
    return CustomUserData(
        uid: uid,
        name: documentSnapshot.get('name'),
        sugars: documentSnapshot.get('sugars'),
        strength: documentSnapshot.get('strength'));
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get user doc stream
  Stream<CustomUserData> get userData {
    return brewCollection.doc(uid).snapshots().map(
        (documentSnapshot) => _customUserDataFromSnapshot(documentSnapshot));
  }
}
