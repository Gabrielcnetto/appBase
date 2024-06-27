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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ;
    Provider.of<ManagerScreenFunctions>(context, listen: false).getFolga;
    DataFolgaDatabase;
    LoadFolgaDatetime;
  }

  DateTime? dataSelectedInModal;
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

  String? profGet;
  void getProfissional({required String profissional}) {
    setState(() {
      profGet = profissional;
    });
    print("profissional pego: ${profGet}");
  }

  bool loading = false;
  List<Horarios> _horariosPreenchidosParaEvitarDupNoCreate = [];
  List<Horarios> _horariosLivresSabados = sabadoHorarios;
  List<Horarios> _horariosLivres = hourLists;
  List<Horarios> horarioFinal = [];
  //Aqui pegamos o dia selecionado, e usamos para buscar os dados no banco de dados
  //a funcao abaixo é responsavel por pegar o dia, entrar no provider e pesquisar os horarios daquele dia selecionado
  Future<void> loadListCortes() async {
    setState(() {
      loading = true;
    });
    horarioFinal.clear();
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
          Barbeiroselecionado: widget.corteWidget.profissionalSelect,
        );
        List<Horarios> listaCort =
            await Provider.of<CorteProvider>(context, listen: false)
                .horariosListLoad;

        for (var horario in listaCort) {
          print("horarios do provider: ${horario.horario}");

          listaTemporaria.removeWhere((atributosFixo) {
            return atributosFixo.horario == horario.horario;
          });
          _horariosPreenchidosParaEvitarDupNoCreate.add(Horarios(
              horario: horario.horario, id: horario.id, quantidadeHorarios: 1));
        }
        setState(() {
          horarioFinal = List.from(listaTemporaria);
          loading = false;
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

  Future<void> removeAtualAndSetNew() async {
    try {
      if (widget.corteWidget.barba == true) {
        //se for barba true tira o primeiro horario
        await Provider.of<CorteProvider>(context, listen: false)
            .AgendamentoCortePrincipalFunctionsRemarcacao(
          corte: widget.corteWidget,
          nomeBarbeiro: widget.corteWidget.profissionalSelect,
          barbaHoraExtra: true,
          selectDateForUser: dataSelectedInModal!,
          pricevalue: widget.corteWidget.totalValue,
        );
        await Provider.of<CorteProvider>(context, listen: false)
            .removeAgendamentoForEditReagendar2(
          corte: widget.corteWidget,
          nomeBarbeiro: widget.corteWidget.profissionalSelect,
          nomeMes: widget.corteWidget.NomeMes,
          horario: widget.corteWidget.horariosExtra[0],
        );
        //se for barba true tira o segundo horario
        await Provider.of<CorteProvider>(context, listen: false)
            .removeAgendamentoForEditReagendar3(
          corte: widget.corteWidget,
          nomeBarbeiro: widget.corteWidget.profissionalSelect,
          nomeMes: widget.corteWidget.NomeMes,
          horario: widget.corteWidget.horariosExtra[1],
        );
        //se for barba true tira o terceiro horario
        await Provider.of<CorteProvider>(context, listen: false)
            .removeAgendamentoForEditReagendar(
          corte: widget.corteWidget,
          nomeBarbeiro: widget.corteWidget.profissionalSelect,
          nomeMes: widget.corteWidget.NomeMes,
          horario: widget.corteWidget.horarioCorte,
        );
      } else {
        await Provider.of<CorteProvider>(context, listen: false)
            .AgendamentoCortePrincipalFunctionsRemarcacao(
          corte: widget.corteWidget,
          nomeBarbeiro: widget.corteWidget.profissionalSelect,
          barbaHoraExtra: false,
          selectDateForUser: dataSelectedInModal!,
          pricevalue: widget.corteWidget.totalValue,
        );
        await Provider.of<CorteProvider>(context, listen: false)
            .removeAgendamentoForEditReagendar(
          corte: widget.corteWidget,
          nomeBarbeiro: widget.corteWidget.profissionalSelect,
          nomeMes: widget.corteWidget.NomeMes,
          horario: widget.corteWidget.horarioCorte,
        );
      }

      await Provider.of<CorteProvider>(context, listen: false)
          .desmarcarAgendaManager(widget.corteWidget);
      await Provider.of<CorteProvider>(context, listen: false)
          .desmarcarCorteMeus(widget.corteWidget);
      await Provider.of<CorteProvider>(context, listen: false)
          .desmarcarCorteMeus(widget.corteWidget);
      await Provider.of<CorteProvider>(context, listen: false)
          .RemoveFaturamentosRemarcacao(widget.corteWidget);
    } catch (e) {
      print("Houve um erro no screen: ${e}");
    }
  }

  int selectedIndex = -1;
  Map<int, Color> itemColors = {};
  Map<int, Color> _textColor = {};
  String hourSetForUser = "00:00";
  void showNotifyPreSave() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            "Alterar Agendamento?",
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
            )),
          ),
          content: Text(
              "Você realmente Deseja alterar as informações deste agendamento?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                removeAtualAndSetNew();
              },
              child: Text(
                "Confirmar Alteração",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    "Atualize seu agendamento",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(),
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
                              dataSelectedInModal != null
                                  ? "${DateFormat("dd/MM/yyyy").format(dataSelectedInModal!)}"
                                  : "",
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {
                                  ShowModalData();
                                  getProfissional(
                                      profissional: widget
                                          .corteWidget.profissionalSelect);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Estabelecimento.primaryColor,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Text(
                                    dataSelectedInModal != null
                                        ? "Alterar"
                                        : "Selecionar Data",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Estabelecimento.contraPrimaryColor,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: dataSelectedInModal != null
                          ? Container(
                              width: double.infinity,
                              child: loading == false
                                  ? GridView.builder(
                                      padding: const EdgeInsets.only(top: 5),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: horarioFinal.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 2.3,
                                        childAspectRatio: 2.3,
                                      ),
                                      itemBuilder:
                                          (BuildContext ctx, int index) {
                                        Color color = selectedIndex == index
                                            ? Colors.amber
                                            : Estabelecimento.primaryColor;
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex =
                                                  selectedIndex == index
                                                      ? -1
                                                      : index;

                                              hourSetForUser =
                                                  horarioFinal[index].horario;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 3),
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.elliptical(20, 20),
                                                  bottomRight:
                                                      Radius.elliptical(20, 20),
                                                  topLeft:
                                                      Radius.elliptical(20, 20),
                                                  topRight:
                                                      Radius.elliptical(20, 20),
                                                ),
                                                color: color,
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "${horarioFinal[index].horario}",
                                                style: GoogleFonts.openSans(
                                                    textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                )),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Image.asset(
                                      "imagesOfApp/selecionedata.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Selecione um Dia",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (dataSelectedInModal != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: showNotifyPreSave,
                            child: Container(
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
                                  ),
                                ),
                              ),
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
