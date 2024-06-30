import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HorasWidget extends StatefulWidget {
  final String mes;
  final int faturamento;

  const HorasWidget({
    Key? key,
    required this.mes,
    required this.faturamento,
  }) : super(key: key);

  @override
  State<HorasWidget> createState() => _HorasWidgetState();
}

class _HorasWidgetState extends State<HorasWidget> {
  @override
  Widget build(BuildContext context) {
    const double valorMaximo = 100.0;

    // Calcula o fator de largura com base no faturamento atual
    double widthFactor = widget.faturamento / valorMaximo;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${widget.faturamento}",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      widthFactor, // Exemplo de fator de largura dinâmico
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(17),
                        bottomRight: Radius.circular(17),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
