import 'package:barbershop2/classes/GeralUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class RankingProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseAuth.instance;
  final storageSettings = FirebaseStorage.instance;

  List<GeralUser> _listaUsers = [];
  List<GeralUser> get listaUsers => [..._listaUsers];

  Future<void> loadingListUsers() async {
    try {
      QuerySnapshot querySnapshot = await database.collection("usuarios").get();
      _listaUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
     
        return GeralUser(
          isfuncionario: data?["isfuncionario"],
          isManager: data?["isManager"],
          listacortes: data?["totalCortes"],
          name: data?["userName"],
          urlImage: data?["urlImagem"],
        );
        
      }).toList();
      // Ordenar a lista em ordem decrescente com base no totalCortes
    _listaUsers.sort((a, b) => (b.listacortes ?? 0).compareTo(a.listacortes ?? 0));
    } catch (e) {
      print("houve um erro ao carregar a lista do ranking: ${e}");
    }
    notifyListeners();
  }
}
