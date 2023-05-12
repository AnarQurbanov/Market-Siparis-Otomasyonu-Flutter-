import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Urun extends StatelessWidget {
  final int id;
  final String isim;
  final double fiyat;
  final String resimLink;
  final int stok;
  final int kategoriID;
  final String aciklama;

  Urun({this.id, this.isim, this.fiyat, this.resimLink, this.stok, this.kategoriID,this.aciklama});



  factory Urun.dokumandanUret(DocumentSnapshot doc){
    return Urun(
      id: int.parse(doc.documentID.toString()),
      isim: doc.data["isim"].toString(),
      fiyat: double.parse(doc.data["fiyat"].toString()),
      resimLink: doc.data["resimLink"].toString(),
      stok: int.parse(doc.data["stok"].toString()),
      kategoriID: int.parse(doc.data["kategoriID"].toString()),
      aciklama: doc.data["aciklama"].toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}