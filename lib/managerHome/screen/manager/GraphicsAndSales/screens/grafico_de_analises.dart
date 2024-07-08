import 'package:flutter/material.dart';

class Grafico_de_analises extends StatelessWidget {
  const Grafico_de_analises({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Text(
            "Gráfico de Análises",
          ),
        ),
      ),
    );
  }
}
