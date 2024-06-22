import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/cortecClass.dart';
import 'package:lionsbarberv1/classes/horarios.dart';
import 'package:lionsbarberv1/classes/profissionais.dart';
import 'package:lionsbarberv1/functions/agendaDataHorarios.dart';
import 'package:lionsbarberv1/functions/managerScreenFunctions.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/principal/agenda_7dias/semItems.dart';
import 'package:provider/provider.dart';

import '../agenda_7dias/corte7diasItem.dart';

class ScheduleWithTwoLists extends StatefulWidget {
  const ScheduleWithTwoLists({Key? key}) : super(key: key);

  @override
  State<ScheduleWithTwoLists> createState() => _ScheduleWithTwoListsState();
}

class _ScheduleWithTwoListsState extends State<ScheduleWithTwoLists> {
  List<int> lastSevenDays = [];
  List<String> lastSevenMonths = [];
  List<String> lastSevenWeekdays = [];

  void setDaysAndMonths() {
    initializeDateFormatting('pt_BR');
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      int dayOfMonth = int.parse(DateFormat('d').format(date));
      String monthName = DateFormat('MMMM', 'pt_BR').format(date);
      String weekdayName = DateFormat('EEEE', 'pt_BR').format(date);
      lastSevenDays.add(dayOfMonth);
      lastSevenMonths.add(monthName);
      lastSevenWeekdays.add(weekdayName);
    }
  }

  int? diaSelecionadoSegundo;
  String? mesSelecionadoSegundo;
  String profSelecionado = "${profList[0].nomeProf}";

  Future<void> attViewSchedule({
    required int dia,
    required String mes,
    required String proffName,
  }) async {
    print("dia selecionado: $dia e o mês é: $mes");
    Provider.of<ManagerScreenFunctions>(context, listen: false).loadAfterSetDay(
      selectDay: dia,
      selectMonth: mes,
      proffName: profSelecionado,
    );
  }

  @override
  void initState() {
    super.initState();

    Provider.of<AgendaData>(context, listen: false).atualizarLinhaPosicao(
      context: context,
      listaHorarios: listaHorariosEncaixe,
    );
    setDaysAndMonths();
    attViewSchedule(
      dia: lastSevenDays[0],
      mes: lastSevenMonths[0],
      proffName: profSelecionado,
    );
  }

  List<Horarios> _listaHorarios = listaHorariosEncaixe;
  List<Profissionais> _profList = profList;

  int selectedIndex = 0;
  int profissionalSelecionadoIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Calendário",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Agenda completa",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      lastSevenDays.length,
                      (index) {
                        int day = lastSevenDays[index];
                        String month = lastSevenMonths[index];
                        String weekday = lastSevenWeekdays[index];
                        String firstLetterOfMonth = month.substring(0, 1);
                        String tresPrimeirasLetras = weekday.substring(0, 3);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              tresPrimeirasLetras,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 5),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  diaSelecionadoSegundo = day;
                                  mesSelecionadoSegundo = month;
                                });
                                attViewSchedule(
                                  dia: day,
                                  mes: month,
                                  proffName: profSelecionado,
                                );
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                alignment: Alignment.center,
                                width:
                                    MediaQuery.of(context).size.width * 0.115,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.elliptical(90, 90),
                                    bottomRight: Radius.elliptical(90, 90),
                                    topLeft: Radius.elliptical(90, 90),
                                    topRight: Radius.elliptical(90, 90),
                                  ),
                                  color: selectedIndex == index
                                      ? Colors.blue
                                      : Estabelecimento.primaryColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$day",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: selectedIndex == index
                                            ? Colors.white
                                            : Estabelecimento
                                                .contraPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _profList.map((profissional) {
                        int profIndex = _profList.indexOf(profissional);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                profSelecionado = profissional.nomeProf;
                                profissionalSelecionadoIndex = profIndex;

                                if (mesSelecionadoSegundo != null) {
                                  attViewSchedule(
                                    dia: diaSelecionadoSegundo!,
                                    mes: mesSelecionadoSegundo!,
                                    proffName: profSelecionado,
                                  );
                                } else {
                                  attViewSchedule(
                                    dia: lastSevenDays[0],
                                    mes: lastSevenMonths[0],
                                    proffName: profSelecionado,
                                  );
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        profissional.assetImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: profissionalSelecionadoIndex ==
                                              profIndex
                                          ? Colors.blue
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${profissional.nomeProf}",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: profissionalSelecionadoIndex ==
                                                  profIndex
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: Column(
                                children: _listaHorarios.map((hr) {
                                  return Container(
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: Text(
                                      hr.horario,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.78,
                                child: StreamBuilder(
                                  stream: Provider.of<ManagerScreenFunctions>(
                                    context,
                                    listen: true,
                                  ).CorteslistaManager,
                                  builder: (ctx, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        alignment: Alignment.center,
                                        child:
                                            const CircularProgressIndicator(),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Container(
                                        child: const SemItens(),
                                      );
                                    } else {
                                      final List<CorteClass>? cortes =
                                          snapshot.data;
                                      final List<CorteClass> cortesFiltrados =
                                          cortes!
                                              .where((corte) =>
                                                  corte.clientName != "extra")
                                              .toList();

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _listaHorarios.length,
                                        itemBuilder: (context, index) {
                                          Horarios horario =
                                              _listaHorarios[index];

                                          // Encontra o corte correspondente ao horário atual
                                          CorteClass? corteEncontrado =
                                              cortesFiltrados.firstWhere(
                                            (corte) =>
                                                corte.horarioCorte ==
                                                horario.horario,
                                            orElse: () => CorteClass(
                                              DiaDoCorte: 1,
                                              NomeMes: "",
                                              barba: false,
                                              clientName: "",
                                              dateCreateAgendamento:
                                                  DateTime.now(),
                                              diaCorte: DateTime.now(),
                                              horarioCorte: "",
                                              horariosExtra: [],
                                              id: "",
                                              isActive: false,
                                              numeroContato: "",
                                              profissionalSelect: "",
                                              ramdomCode: 0,
                                              totalValue: 0,
                                            ),
                                          );

                                          // Calcula a altura base do container
                                          double containerHeight = 100.0;

                                          // Se o campo 'barba' for verdadeiro, adiciona espaço equivalente a 5 itens
                                          if (corteEncontrado.barba) {
                                            containerHeight += 4 *
                                                100.0; // Considerando que cada item tem 100 de altura
                                          }

                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child:
                                                    corteEncontrado
                                                            .clientName.isEmpty
                                                        ? Container(
                                                            height: 90,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300),
                                                              ),
                                                            ),
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Horário livre",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    corteEncontrado
                                                                        .clientName,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            height:
                                                                containerHeight,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300),
                                                              ),
                                                            ),
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          15),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${corteEncontrado.horarioCorte}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              Colors.white60,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        corteEncontrado.barba
                                                                            ? "Corte de Cabelo + Barba Inclusa"
                                                                            : "Corte normal",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              5),
                                                                      Text(
                                                                        "Cliente: ${corteEncontrado.clientName}",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Estabelecimento.primaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(30),
                                                                        ),
                                                                        padding:
                                                                            EdgeInsets.all(10),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .open_in_new,
                                                                          color:
                                                                              Estabelecimento.contraPrimaryColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              width: double
                                                                  .infinity,
                                                              height: containerHeight -
                                                                  5, // Altura do container principal
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top:
                                  Provider.of<AgendaData>(context).linhaPosicao,
                              left: MediaQuery.of(context).size.width * 0.12,
                              child: AnimatedContainer(
                                height: 3,
                                width: MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).size.width * 0.12,
                                color: Colors.redAccent,
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInOut,
                                onEnd: () {
                                  Provider.of<AgendaData>(context,
                                          listen: false)
                                      .resetLinhaPosicao();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
