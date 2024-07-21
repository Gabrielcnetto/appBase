import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lionsbarberv1/classes/cupomClass.dart';

class CupomProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;

  //criacao do cupom - inicio
  Future<void> postNewCoupum({required cupomClass cupomClassInfs}) async {
    String cupomCodigo = "#${cupomClassInfs.codigo}";
    try {
      final post =
          await database.collection("cupons").doc(cupomClassInfs.codigo).set(
        {
          "name": cupomClassInfs.name,
          "id": cupomClassInfs.id,
          "horario": cupomClassInfs.horario,
          "isActive": cupomClassInfs.isActive,
          "codigo": cupomCodigo,
          "multiplicador": cupomClassInfs.multiplicador,
        },
      );
      notifyListeners();
    } catch (e) {
      print("#erro ao criar cupom no provider : $e");
      throw e;
    }
  }

  //criacao do cupom - fim
  StreamController<List<cupomClass>> _cupomStream =
      StreamController<List<cupomClass>>.broadcast();

  Stream<List<cupomClass>> get cupomStream => _cupomStream.stream;
  List<cupomClass> _cupomList = [];
  List<cupomClass> get cupomList => [..._cupomList];
  Future<void> loadCupons() async {
    print("funcao de carregar os cupons");
    QuerySnapshot querySnapshot = await database.collection("cupons").get();
    _cupomList = await querySnapshot.docs.map((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      return cupomClass(
        codigo: data?['codigo'],
        name: data?['name'],
        horario: data?['horario'],
        id: data?['id'],
        isActive: data?['isActive'],
        multiplicador: data?['multiplicador'],
      );
    }).toList();

    _cupomStream.add(_cupomList);

    print("#90 o valor lengh final é ${_cupomList.length}");
    notifyListeners();
  }

  Future<void> turnOfforActiveFcuntionsCoupon({
    required cupomClass cupomItens,
  }) async {
    try {
      bool? atualValue;
      String cupomCodigoParaBuscar =
          await cupomItens.codigo.replaceAll(RegExp('#'), '');
      final cupomDoc =
          await database.collection('cupons').doc(cupomCodigoParaBuscar).get();
      if (cupomDoc.exists) {
        atualValue = cupomDoc.data()?['isActive'];
      }
      if (atualValue == true) {
        print("era true e agora vai ser false");
        final coupon = await database
            .collection('cupons')
            .doc(cupomCodigoParaBuscar)
            .update({
          "isActive": false,
        });
      } else {
        print("era false e agora vai ser true");
        final coupon = await database
            .collection('cupons')
            .doc(cupomCodigoParaBuscar)
            .update({
          "isActive": true,
        });
      }

      notifyListeners();
    } catch (e) {
      print("ao deixar off deu este erro: $e");
    }
  }

  Future<void> deleteCoupon({required cupomClass cupom}) async {
    String cupomCodigoParaBuscar =
        await cupom.codigo.replaceAll(RegExp('#'), '');
    print("nome do cupom será:${cupomCodigoParaBuscar}");
    try {
      final delete = await database
          .collection("cupons")
          .doc(cupomCodigoParaBuscar)
          .delete();
    } catch (e) {
      print("nao consegui deletar o cupon, motivo: $e");
    }
  }

  
  Future<void> searchCoupon({required String cupom}) async {
    try {
      final pesquisaDocs =await database.collection("cupons").doc(cupom).get();

      if(pesquisaDocs.exists){
        

        // atualValue = cupomDoc.data()?['isActive'];
      }
    } catch (e) {
      print("ao pesquisar o cupom deu este erro: $e");
    }
  }
}
