import 'package:flutter/material.dart';

import 'modeller/kullanici.dart';
import 'sayfalar/anasayfa.dart';
import 'sayfalar/girissayfasi.dart';
import 'servisler/yetkilendirmeservisi.dart';

class Yonlendirme extends StatelessWidget {
  const Yonlendirme({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return StreamBuilder<Kullanici>(
      stream: YetkilendirmeServisi().durumTakipcisi,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(body: Center(child: CircularProgressIndicator()),);
        }

        if (snapshot.hasData){
          Kullanici aktifKullanici = snapshot.data;
          return AnaSayfa(
            mail: aktifKullanici.mail,
            kullaniciAdi: aktifKullanici.kullaniciAdi,
            kullaniciID: aktifKullanici.id,
          );
        }
        else{
          return GirisSayfasi();
        }
      },
    );
  }
}