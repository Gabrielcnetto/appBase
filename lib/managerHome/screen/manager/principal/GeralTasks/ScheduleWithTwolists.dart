import 'package:cloud_firestore/cloud_firestore.dart';
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
    _removedHours = List.from(listaHorariosEncaixe);
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
  List<Horarios> _removedHours = listaHorariosEncaixe;
  List<Profissionais> _profList = profList;

  int selectedIndex = 0;
  int profissionalSelecionadoIndex = 0;
  int encontrarIndiceHorario(String horarioCorte) {
    // Encontra o índice do horário na lista listaHorariosEncaixe
    for (int i = 0; i < listaHorariosEncaixe.length; i++) {
      if (listaHorariosEncaixe[i].horario == horarioCorte) {
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
                                children: listaHorariosdaLateral.map((hr) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black)),
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
                                        itemCount: _removedHours.length,
                                        itemBuilder: (ctx, index) {
                                          // Verifica se o horário do índice atual está em cortesFiltrados
                                          bool isInCortesFiltrados =
                                              cortesFiltrados.any((corte) =>
                                                  listaHorariosEncaixe[index]
                                                      .horario ==
                                                  corte.horarioCorte);

                                          if (isInCortesFiltrados) {
                                            // Obtém o item correspondente de cortesFiltrados
                                            CorteClass corte = cortesFiltrados
                                                .firstWhere((corte) =>
                                                    listaHorariosEncaixe[index]
                                                        .horario ==
                                                    corte.horarioCorte);

                                            if (corte.barba == true) {
                                              // Remove os próximos 4 itens de listaHorariosEncaixe a partir do índice atual
                                              int removeCount = (index + 4 <
                                                      _removedHours.length)
                                                  ? 4
                                                  : _removedHours.length -
                                                      index -
                                                      1;
                                              _removedHours.removeRange(
                                                  index + 1,
                                                  index + 1 + removeCount);
                                            }

                                            return Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              width: double.infinity,
                                              height: corte.barba == true
                                                  ? 500
                                                  : 100,
                                              child: Text(
                                                corte.horarioCorte,
                                                style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            // Se o índice não está em cortesFiltrados, mostra um Container padrão
                                            return Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              width: double.infinity,
                                              height: 100,
                                              child: Text(
                                                "Horário disponível",
                                                style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
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
