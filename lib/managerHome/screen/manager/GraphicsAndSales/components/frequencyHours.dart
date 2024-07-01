import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/GraphicsAndSales/components/component_graphicMensal.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/GraphicsAndSales/components/horas_widget.dart';

class FrequencHours extends StatefulWidget {
  const FrequencHours({super.key});

  @override
  State<FrequencHours> createState() => _FrequencHoursState();
}

class _FrequencHoursState extends State<FrequencHours> {
  List<Map<String, Object>> get groupedTransactions {
    initializeDateFormatting('pt_BR');

    return List.generate(4, (index) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Preferências de Horários",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Text(
                "Visualize os horários mais escolhidos pelos usuários",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade100.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
            ),
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height * 0.45,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 22,
                        color: Colors.orange.shade600,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Mais Escolhidos",
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: groupedTransactions.map((data) {
                        return HorasWidget(
                          faturamento: 100,
                          mes: data["month"] as String,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
