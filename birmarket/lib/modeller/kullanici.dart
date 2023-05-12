import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Kullanici{
  final String id;
  final String kullaniciAdi;
  final String mail;
  final String adres;
  final String telefonNo;

  Kullanici({this.id, this.kullaniciAdi, this.mail, this.adres, this.telefonNo});

  factory Kullanici.dokumandanUret(DocumentSnapshot doc){
    return Kullanici(
      id: doc.documentID,
      kullaniciAdi: doc.data["kullaniciAdi"],
      mail: doc.data["mail"],
      adres: doc.data["adres"],
      telefonNo: doc.data["telefonNo"],
    );
  }

  factory Kullanici.firebasedenUret(FirebaseUser kullanici) {
    return Kullanici(
      id: kullanici.uid,
      kullaniciAdi: kullanici.displayName,
      mail: kullanici.email,
      telefonNo: kullanici.phoneNumber,
    );
  }
}