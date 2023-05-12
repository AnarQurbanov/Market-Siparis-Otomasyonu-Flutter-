import 'package:flutter/material.dart';
import 'kategori.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Urunler extends StatefulWidget {
  @override
  State<Urunler> createState() => _UrunlerState();
}

class _UrunlerState extends State<Urunler> with SingleTickerProviderStateMixin {
  TabController kontrolcu; //ekran hareketleri icin

  Future<List<String>> kategoriGetir() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("Kategori").getDocuments();
    List<String> kategoriIsimleri = [];
    snapshot.documents.forEach((kategori) {
      kategoriIsimleri.add(kategori["kategoriAd"].toString());
    });
    return kategoriIsimleri;
  }

  void initState() {
    super.initState();
    kontrolcu = TabController(
        length: 5, vsync: this); //4 kanal , vsync - animasyon icin
    //this verme nedenimiz ticker artik intstatein bir parcasi
  }

  @override
  Widget build(BuildContext context) {
    double uzunluk = MediaQuery.of(context).size.height;
    double en = MediaQuery.of(context).size.width;
    return FutureBuilder<List<String>>(
        future: kategoriGetir(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              TabBar(
                controller: kontrolcu,
                indicatorColor: Colors
                    .red.shade400, //gosterici yani sekmenin altindaki renk
                labelColor: Colors.red.shade400, // buton renki
                unselectedLabelColor: Colors.grey, //secili olmayan buton renki
                isScrollable: true, //sekmeler yatay eksende genisler
                labelStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500), //sekmedeki yazi ozellikleri
                tabs: [
                  Tab(text: snapshot.data[0]),
                  Tab(text: snapshot.data[1]),
                  Tab(text: snapshot.data[2]),
                  Tab(text: snapshot.data[3]),
                  Tab(text: snapshot.data[4]),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: kontrolcu,
                  children: [
                    Kategori(kategori: snapshot.data[0]),
                    Kategori(kategori: snapshot.data[1]),
                    Kategori(kategori: snapshot.data[2]),
                    Kategori(kategori: snapshot.data[3]),
                    Kategori(kategori: snapshot.data[4]),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
