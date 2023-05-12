import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'modeller/urun.dart';

class UrunDetay extends StatefulWidget {
  final int id;
  final String isim;
  final double fiyat;
  final String resimYolu;
  final int stok;
  final String aciklama;
  final int kategoriID;

  const UrunDetay(
      {Key key,
      this.id,
      this.isim,
      this.fiyat,
      this.resimYolu,
      this.stok,
      this.aciklama, this.kategoriID,})
      : super(key: key);

  @override
  State<UrunDetay> createState() => _UrunDetayState();
}

class _UrunDetayState extends State<UrunDetay> {
  @override
  Widget build(BuildContext context) {
    //int urunStok = widget.stok; //azalma yaparken widget.stok final oldugu icin bunu tanimladim
    double uzunluk = MediaQuery.of(context).size.height;
    double en = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Hero(
                tag: widget.resimYolu,
                child: Image.network(
                  widget.resimYolu,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                widget.isim,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${widget.fiyat} TL",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade400,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  widget.aciklama,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              sepeteEkleButonu(en, uzunluk),
            ],
          ),
        ],
      ),
    );
  }

  Widget sepeteEkleButonu(double en, double uzunluk) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: widget.stok > 0 ? Colors.red.shade400 : Colors.black,
      child: InkWell(
        onTap: () {
          print("Butona tiklandi");
          if (widget.stok == 0)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              "Bu ürün stokta yok",
              style: TextStyle(color: Colors.red),
            ),duration: Duration(seconds: 1)));
          else {
            Provider.of<List<Urun>>(context,listen: false).add(
              Urun(
                id: widget.id,
                isim: widget.isim,
                fiyat: widget.fiyat,
                stok: widget.stok,
                aciklama: widget.aciklama,
                kategoriID: widget.kategoriID,
                resimLink: widget.resimYolu,
              ),
            );
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Ürün sepete eklendi"),duration: Duration(seconds: 1)));

            print("Urun listesi boyutu ${Provider.of<List<Urun>>(context,listen: false).length}");
            setState(() {
              
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: en - 50,
          height: uzunluk / 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            //color: widget.stok > 0 ? Colors.red.shade400 : Colors.black,
          ),
          child: Text(
            widget.stok > 0 ? "Sepete Ekle" : "Stokta Yok",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
