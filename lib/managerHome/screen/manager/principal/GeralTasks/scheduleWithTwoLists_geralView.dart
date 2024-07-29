import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/cortecClass.dart';
import 'package:lionsbarberv1/classes/horarios.dart';
import 'package:lionsbarberv1/classes/profissionais.dart';
import 'package:lionsbarberv1/functions/managerScreenFunctions.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/agenda_7dias/semItems.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/principal/GeralTasks/modalDeEdicao.dart';
import 'package:lionsbarberv1/rotas/Approutes.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ScheduleWithTwoListsVer2Profissionais extends StatefulWidget {
  const ScheduleWithTwoListsVer2Profissionais({Key? key}) : super(key: key);

  @override
  State<ScheduleWithTwoListsVer2Profissionais> createState() =>
      _ScheduleWithTwoListsVer2ProfissionaisState();
}

class _ScheduleWithTwoListsVer2ProfissionaisState
    extends State<ScheduleWithTwoListsVer2Profissionais> {
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

  Future<void> attViewScheduleprofissional1({
    required int dia,
    required String mes,
  }) async {
    print("dia selecionado: $dia e o mês é: $mes");
    await Provider.of<ManagerScreenFunctions>(context, listen: false)
        .loadAfterSetDayProfissional1(
      selectDay: dia,
      selectMonth: mes,
    );
    await Provider.of<ManagerScreenFunctions>(context, listen: false)
        .loadAfterSetDayProfissional2(
      selectDay: dia,
      selectMonth: mes,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setDaysAndMonths();
    attViewScheduleprofissional1(
      dia: lastSevenDays[0],
      mes: lastSevenMonths[0],
    );
  }

  List<CorteClass> _cortesFiltrados = [];
  List<Horarios> _listaHorarios = listaHorariosEncaixev2;
  List<Horarios> _removedHours = listaHorariosEncaixev2;
  List<Profissionais> _profList = profList;

  int selectedIndex = 0;
  void attDaysEMonths() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      
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
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() async {
                          selectedIndex = index;
                          diaSelecionadoSegundo = day;
                          mesSelecionadoSegundo = month;
                          await attViewScheduleprofissional1(
                            dia: day,
                            mes: month,
                          );
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.115,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
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
                                    : Estabelecimento.contraPrimaryColor,
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _profList.map((profissional) {
                int profIndex = _profList.indexOf(profissional);

                return Padding(
                  padding: const EdgeInsets.only(left: 50),
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
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${profissional.nomeProf}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: _listaHorarios.map((horario) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.22,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0,
                      axis: TimelineAxis.vertical,
                      indicatorStyle: IndicatorStyle(
                        color: Colors.grey.shade300,
                        height: 5,
                      ),
                      beforeLineStyle: LineStyle(
                        color: Colors.grey.shade300,
                        thickness: 2,
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          horario.horario,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //STREAM DO PROFISSIONAL 1
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: StreamBuilder<List<CorteClass>>(
                        stream: Provider.of<ManagerScreenFunctions>(
                          context,
                          listen: true,
                        ).CorteslistaManagerProfissional1,
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError ||
                              snapshot.data!.isEmpty) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.22,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Horário Disponível",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            );
                            ;
                          } else if (snapshot.hasData) {
                            final List<CorteClass>? cortes = snapshot.data;
                            final List<CorteClass> cortesFiltrados = cortes!
                                .where((corte) => corte.clientName != "extra")
                                .toList();
                            // Assuming cortesFiltrados is a List<CorteClass>

                            List<String> allHorariosExtra = [];

                            for (CorteClass corte in cortesFiltrados) {
                              allHorariosExtra.addAll(corte.horariosExtra);
                            }
                            for (String horario in allHorariosExtra) {
                              CorteClass novaCorte = CorteClass(
                                pagoComCupom: false,
                                easepoints: 0,
                                apenasBarba: false,
                                detalheDoProcedimento: "",
                                horariosExtra: [], // Aqui você pode definir conforme necessário
                                totalValue: 0, // Defina os valores apropriados
                                isActive: false,
                                DiaDoCorte: 0,
                                NomeMes: "null",
                                dateCreateAgendamento: DateTime.now(),
                                clientName: "Barba",
                                id: "",
                                numeroContato: "null",
                                profissionalSelect: "null",
                                diaCorte: DateTime.now(),
                                horarioCorte:
                                    horario, // Aqui define o horarioCorte com cada valor de allHorariosExtra
                                barba: false,
                                ramdomCode: 0,
                              );

                              cortesFiltrados.add(novaCorte);
                            }

                            allHorariosExtra =
                                allHorariosExtra.toSet().toList();
                            print(
                                "#3 tamanho da lista: ${allHorariosExtra.length}");
                            List<CorteClass> cortesParaHorario = cortesFiltrados
                                .where((corte) =>
                                    corte.horarioCorte == horario.horario)
                                .toList();

                            return cortesParaHorario.isNotEmpty
                                ? Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: cortesParaHorario.map((corte) {
                                        return corte.clientName == "Barba"
                                            ? Container(
                                                alignment: Alignment.centerLeft,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.22,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: corte.pagoComCupom ==
                                                          true
                                                      ? Colors.orange.shade600
                                                      : Colors.blue,
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    "",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          AppRoutesApp
                                                              .ModalDeEdicao,
                                                          arguments: corte);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.22,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: corte.pagoComCupom ==
                                                            true
                                                        ? Colors.orange.shade600
                                                        : Colors.blue,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "ínicio: ${corte.horarioCorte}",
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .white70,
                                                                ),
                                                              ),
                                                            ),
                                                            if (corte
                                                                .pagoComCupom)
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: Colors
                                                                      .white,
                                                                  border: Border
                                                                      .all(
                                                                    width: 0.5,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  "Grátis, Troca de cupom",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontStyle:
                                                                            FontStyle.italic),
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              corte
                                                                  .detalheDoProcedimento,
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        AppRoutesApp
                                                                            .ModalDeEdicao,
                                                                        arguments:
                                                                            corte);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15)),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .open_in_new,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                      }).toList(),
                                    ),
                                  )
                                : Expanded(
                                    // Se não houver cortes, exibe "Horário Disponível"
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.22,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Horário Disponível",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          }
                          return Container(); // Pode retornar um Container vazio ou outro widget de acordo com o seu caso.
                        },
                      ),
                    ),
                  ),
                  //STREAM DO PROFISSIONAL 2
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: StreamBuilder<List<CorteClass>>(
                        stream: Provider.of<ManagerScreenFunctions>(
                          context,
                          listen: true,
                        ).CorteslistaManagerProfissional2,
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError ||
                              snapshot.data!.isEmpty) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.22,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Horário Disponível",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            final List<CorteClass>? cortes = snapshot.data;
                            final List<CorteClass> cortesFiltrados = cortes!
                                .where((corte) => corte.clientName != "extra")
                                .toList();
                            // Assuming cortesFiltrados is a List<CorteClass>

                            List<String> allHorariosExtra = [];

                            for (CorteClass corte in cortesFiltrados) {
                              allHorariosExtra.addAll(corte.horariosExtra);
                            }
                            for (String horario in allHorariosExtra) {
                              CorteClass novaCorte = CorteClass(
                                pagoComCupom: false,
                                easepoints: 0,
                                apenasBarba: false,
                                detalheDoProcedimento: "",
                                horariosExtra: [], // Aqui você pode definir conforme necessário
                                totalValue: 0, // Defina os valores apropriados
                                isActive: false,
                                DiaDoCorte: 0,
                                NomeMes: "null",
                                dateCreateAgendamento: DateTime.now(),
                                clientName: "Barba",
                                id: "",
                                numeroContato: "null",
                                profissionalSelect: "null",
                                diaCorte: DateTime.now(),
                                horarioCorte:
                                    horario, // Aqui define o horarioCorte com cada valor de allHorariosExtra
                                barba: false,
                                ramdomCode: 0,
                              );

                              cortesFiltrados.add(novaCorte);
                            }

                            allHorariosExtra =
                                allHorariosExtra.toSet().toList();
                            print(
                                "#3 tamanho da lista: ${allHorariosExtra.length}");
                            List<CorteClass> cortesParaHorario = cortesFiltrados
                                .where((corte) =>
                                    corte.horarioCorte == horario.horario)
                                .toList();

                            return cortesParaHorario.isNotEmpty
                                ? Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: cortesParaHorario.map((corte) {
                                        return corte.clientName == "Barba"
                                            ? Container(
                                                alignment: Alignment.centerLeft,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.22,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: corte.pagoComCupom ==
                                                          true
                                                      ? Colors.orange.shade600
                                                      : Colors.blue,
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    "",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          AppRoutesApp
                                                              .ModalDeEdicao,
                                                          arguments: corte);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.22,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: corte.pagoComCupom ==
                                                            true
                                                        ? Colors.orange.shade600
                                                        : Colors.blue,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "ínicio: ${corte.horarioCorte}",
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .white70,
                                                                ),
                                                              ),
                                                            ),
                                                            if (corte
                                                                .pagoComCupom)
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: Colors
                                                                      .white,
                                                                  border: Border
                                                                      .all(
                                                                    width: 0.5,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  "Grátis, Troca de cupom",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontStyle:
                                                                            FontStyle.italic),
                                                                  ),
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
                                                              corte
                                                                  .detalheDoProcedimento,
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        AppRoutesApp
                                                                            .ModalDeEdicao,
                                                                        arguments:
                                                                            corte);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15)),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .open_in_new,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                      }).toList(),
                                    ),
                                  )
                                : Expanded(
                                    // Se não houver cortes, exibe "Horário Disponível"
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.22,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Horário Disponível",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          }
                          return Container(); // Pode retornar um Container vazio ou outro widget de acordo com o seu caso.
                        },
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
