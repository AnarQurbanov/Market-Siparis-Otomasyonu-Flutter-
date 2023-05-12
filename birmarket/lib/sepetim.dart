import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modeller/urun.dart';

class Sepetim extends StatefulWidget {
  final String kullaniciID;

  const Sepetim({Key key, this.kullaniciID}) : super(key: key);

  @override
  State<Sepetim> createState() => _SepetimState();
}

class _SepetimState extends State<Sepetim> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double uzunluk = MediaQuery.of(context).size.height;
    double en = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        //SizedBox(height: uzunluk/50,),
        Center(
          child: Text(
            "Sepetim",
            style: TextStyle(
              fontSize: uzunluk / 35,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
        Container(
          height: uzunluk/4,
          child: ListView.builder(
            itemCount: Provider.of<List<Urun>>(context, listen: false).length,
            itemBuilder: (context, index) {
              return sepetUrun(
                Provider.of<List<Urun>>(context, listen: false)[index].isim,
                Provider.of<List<Urun>>(context, listen: false)[index].fiyat,
              );
            },
          ),
        ),
        SizedBox(
          height: uzunluk / 30,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                Text(
                  "Toplam Tutar",
                  style: TextStyle(
                    fontSize: uzunluk / 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  toplamTutar(),
                  style: TextStyle(
                    fontSize: uzunluk / 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: uzunluk / 30,
        ),
        alisverisTamamlaButonu(uzunluk, context),
      ],
    );
  }

  Padding alisverisTamamlaButonu(double uzunluk, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          List<int> urunListe = [];
          double tutar = 0;
          print("Siparis tamamlandi");
          if (Provider.of<List<Urun>>(context, listen: false).length>0){
            List<Urun> liste = Provider.of<List<Urun>>(context, listen: false);
            for (int i=0 ; i<Provider.of<List<Urun>>(context, listen: false).length; i++){
              urunListe.add(liste[i].id);
              tutar += liste[i].fiyat;
              int urunSayi = 0;
              for (int j=0;j<liste.length;j++){
                if (liste[i].id == liste[j].id){
                  urunSayi+=1;
                }
              }
              Firestore.instance.collection("Urunler").document(liste[i].id.toString()).updateData({
              "aciklama" : liste[i].aciklama,
              "fiyat" : liste[i].fiyat,
              "stok" : liste[i].stok-urunSayi,
              "isim" : liste[i].isim,
              "kategoriID" : liste[i].kategoriID,
              "resimLink" : liste[i].resimLink,
            },);
            }
            Firestore.instance.collection("Siparisler").add({
              "urunListe" : urunListe,
              "kullaniciID" : widget.kullaniciID,
              "tutar" : tutar,
            });
            Provider.of<List<Urun>>(context, listen: false).clear();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Sipariş onaylandı"),duration: Duration(seconds: 2)));
            setState(() {
              
            });
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              "Sepet boş",
              style: TextStyle(color: Colors.red),
            ),duration: Duration(seconds: 2)));
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: uzunluk / 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          child: Text(
            "Alisverisi Tamamla",
            style: TextStyle(
              fontSize: uzunluk / 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String toplamTutar() {
    double tutar = 0;
    for (int i = 0;
        i < Provider.of<List<Urun>>(context, listen: false).length;
        i++) {
      tutar += Provider.of<List<Urun>>(context, listen: false)[i].fiyat;
    }
    return "${tutar.toStringAsFixed(2)} TL";
  }

  Widget sepetUrun(String urunAdi, double fiyat) {
    return ListTile(
      //leading: Icon(Icons.delete,),
      title: Text(urunAdi),
      trailing: Text("${fiyat} tl"),
      iconColor: Colors.red,
      onLongPress: () {},
    );
  }
}
