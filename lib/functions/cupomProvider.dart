import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lionsbarberv1/classes/cupomClass.dart';

class CupomProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;

  Future<void> postNewCoupum({required cupomClass cupomClassInfs}) async {
    final post = await database.collection("cupons").doc(cupomClassInfs.codigo).set(
      {
        "name": cupomClassInfs.name,
        "id": cupomClassInfs.id,
        "horario": cupomClassInfs.horario,
        "isActive": cupomClassInfs.isActive,
        "codigo": cupomClassInfs.codigo,
      },
    );
  }
}
