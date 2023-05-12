import 'package:firebase_auth/firebase_auth.dart';
import '../modeller/kullanici.dart';
import 'package:firebase_auth/firebase_auth.dart';

class YetkilendirmeServisi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Kullanici _kullaniciOlustur(FirebaseUser kullanici){ //_ baska sinifta kullanilamaz
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Stream<Kullanici> get durumTakipcisi{
    return _firebaseAuth.onAuthStateChanged.map(_kullaniciOlustur);
  }
  

  Future<Kullanici> mailIleKayit(String mail,String sifre) async{
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(email: mail, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici> mailIleGiris(String mail,String sifre) async{
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(email: mail, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void> cikisYap(){
    return _firebaseAuth.signOut();
  }
  
}