import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/profissionais.dart';

class FaturamentoMesSelecionado extends StatefulWidget {
  const FaturamentoMesSelecionado({super.key});

  @override
  State<FaturamentoMesSelecionado> createState() =>
      _FaturamentoMesSelecionadoState();
}

class _FaturamentoMesSelecionadoState extends State<FaturamentoMesSelecionado> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.calendar_month,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Faturamento",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Estabelecimento.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Mês atual",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Estabelecimento.contraPrimaryColor,
                            fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Estabelecimento.contraPrimaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.22,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      "R\$40,200",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 45,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        "40% da meta batida",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Estabelecimento.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: 30,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              child: LinearProgressIndicator(
                                value: 1,
                                color: Colors.grey.shade500,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              child: LinearProgressIndicator(
                                value: 0.4,
                                color: Colors.green,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.32,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // primeiro container - inicio
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Último mês",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              "Faturamento vs Último mês",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          ],
                        ),
                        //informacoes do crescimento - inicio
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "R\$25.300", // AQUI FATURAMENTO MES ANTERIOR
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    Icons.arrow_drop_up,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  "+4%",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        //informacoes do crescimento - fim
                        //
                      ],
                    ),
                  ),
                  // primeiro container - fim
                  // segundo container - inicio
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${profList[0].nomeProf}",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              "Clientes (comparativo)",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          ],
                        ),
                        //informacoes do crescimento - inicio
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "80 Clientes", // AQUI FATURAMENTO MES ANTERIOR
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    Icons.arrow_drop_up,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  "+2%",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        //informacoes do crescimento - fim

                        //
                      ],
                    ),
                  ),
                  // segundo container - fim
                  //terceiro container - inicio
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${profList[1].nomeProf}",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              "Clientes (comparativo)",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          ],
                        ),
                        //informacoes do crescimento - inicio
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "20 Clientes", // AQUI FATURAMENTO MES ANTERIOR
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    Icons.arrow_drop_up,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  "+5%",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        //informacoes do crescimento - fim

                        //
                      ],
                    ),
                  ),
                  //terceiro container - fim
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
