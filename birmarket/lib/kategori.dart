import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'modeller/urun.dart';
import 'urun_detay.dart';
import 'dart:io';

class Kategori extends StatefulWidget {
  final String kategori;

  const Kategori({Key key, this.kategori}) : super(key: key);

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  List<Widget> _gosterilecekListe = [];
  List<Urun> urunler = [];

  Future<List<Urun>> urunlerGetir() async {
    var snapshot = await Firestore.instance
        .collection("Urunler")
        .getDocuments()
        .then((snapshot) {
      urunler =
          snapshot.documents.map((doc) => Urun.dokumandanUret(doc)).toList();
    });

    print(urunler.length);
    return urunler;
  }

  void ekleme(int kID, List<Urun> urunler) {
    _gosterilecekListe = [];
    for (int i = 0; i < urunler.length; i++) {
      if (urunler[i].kategoriID == kID) {
        _gosterilecekListe.add(urunKarti(
          urunler[i].id,
          urunler[i].isim,
          urunler[i].fiyat,
          urunler[i].resimLink,
          urunler[i].stok,
          urunler[i].aciklama,
          urunler[i].kategoriID
        ));
      }
    }
  }

  Widget urunKarti(int id,String isim, double fiyat, String resimYolu, int stok,String aciklama,kategoriID){
    return GestureDetector(
      //Hareketleri tespit eden dedektor
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UrunDetay(
              isim: isim,
              fiyat: fiyat,
              resimYolu: resimYolu,
              stok: stok,
              aciklama: aciklama,
              kategoriID: kategoriID,
              id : id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 2, //golgenin yayilmasi
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: resimYolu,
              child: Container(
                height: 80,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(resimYolu),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              isim,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "$fiyat TL",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double uzunluk = MediaQuery.of(context).size.height;
    double en = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<List<Urun>>(
        future: urunlerGetir(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (widget.kategori == "Temel Gıda") {
            ekleme(0, urunler);
          } else if (widget.kategori == "Atıştırmalık") {
            ekleme(1, urunler);
          } else if (widget.kategori == "Kahvaltılık") {
            ekleme(2, urunler);
          } else if (widget.kategori == "Su & İçecek") {
            ekleme(3, urunler);
          } else if (widget.kategori == "Meyve & Sebze") {
            ekleme(4, urunler);
          }

          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: uzunluk / 50,
            crossAxisSpacing: en / 30,
            padding: EdgeInsets.all(10),
            childAspectRatio: 1, //en boy orani
            children: _gosterilecekListe,
          );
        },
      ),
    );
  }
}
