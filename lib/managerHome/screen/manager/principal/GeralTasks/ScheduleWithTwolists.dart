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
import 'package:lionsbarberv1/managerHome/screen/manager/principal/GeralTasks/modalDeEdicao.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/principal/agenda_7dias/semItems.dart';
import 'package:lionsbarberv1/rotas/Approutes.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

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

    setDaysAndMonths();
    attViewSchedule(
      dia: lastSevenDays[0],
      mes: lastSevenMonths[0],
      proffName: profSelecionado,
    );
  }

  List<CorteClass> _cortesFiltrados = [];
  List<Horarios> _listaHorarios = listaHorariosEncaixev2;
  List<Horarios> _removedHours = listaHorariosEncaixev2;
  List<Profissionais> _profList = profList;
  void _fetchAndFilterData() async {
    final cortesStream = Provider.of<ManagerScreenFunctions>(
      context,
      listen: false,
    ).CorteslistaManager;

    cortesStream.listen((cortes) {
      if (cortes != null && cortes.isNotEmpty) {
        setState(() {
          _removeItemsOnce();
        });
      }
    });
  }

  void _removeItemsOnce() {
    for (int index = 0; index < listaHorariosEncaixev2.length; index++) {
      bool isInCortesFiltrados = _cortesFiltrados.any((corte) =>
          listaHorariosEncaixev2[index].horario == corte.horarioCorte);

      if (isInCortesFiltrados) {
        CorteClass corte = _cortesFiltrados.firstWhere((corte) =>
            listaHorariosEncaixev2[index].horario == corte.horarioCorte);

        if (corte.barba == true) {
          List<Horarios> removedItems = [];
          int removeCount = 4;
          int endIndex = index + removeCount;

          if (endIndex >= _removedHours.length) {
            endIndex = _removedHours.length - 1;
          }

          removedItems = _removedHours.sublist(index + 1, endIndex + 1);
          _removedHours.removeRange(index + 1, endIndex + 1);
          _removedHours.addAll(removedItems);
        }
      }
    }
  }

  int selectedIndex = 0;
  int profissionalSelecionadoIndex = 0;
  int encontrarIndiceHorario(String horarioCorte) {
    // Encontra o índice do horário na lista listaHorariosEncaixev2
    for (int i = 0; i < listaHorariosEncaixev2.length; i++) {
      if (listaHorariosEncaixev2[i].horario == horarioCorte) {
        return i; // Retorna o índice encontrado
      }
    }
    return -1; // Retorna -1 se não encontrar
  }

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
                  child: StreamBuilder<List<CorteClass>>(
                    stream: Provider.of<ManagerScreenFunctions>(
                      context,
                      listen: true,
                    ).CorteslistaManager,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                        return SemItens();
                      } else if (snapshot.hasData) {
                        final List<CorteClass>? cortes = snapshot.data;
                        final List<CorteClass> cortesFiltrados = cortes!
                            .where((corte) => corte.clientName != "extra")
                            .toList();

                        int totalItems = 0;
                        for (var hr in listaHorariosdaLateral) {
                          totalItems += hr.quantidadeHorarios;
                        }

                        return Column(
  children: _listaHorarios.map((horario) {
    // Filtra os cortes correspondentes ao horário atual
    List<CorteClass> cortesParaHorario = cortesFiltrados
        .where((corte) => corte.horarioCorte == horario.horario)
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 100,
                        child: Text(
                          horario.horario,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10), // Espaçamento entre horário e conteúdo

                  // Verifica se há cortes para o horário atual
                  cortesParaHorario.isNotEmpty
                      ? Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: cortesParaHorario.map((corte) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                height: 80,
                                color: Colors.yellow,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    corte.clientName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
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
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.7,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Text(
                                "Horário Disponível",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }).toList(),
);

                      }
                      return Container(); // Pode retornar um Container vazio ou outro widget de acordo com o seu caso.
                    },
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
