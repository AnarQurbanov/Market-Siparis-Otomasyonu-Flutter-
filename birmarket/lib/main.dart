import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'sayfalar/anasayfa.dart';
import 'sayfalar/girissayfasi.dart';
import 'modeller/urun.dart';
import 'yonlendirme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_){
        List<Urun> sepetListe = [];
        return sepetListe;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '1Market',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Yonlendirme(),
      ),
    );
  }
}

