import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/horarios.dart';
import 'package:lionsbarberv1/classes/profissionais.dart';
import 'package:lionsbarberv1/functions/agendaDataHorarios.dart';
import 'package:lionsbarberv1/functions/managerScreenFunctions.dart';
import 'package:provider/provider.dart';

class ScheduleWithTwoLists extends StatefulWidget {
  const ScheduleWithTwoLists({super.key});

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
    lastSevenDays = lastSevenDays.toList();
    lastSevenMonths = lastSevenMonths.toList();
    lastSevenWeekdays = lastSevenWeekdays.toList();
  }

  int? diaSelecionadoSegundo;
  String? mesSelecionadoSegundo;
  String profSelecionado = "${profList[0].nomeProf}";
  Future<void> attViewSchedule({
    required int dia,
    required String mes,
    required String proffName,
  }) async {
    print("dia selecionado:${dia} e o mês é o: ${mes}");
    Provider.of<ManagerScreenFunctions>(context, listen: false).loadAfterSetDay(
        selectDay: dia, selectMonth: mes, proffName: profSelecionado);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<AgendaData>(context, listen: false).atualizarLinhaPosicao(
      context: context,
      listaHorarios: listaHorariosEncaixe,
    );
    setDaysAndMonths();
    attViewSchedule(
        dia: lastSevenDays[0],
        mes: lastSevenMonths[0],
        proffName: profSelecionado);
  }

  int selectedIndex = 0;
  List<Horarios> _listaHorarios = listaHorariosEncaixe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
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
                SizedBox(
                  height: 25,
                ),
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
                                color: Colors.grey, // Cor da letra do mês
                              ),
                            ),
                            SizedBox(
                                height:
                                    5), // Espaço entre a letra e o número do dia
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
                                    proffName: profSelecionado);
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
                                      ? Colors.blue // Cor quando selecionado
                                      : Estabelecimento
                                          .primaryColor, // Cor padrão
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
                                            ? Colors
                                                .white // Cor do texto quando selecionado
                                            : Estabelecimento
                                                .contraPrimaryColor, // Cor padrão do texto
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
                SizedBox(
                  height: 10,
                ),
                Text("AQUI OS PROFISSIONAIS"),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Lista de horários à esquerda
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
                                    height: 60,
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
                            // Linha animada
                            Positioned(
                              top:
                                  Provider.of<AgendaData>(context).linhaPosicao ,
                              left: MediaQuery.of(context).size.width *
                                  0.12, // Ajuste conforme necessário para alinhar com a lista de horários
                              child: AnimatedContainer(
                                height: 1,
                                width: MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).size.width * 0.12,
                                color: Colors.blue,
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
