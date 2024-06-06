import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:barbershop2/classes/profissionais.dart';
import 'package:barbershop2/functions/managerScreenFunctions.dart';
import 'package:barbershop2/screen/manager/principal/agenda_7dias/streamLoad7Diascortes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Agenda7DiasScreenManager extends StatefulWidget {
  const Agenda7DiasScreenManager({super.key});

  @override
  State<Agenda7DiasScreenManager> createState() =>
      _Agenda7DiasScreenManagerState();
}

class _Agenda7DiasScreenManagerState extends State<Agenda7DiasScreenManager> {
  List<int> lastSevenDays = [];
  List<String> lastSevenMonths = [];
  setDaysAndMonths() {
    initializeDateFormatting('pt_BR');
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      int dayOfMonth = int.parse(DateFormat('d').format(date));
      String monthName = DateFormat('MMMM', 'pt_BR').format(date);
      lastSevenDays.add(dayOfMonth);
      lastSevenMonths.add(monthName);
    }
    lastSevenDays = lastSevenDays.reversed.toList().reversed.toList();
    lastSevenMonths = lastSevenMonths.reversed.toList().reversed.toList();
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
    setDaysAndMonths();
    attViewSchedule(
        dia: lastSevenDays[0],
        mes: lastSevenMonths[0],
        proffName: profSelecionado);
  }

  int selectedIndex = 0;
  int profissionalSelecionadoIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Profissionais> _profList = profList;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.32,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.68, // Altura ajustável
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: StreamLoad7dias(),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                        Text(
                          "Horários Fechados",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(lastSevenDays.length, (index) {
                          int day = lastSevenDays[index];
                          String month = lastSevenMonths[index];
                          String firstLetterOfMonth = month.substring(0, 1);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex =
                                    index; // Atualiza o índice do item clicado

                                diaSelecionadoSegundo = day;
                                mesSelecionadoSegundo = month;
                              });
                              attViewSchedule(
                                  dia: day,
                                  mes: month,
                                  proffName: profSelecionado);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.115,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: selectedIndex ==
                                        index // Altera a cor se este item estiver selecionado
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
                                      fontWeight: FontWeight.w700,
                                      color: selectedIndex == index
                                          ? Colors
                                              .white // Cor do texto quando selecionado
                                          : Estabelecimento
                                              .contraPrimaryColor, // Cor padrão do texto
                                    ),
                                  ),
                                  Text(
                                    "${firstLetterOfMonth.toUpperCase()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
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
                          );
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: Row(
                              children: _profList.map((profissional) {
                                int profIndex = _profList.indexOf(
                                    profissional); // Índice do profissional atual

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        profSelecionado = profissional.nomeProf;
                                        profissionalSelecionadoIndex =
                                            profIndex; // Atualiza o índice do profissional selecionado

                                        if (mesSelecionadoSegundo != null) {
                                          print("o mes nao ta vazio");
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
                                      print(
                                          "O profissional selecionado é $profSelecionado");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: profissionalSelecionadoIndex ==
                                                profIndex
                                            ? Colors.blue
                                            : Colors
                                                .green, // Altera a cor se este profissional estiver selecionado
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.asset(
                                                profissional.assetImage,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${profissional.nomeProf}",
                                            style: GoogleFonts.openSans(
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
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
    );
  }
}
