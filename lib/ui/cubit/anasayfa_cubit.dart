import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/data/repo/kisilerdao_repository.dart';

class AnasayfaCubit extends Cubit<List<Kisiler>>{ //<> icindeki veriyi arayuze ileten emit
  AnasayfaCubit():super(<Kisiler>[]);

  var krepo=KisilerDaoRepository();

  Future<void> kisilerYukle() async{
   var liste=await krepo.kisilerYukle();
   emit(liste);
  }

  Future<void> ara(String aranacakKelime) async{
    var liste=await krepo.ara(aranacakKelime);
    emit(liste);

  }

  Future<void> sil(int kisi_id) async{
    await krepo.sil(kisi_id);
    await kisilerYukle(); //sildikten sonra listeyi yenileyecek

  }






}