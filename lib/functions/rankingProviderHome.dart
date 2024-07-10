import 'package:lionsbarberv1/classes/GeralUser.dart';
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
        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['ultimoAgendamento'] as Timestamp?;
        }
        DateTime diaFinal = timestamp?.toDate() ?? DateTime.now();

        return GeralUser(
          ultimoAgendamento: diaFinal,
          PhoneNumber: data?["PhoneNumber"] ?? 0,
          isfuncionario: data?["isfuncionario"],
          isManager: data?["isManager"],
          listacortes: data?["totalCortes"],
          name: data?["userName"],
          urlImage: data?["urlImagem"],
        );
      }).toList();
      // Ordenar a lista em ordem decrescente com base no totalCortes
      _listaUsers
          .sort((a, b) => (b.listacortes ?? 0).compareTo(a.listacortes ?? 0));
    } catch (e) {
      print("houve um erro ao carregar a lista do ranking: ${e}");
    }
    notifyListeners();
  }
  //lista 2

  List<GeralUser> _listaUsuariosManager2 = [];
  List<GeralUser> get listaUsersManagerView2 => [..._listaUsuariosManager2];

  Future<void> loadingListUsersManagerView2() async {
    try {
      QuerySnapshot querySnapshot = await database.collection("usuarios").get();
      _listaUsuariosManager2 = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['ultimoAgendamento'] as Timestamp?;
        }
        DateTime diaFinal = timestamp?.toDate() ?? DateTime.now();

        return GeralUser(
          ultimoAgendamento: diaFinal,
          PhoneNumber: data?["PhoneNumber"] ?? 0,
          isfuncionario: data?["isfuncionario"],
          isManager: data?["isManager"],
          listacortes: data?["totalCortes"],
          name: data?["userName"],
          urlImage: data?["urlImagem"],
        );
      }).toList();
      // Ordenar a lista em ordem decrescente com base no totalCortes
      _listaUsuariosManager2
          .sort((a, b) => a.ultimoAgendamento.compareTo(b.ultimoAgendamento));
    } catch (e) {
      print("houve um erro ao carregar a lista do ranking: ${e}");
    }
    notifyListeners();
  }
}
