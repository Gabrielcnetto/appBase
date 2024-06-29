import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';

class ContainerMesFaturamento extends StatelessWidget {
  final String mes;
  final int Faturamento;
  const ContainerMesFaturamento({
    super.key,
    required this.mes,
    required this.Faturamento,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            "${Faturamento}",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.27,
          width: 30,
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.1,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 40, 131, 210),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(10, 10),
                  topRight: Radius.elliptical(10, 10),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            mes.substring(0, 3).toUpperCase(),
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade800,
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
