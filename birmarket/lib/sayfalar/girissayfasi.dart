import 'package:fireworks/sayfalar/hesapolustur.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../servisler/yetkilendirmeservisi.dart';
import 'anasayfa.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key key}) : super(key: key);

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _formAnahtari =
      GlobalKey<FormState>(); //formun girdileri kontrol edebilmesi icin
  bool yukleniyor = false;
  String email, sifre;
  bool sifreGozukmeme = true;
  @override
  Widget build(BuildContext context) {
    double uzunluk = MediaQuery.of(context).size.height;
    double en = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          _sayfaElemanlari(uzunluk, en),
          yukleme(),
        ],
      ),
    );
  }

  Widget yukleme() {
    if (yukleniyor) {
      return Center(child: CircularProgressIndicator());
    } else
      return Center(); //bosluk
  }

  Widget _sayfaElemanlari(double uzunluk, double en) {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(
            height: uzunluk / 9,
          ),
          Center(
            child: Text(
              "1Market",
              style: TextStyle(
                fontSize: uzunluk / 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(
            height: uzunluk / 10,
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
                  if (sifreGozukmeme == true) {
                    setState(() {
                      sifreGozukmeme = false;
                    });
                  } else {
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
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => HesapOlustur())));
                  },
                  child: Text(
                    "Hesap Oluştur",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: en / 15,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.red;
                      }
                      return Colors.red.shade800;
                    }),
                  ),
                  onPressed: _girisYap,
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _girisYap() async {
    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        await YetkilendirmeServisi().mailIleGiris(email, sifre);
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code);
      }
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "ERROR_USER_NOT_FOUND") {
      hataMesaji = "Böyle bir kullanıcı bulunmuyor";
    } else if (hataKodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "ERROR_WRONG_PASSWORD") {
      hataMesaji = "Girilen şifre hatalı";
    } else if (hataKodu == "ERROR_USER_DISABLED") {
      hataMesaji = "Kullanıcı engellenmiş";
    } else {
      hataMesaji = "Tanımlanamayan bir hata oluştu";
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(hataMesaji)));
  }
}
