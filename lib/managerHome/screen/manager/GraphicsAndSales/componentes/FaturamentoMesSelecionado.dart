import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/profissionais.dart';
import 'package:lionsbarberv1/functions/managerScreenFunctions.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/GraphicsAndSales/GraphicsScreenManager.dart';
import 'package:provider/provider.dart';

class FaturamentoMesSelecionado extends StatefulWidget {
  final String mesInicial;
  const FaturamentoMesSelecionado({
    super.key,
    required this.mesInicial,
  });

  @override
  State<FaturamentoMesSelecionado> createState() =>
      _FaturamentoMesSelecionadoState();
}

class _FaturamentoMesSelecionadoState extends State<FaturamentoMesSelecionado> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ManagerScreenFunctions>(context, listen: false)
        .gerarUltimos4Meses();
    setlist();
    loadTotalFaturamentoAtualMes();
    selecionarMes();
  }

  //faturamento - load mes escolhido - inicio

  //- # mes escolhido =>
  int? faturamentoExibido;
  Future<void> loadTotalFaturamentoAtualMes() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalFaturamentoGet = await ManagerScreenFunctions()
        .loadFaturamentoBarbeariaSelectMenu(
            mesSelecionado: widget.mesInicial == "Clique"
                ? monthName.toLowerCase()
                : widget.mesInicial.toLowerCase());

    setState(() {
      faturamentoExibido = totalFaturamentoGet;
      selecionarMes();
    });
  }
  //- # mes escolhido =<

  //- # mes anterior do escolhido para comparativo =>
  String? mesAnteriorAoSelecionado;
  int? faturamentoAnteriorAoEscolhido;
  Future<void> loadFaturamentoMesAnterior() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalFaturamentoGet = await ManagerScreenFunctions()
        .loadFaturamentoBarbeariaSelectMenuMesAnterior(
            mesSelecionado: mesAnteriorAoSelecionado ?? "");

    setState(() {
      faturamentoAnteriorAoEscolhido = totalFaturamentoGet;
    });
  }
  //- # mes anterior do escolhido para comparativo =<
  //faturamento - load mes escolhido - fim

  //load dos ultimos 4 meses - inici

  List<String> ultimos4Meses = [];
  void setlist() {
    setState(() {
      ultimos4Meses =
          Provider.of<ManagerScreenFunctions>(context, listen: false)
              .ultimos4Meses;
    });
  }

  void selecionarMes() async {
    // Obter o índice do mês selecionado
    int indiceSelecionado = 0;
    if (widget.mesInicial == "Clique") {
      indiceSelecionado = await ultimos4Meses.indexOf(
        Provider.of<ManagerScreenFunctions>(context, listen: false)
            .ultimos4Meses[0],
      );
    } else {
      indiceSelecionado = await ultimos4Meses.indexOf(
        widget.mesInicial,
      );
    }
    print("#14o indice é ${indiceSelecionado}");
    // Calcular o índice do mês anterior
    int indiceAnterior = (indiceSelecionado + 1);
    print("#14o anterior é ${indiceAnterior}");
    // Definir o mês anterior
    setState(() {
      mesAnteriorAoSelecionado = ultimos4Meses[indiceAnterior];
    });
    print("#14o mes final foi:${mesAnteriorAoSelecionado}");
  }

  //load dos ultimos 4 meses - fim
  bool showMoreMonths = false;

  @override
  Widget build(BuildContext context) {
    String mesSelecionado =
        widget.mesInicial == "Clique" ? ultimos4Meses[0] : widget.mesInicial;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      height: showMoreMonths == false
          ? MediaQuery.of(context).size.height * 0.7
          : MediaQuery.of(context).size.height * 0.8,
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
                  //   crossAxisAlignment: showMoreMonths == true ? CrossAxisAlignment.start : CrossAxisAlignment.c,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        if (showMoreMonths == false)
                          Text(
                            mesSelecionado,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Estabelecimento.contraPrimaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        if (showMoreMonths == true)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ultimos4Meses.map((mes) {
                              return InkWell(
                                onTap: () {
                                  print("selecionei: ${mes}");
                                  setState(() {
                                    mesSelecionado = mes;
                                    loadTotalFaturamentoAtualMes();
                                    Navigator.of(context).push(
                                      DialogRoute(
                                        context: context,
                                        builder: (ctx) {
                                          return GraphicsManagerScreen(
                                            mesSelecionado: mes,
                                          );
                                        },
                                      ),
                                    );
                                  });
                                },
                                child: Text(
                                  mes,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Estabelecimento.contraPrimaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          showMoreMonths = !showMoreMonths;
                        });
                      },
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Estabelecimento.contraPrimaryColor,
                      ),
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
                      "R\$${faturamentoExibido ?? 0}",
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
