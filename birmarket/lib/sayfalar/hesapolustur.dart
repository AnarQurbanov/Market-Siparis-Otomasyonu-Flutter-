import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../modeller/kullanici.dart';
import '../servisler/yetkilendirmeservisi.dart';
import 'anasayfa.dart';

class HesapOlustur extends StatefulWidget {
  const HesapOlustur({Key key}) : super(key: key);

  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  final _formAnahtari = GlobalKey<FormState>();
  bool sifreGozukmeme = true;
  bool yukleniyor = false;
  String kullaniciAdi, email, sifre, telefonNo, adres;
  @override
  Widget build(BuildContext context) {
    double uzunluk = MediaQuery.of(context).size.height;
    double en = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Hesap Oluştur"),
        ),
        body: ListView(
          padding: EdgeInsets.only(right: 20, left: 20),
          children: [
            yukleniyor
                ? LinearProgressIndicator()
                : SizedBox(
                    height: 0,
                  ),
            SizedBox(
              height: uzunluk / 17,
            ),
            Form(
              key: _formAnahtari,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Kullanıcı adınızı girin",
                      labelText: "Kullanıcı Adı",
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.isEmpty) {
                        return "Kullanıcı adı boş bırakılamaz";
                      } else if (girilenDeger.trim().length < 6 ||
                          girilenDeger.trim().length > 20) {
                        return "En az 6, en fazla 20 karakter olmalı";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => kullaniciAdi = girilenDeger,
                  ),
                  SizedBox(
                    height: uzunluk / 17,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress, //klavye turu
                    decoration: InputDecoration(
                      labelText: "Mail",
                      hintText: "Mail adresinizi girin",
                      prefixIcon: Icon(Icons.mail),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.isEmpty) {
                        return "Email alanı boş bırakılamaz";
                      } else if (!girilenDeger.contains("@")) {
                        return "Girilen değer mail formatında olmalı";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => email = girilenDeger,
                  ),
                  SizedBox(
                    height: uzunluk / 17,
                  ),
                  TextFormField(
                    obscureText: sifreGozukmeme,
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      hintText: "Şifrenizi girin",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        child: Icon(Icons.remove_red_eye),
                        onTap: () {
                          if (sifreGozukmeme == true){
                            setState(() {
                              sifreGozukmeme = false;
                            });
                          }
                          else{
                            setState(() {
                              sifreGozukmeme = true;
                            });
                          }
                          setState(() {
                            print(sifreGozukmeme);
                          });
                        },
                      ),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.isEmpty) {
                        return "Şifre alanı boş bırakılamaz!";
                      } else if (girilenDeger.trim().length < 4) {
                        //trim bosluk degerlerini kirpiyor
                        return "Şifre 4 karakterden az olamaz!";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => sifre = girilenDeger,
                  ),
                  SizedBox(
                    height: uzunluk / 17,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Telefon Numarınızı girin",
                      labelText: "Telefon Numarası",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.isEmpty) {
                        return "Telefon Numarası boş bırakılamaz";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => telefonNo = girilenDeger,
                  ),
                  SizedBox(
                    height: uzunluk / 17,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Adresinizi girin",
                      labelText: "Adres",
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.isEmpty) {
                        return "Adres boş bırakılamaz";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => adres = girilenDeger,
                  ),
                  SizedBox(
                    height: uzunluk / 17,
                  ),
                  ElevatedButton(
                    onPressed: _kullaniciOlustur,
                    child: Text(
                      "Hesap Oluştur",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void _kullaniciOlustur() async{
    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();
      setState(() {
        yukleniyor = true;
      });

      try{
        Kullanici kullanici = await YetkilendirmeServisi().mailIleKayit(email, sifre);
        Firestore.instance.collection("Kullanici").document(kullanici.id).setData({
          "kullaniciAdi" : kullaniciAdi,
          "mail" : email,
          "sifre" : sifre,
          "adres" : adres,
          "telefonNo" : telefonNo,
        });
        print("${kullaniciAdi} veritabanina eklendi");
        Navigator.pop(context);
      }catch(hata){
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code);
      }    
    }
  }
  uyariGoster({hataKodu}){
    String hataMesaji;

    if(hataKodu == "ERROR_INVALID_EMAIL"){
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "ERROR_EMAIL_ALREADY_IN_USE") {
      hataMesaji = "Girdiğiniz mail kayıtlıdır";
    } else if (hataKodu == "ERROR_WEAK_PASSWORD") {
      hataMesaji = "Daha zor bir şifre tercih edin";
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hataMesaji)));
  }
}
