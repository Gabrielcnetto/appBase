import 'package:flutter/material.dart';
import 'package:lionsbarberv1/rotas/Approutes.dart';

class ConfirmCreateCupomImage extends StatelessWidget {
  const ConfirmCreateCupomImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutesApp.HomeScreen01,
                );
              },
              child: Text(
                "cupom criado, voltar",
              ),
            ),
          )
        ],
      ),
    );
  }
}
