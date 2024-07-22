import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyProfileScreenFunctions with ChangeNotifier {
  final authSettings = FirebaseAuth.instance;
  final storageSettings = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;

  //alterando imagem do perfil - inicio
  Future<void> setImageProfile({required File urlImage}) async {
    String userIdCreate = authSettings.currentUser!.uid;

    //INICIO => Enviando a foto
    Reference ref =
        storageSettings.ref().child("userProfilePhotos/${userIdCreate}");
    UploadTask uploadTask = ref.putFile(urlImage);
    await uploadTask.whenComplete(() => null);
    String imageProfileImage = await ref.getDownloadURL();

    db.collection("usuarios").doc(userIdCreate).update({
      "urlImagem": imageProfileImage,
    });
  }
  //alterando imagem do perfil - fim

  //INICIO GET DO NOME
  Future<String?> getUserName() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userName;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userName = data['userName'];
        } else {}
        return userName;
      });
      return userName;
    }

    return null;
  }

  //FIM GET DO NOME
  //get do phone

  //get do phone
  Future<String?> getPhone() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? PhoneNumber;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          PhoneNumber = data['PhoneNumber'];
        } else {}
        return PhoneNumber;
      });
      return PhoneNumber;
    }

    return null;
  }

  //get da imagem do perfil
  Future<bool?> getUserIsManager() async {
    if (authSettings.currentUser == null) {
      return null; // Retorna imediatamente se o usuário não estiver autenticado
    }

    final String uidUser = authSettings.currentUser!.uid;
    bool? isManager;

    await db.collection("usuarios").doc(uidUser).get().then((event) {
      if (event.exists) {
        Map<String, dynamic>? data = event.data(); // Use Map<String, dynamic>?

        if (data != null && data.containsKey('isManager')) {
          isManager = data['isManager'];
        }
      }
    });

    return isManager; // Retorna o valor de isManager, que pode ser null
  }

  //GET SE É FUNCIONARIO - INICIO
  Future<bool?> getUserIsFuncionario() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      bool? ismManager;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          ismManager = data['isfuncionario'];
        } else {}
        return ismManager;
      });
      return ismManager;
    }

    return null;
  }

  //GET SE É FUNCIONARIO - FIM
  //attnome
  Future<void> newName({required String newName}) async {
    db.collection("usuarios").doc(authSettings.currentUser!.uid).update({
      "userName": newName,
    });
  }

  Future<void> setPhone({required String phoneNumber}) async {
    db.collection("usuarios").doc(authSettings.currentUser!.uid).update({
      "PhoneNumber": phoneNumber,
    });
  }

  //Pegando o bool do isManager - INICIO
  Future<String?> getUserImage() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? urlImagem;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          urlImagem = data['urlImagem'];
        } else {}
        return urlImagem;
      });
      return urlImagem;
    }

    return null;
  }

  //INICIO GET Da pontuacao
  Future<int?> getUserPontuation() async {
    print("carregando a pontuacao");
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      int? pontos;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          pontos = data['easepoints'];
        } else {}
        print("o valor deste user pego é${pontos}");
        return pontos;
      });
      return pontos;
    }

    return null;
  }

  //INICIO GET Da pontuacao
}
