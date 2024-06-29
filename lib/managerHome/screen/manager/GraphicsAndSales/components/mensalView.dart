import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/GraphicsAndSales/components/component_graphicMensal.dart';

class MensalViewFirstGraphic extends StatefulWidget {
  const MensalViewFirstGraphic({super.key});

  @override
  State<MensalViewFirstGraphic> createState() => _MensalViewFirstGraphicState();
}

class _MensalViewFirstGraphicState extends State<MensalViewFirstGraphic> {
  List<Map<String, Object>> get groupedTransactions {
    initializeDateFormatting('pt_BR');

    return List.generate(6, (index) {
      final now = DateTime.now();
      final month =
          DateTime(now.year, now.month - index, 1); // Primeiro dia do mês

      String monthName = DateFormat('MMMM', 'pt_BR').format(month);

      return {
        'month': monthName, // Nome do mês
      };
    }).reversed.toList();
  }

  int anoAtual = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Estatisticas Mensais",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${groupedTransactions.last['month']}".substring(0, 3),
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      Text(
                        " ${anoAtual}",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: groupedTransactions.map((data) {
                        return ContainerMesFaturamento(
                          mes: data["month"] as String,
                          Faturamento: 10,
                        );
                      }).toList(),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
