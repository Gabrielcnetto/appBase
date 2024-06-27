import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/cortecClass.dart';
import 'package:lionsbarberv1/classes/horarios.dart';
import 'package:lionsbarberv1/functions/CorteProvider.dart';
import 'package:lionsbarberv1/functions/managerScreenFunctions.dart';
import 'package:provider/provider.dart';

class ChangeHourAndData extends StatefulWidget {
  final CorteClass corteWidget;
  const ChangeHourAndData({
    super.key,
    required this.corteWidget,
  });

  @override
  State<ChangeHourAndData> createState() => _ChangeHourAndDataState();
}

class _ChangeHourAndDataState extends State<ChangeHourAndData> {
  DateTime? dataSelectedInModal = DateTime.now();
  DateTime? DataFolgaDatabase;
  Future<void> LoadFolgaDatetime() async {
    DateTime? dataDoDatabaseVolta = await ManagerScreenFunctions().getFolga();
    print("pegamos a data do databse");
    if (DataFolgaDatabase != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      DataFolgaDatabase = dataDoDatabaseVolta;
    });
  }

  Future<void> ShowModalData() async {
    showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 14),
      ),
      selectableDayPredicate: (DateTime day) {
        // Desativa domingos
        if (day.weekday == DateTime.sunday) {
          return false;
        }
        // Bloqueia a data contida em dataOffselectOfManger
        if (DataFolgaDatabase != null &&
            day.year == DataFolgaDatabase!.year &&
            day.month == DataFolgaDatabase!.month &&
            day.day == DataFolgaDatabase!.day) {
          return false;
        }
        return true;
      },
    ).then((selectUserDate) {
      try {
        if (selectUserDate != null) {
          setState(() {
            dataSelectedInModal = selectUserDate;
            loadListCortes();
          });
        }
      } catch (e) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Erro'),
              content: Text("${e}"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o modal
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  List<Horarios> _horariosPreenchidosParaEvitarDupNoCreate = [];
  List<Horarios> _horariosLivresSabados = sabadoHorariosEncaixe;
  List<Horarios> _horariosLivres = listaHorariosEncaixe;
  List<Horarios> horarioFinal = [];
  List<Horarios> Horariopreenchidos = [];

  String? profGet;
  void getProfissional({required String profissional}) {
    setState(() {
      profGet = profissional;
    });
    print("profissional pego: ${profGet}");
  }

  Future<void> loadListCortes() async {
    print("iniciei o load com o profissional:${profGet}");
    horarioFinal.clear();
    Horariopreenchidos.clear();
    List<Horarios> listaTemporaria = [];
    int? diaSemanaSelecionado = dataSelectedInModal?.weekday;

    if (diaSemanaSelecionado == 6) {
      // Se for sábado, copia os horários disponíveis para sábado
      listaTemporaria.addAll(_horariosLivresSabados);
    } else {
      // Se não for sábado, copia os horários disponíveis padrão
      listaTemporaria.addAll(_horariosLivres);
    }

    DateTime? mesSelecionado = dataSelectedInModal;

    if (mesSelecionado != null) {
      try {
        await Provider.of<CorteProvider>(context, listen: false)
            .loadCortesDataBaseFuncionts(
          mesSelecionado: mesSelecionado,
          DiaSelecionado: mesSelecionado.day,
          Barbeiroselecionado: profGet ?? "",
        );
        List<Horarios> listaCort =
            await Provider.of<CorteProvider>(context, listen: false)
                .horariosListLoad;

        for (var horario in listaCort) {
          Horariopreenchidos.add(
            Horarios(
              quantidadeHorarios: 1,
              horario: horario.horario,
              id: horario.id,
            ),
          );
          _horariosPreenchidosParaEvitarDupNoCreate.add(Horarios(
              horario: horario.horario, id: horario.id, quantidadeHorarios: 1));
        }
        print(
            "o tamanho da lista de preenchidos é ${Horariopreenchidos.length}");
        setState(() {
          horarioFinal = List.from(listaTemporaria);
        });
        setState(() {});

        print("este e o tamanho da lista final: ${horarioFinal.length}");
      } catch (e) {
        print("nao consegu realizar, erro: ${e}");
      }
    } else {
      print("problemas na hora ou dia");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Atualize seu agendamento",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dia selecionado:",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                "${DateFormat("dd/MM/yyyy").format(dataSelectedInModal!)}"),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                ShowModalData();
                                getProfissional(
                                    profissional:
                                        widget.corteWidget.profissionalSelect);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Estabelecimento.primaryColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                child: Text(
                                  "Alterar",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Estabelecimento.contraPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        color: Colors.red,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.65,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Estabelecimento.primaryColor),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            "Salvar Alteração",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Estabelecimento.contraPrimaryColor,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ],
                    )
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
