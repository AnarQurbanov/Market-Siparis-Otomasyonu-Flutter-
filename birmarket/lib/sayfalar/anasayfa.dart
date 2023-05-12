import 'package:fireworks/servisler/yetkilendirmeservisi.dart';
import 'package:flutter/material.dart';
import '../sepetim.dart';
import '../modeller/urun.dart';
import '../urunler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnaSayfa extends StatefulWidget {
  final String kullaniciID;
  final String mail;
  final String kullaniciAdi;

  const AnaSayfa({Key key, this.mail, this.kullaniciAdi, this.kullaniciID}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {

  int _aktifIcerik = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _icerikler = [Urunler(), Sepetim(kullaniciID: widget.kullaniciID,)];
    double uzunluk = MediaQuery.of(context).size.height;
    double en = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red), //AppBar icindeki iconlarin ozellikleri
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "1Market",
          style: TextStyle(
            fontSize: uzunluk / 30,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        centerTitle: true,
      ),
      body: _icerikler[_aktifIcerik],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Ürünler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Sepetim",
          ),
        ],
        onTap: (int tiklanaButon) {
          _aktifIcerik = tiklanaButon;
          setState(() {});
        },
        currentIndex: _aktifIcerik, //secilen icerik hangisi ise onu renkle
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("${widget.kullaniciAdi}"),
              accountEmail: Text("${widget.mail}"),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
              ),
            ),
            ListTile(
              title: Text(
                "Siparişlerim",
              ),
              onTap: (){},
            ),
            ListTile(
              title: Text(
                "İndirimlerim",
              ),
              onTap: (){},
            ),
            ListTile(
              title: Text(
                "Ayarlar",
              ),
              onTap: (){},
            ),
            ListTile(
              title: Text(
                "Çıkış Yap",
              ),
              onTap: (){
                YetkilendirmeServisi().cikisYap();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

