import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/classes/profissionais.dart';

class PizzaProfsHot extends StatefulWidget {
  const PizzaProfsHot({Key? key}) : super(key: key);

  @override
  State<PizzaProfsHot> createState() => _PizzaProfsHotState();
}

class _PizzaProfsHotState extends State<PizzaProfsHot> {
  List<PieChartSectionData> getSections() {
    return [
      PieChartSectionData(
        title: "40%",
        value: 40,
        color: Colors.orange.shade400,
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        title: "60%",
        value: 60,
        color: Colors.blue.shade600,
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      //color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Barbeiro Mais Procurado",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.2,
                child: PieChart(
                  PieChartData(
                    sections: getSections(),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    startDegreeOffset: 270,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: Colors.blue.shade600,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text(
                              "${profList[0].nomeProf}",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //Barbeiro 2
                      Row(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: Colors.orange.shade400,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text(
                              "${profList[1].nomeProf}",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
