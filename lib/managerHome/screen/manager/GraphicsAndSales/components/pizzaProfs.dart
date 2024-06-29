import 'package:flutter/material.dart';

class PizzaProfsHot extends StatelessWidget {
  const PizzaProfsHot({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
        color: Colors.purple,
      ),
    );
  }
}
