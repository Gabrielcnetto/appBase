import 'package:flutter/material.dart';

class MediaHorariosPreenchidos extends StatelessWidget {
  const MediaHorariosPreenchidos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Text(
            "Horários preenchidos",
          ),
        ),
      ),
    );
  }
}
