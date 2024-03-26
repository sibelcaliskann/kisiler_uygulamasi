import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:kisiler_uygulamasi/ui/views/detay_sayfa.dart';
import 'package:kisiler_uygulamasi/ui/views/kayit_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu=false;

  @override
  void initState() {
    // TODO: implement initState
    //sayfa ilk yuklendiginde yapilacak olan islem
    super.initState();
    context.read<AnasayfaCubit>().kisilerYukle();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu ?
            TextField(
              decoration: const InputDecoration(hintText: "Ara"),
              onChanged: (aramaSonucu){
                context.read<AnasayfaCubit>().ara(aramaSonucu);
            },
            ):const Text("Kisiler"),
        actions: [
          aramaYapiliyorMu ?
          IconButton(onPressed: (){
            setState(() {
              aramaYapiliyorMu=false;
            });
            context.read<AnasayfaCubit>().kisilerYukle();
          }, icon: const Icon(Icons.clear)) :
          IconButton(onPressed: (){
            setState(() {
              aramaYapiliyorMu=true;
            });
          }, icon: const Icon(Icons.search))
        ],
      ),
      body: BlocBuilder<AnasayfaCubit,List<Kisiler>>(

        builder: (context,kisilerListesi){
          if(kisilerListesi.isNotEmpty)
            {
             return ListView.builder(
               itemCount: kisilerListesi.length,//4
               itemBuilder: (context,indeks){ //0,1,2,3
                 var kisi=kisilerListesi[indeks];
                 return GestureDetector( //tiklandiginda ne islemi yapilacak widget ile otomatik ekliyorsun ontap da ustune geldiginde ne olacagini belirliyor
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> DetaySayfa(kisi: kisi)))
                     .then((value){
                       context.read<AnasayfaCubit>().kisilerYukle(); //geri dondugunde calisacak kisileri geri yukleyecek
                     });
                     print("${kisi.kisi_adi} secildi");
                   },
                   child: Card(
                     child: SizedBox(height: 100,
                       child: Row(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(20.0),
                             child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(kisi.kisi_adi,style: TextStyle(fontSize: 20),),
                                 Text(kisi.kisi_tel),
                               ],
                             ),
                           ),
                           const Spacer(), //tum boslugu al yayarak yap
                           IconButton(onPressed: (){
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text("${kisi.kisi_adi} silinsin mi?"),
                                 action: SnackBarAction(
                                   label: "Evet",
                                   onPressed: (){
                                     context.read<AnasayfaCubit>().sil(kisi.kisi_id);
                                   },
                                 ),
                               )
                             );

                           }, icon: const Icon(Icons.clear,color: Colors.black,),)
                         ],
                       ),
                     ),
                   ),
                 );

               },
             );
            }
          else
          {
           return const Center();
          }
      },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Navigator.push(context, MaterialPageRoute(builder: (context)=>const KayitSayfa()))
              .then((value) {
            context.read<AnasayfaCubit>().kisilerYukle();
          });
        },

      ),
    );
  }
}
