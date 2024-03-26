import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/data/sqlite/veritabani_yardimcisi.dart';

class KisilerDaoRepository{
  Future<void> kaydet(String kisi_ad,String kisi_tel) async{
   var db= await VeritabaniYardimcisi.veritabaniErisim();
   var yeniKisi= Map<String,dynamic>();

   yeniKisi["kisi_adi"]= kisi_ad;
   yeniKisi["kisi_tel"]=kisi_tel;
   await db.insert("kisiler", yeniKisi);

  }

  Future<void> guncelle(int kisi_id,String kisi_ad,String kisi_tel) async{

    var db= await VeritabaniYardimcisi.veritabaniErisim();
    var guncellenenKisi= Map<String,dynamic>();

    guncellenenKisi["kisi_adi"]= kisi_ad;
    guncellenenKisi["kisi_tel"]=kisi_tel;
    await db.update("kisiler", guncellenenKisi,where: "kisi_id = ?",whereArgs: [kisi_id]);
  }

  Future<void> sil(int kisi_id) async{
    var db= await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete("kisiler",where: "kisi_id = ?",whereArgs: [kisi_id]);
  }

  Future<List<Kisiler>> kisilerYukle() async{
   var db = await VeritabaniYardimcisi.veritabaniErisim();
   List<Map<String,dynamic>> maps= await db.rawQuery("SELECT * FROM kisiler");

   return List.generate(maps.length, (i) {
     var satir = maps[i];
     return Kisiler(kisi_id: satir["kisi_id"], kisi_adi: satir["kisi_adi"], kisi_tel: satir["kisi_tel"]);
   });
  }

  Future<List<Kisiler>> ara(String aranacakKelime) async{
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String,dynamic>> maps= await db.rawQuery("SELECT * FROM kisiler WHERE kisi_adi like '%$aranacakKelime%'");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kisiler(kisi_id: satir["kisi_id"], kisi_adi: satir["kisi_adi"], kisi_tel: satir["kisi_tel"]);
    });
  }



}