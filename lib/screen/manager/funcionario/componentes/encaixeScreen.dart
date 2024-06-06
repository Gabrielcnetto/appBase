import 'dart:math';

import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:barbershop2/classes/cortecClass.dart';
import 'package:barbershop2/classes/profissionais.dart';
import 'package:barbershop2/functions/CorteProvider.dart';
import 'package:barbershop2/functions/profileScreenFunctions.dart';
import 'package:barbershop2/functions/twilio_messagesFunctions.dart';
import 'package:barbershop2/rotas/Approutes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../classes/horarios.dart';
import '../../../../functions/managerScreenFunctions.dart';

class EncaixeScreenFuncionario extends StatefulWidget {
  const EncaixeScreenFuncionario({super.key});

  @override
  State<EncaixeScreenFuncionario> createState() => _EncaixeScreenState();
}

class _EncaixeScreenState extends State<EncaixeScreenFuncionario> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName;
    loadUserName();
    phoneNumber;
    loadUserPhone();
    Provider.of<ManagerScreenFunctions>(context, listen: false).getFolga;
    DataFolgaDatabase;
    LoadFolgaDatetime;
    LoadPrice();
  }

  final List<Profissionais> _profList = profList;
  bool isBarbeiro1 = false;
  bool isBarbeiro2 = false;
  bool isBarbeiro3 = false;

  void setBarber1() {
    if (isBarbeiro1 == true) {
      null;
    } else {
      setState(() {
        isBarbeiro1 = true;
        isBarbeiro2 = false;
        isBarbeiro3 = false;
        dataSelectedInModal = null;
      });
    }
  }

  void setBarber2() {
    if (isBarbeiro2 == true) {
      null;
    } else {
      setState(() {
        isBarbeiro2 = true;
        isBarbeiro1 = false;
        dataSelectedInModal = null;
        isBarbeiro3 = false;
      });
    }
  }

  void setBarber3() {
    if (isBarbeiro3 == true) {
      null;
    } else {
      setState(() {
        isBarbeiro3 = true;
        isBarbeiro2 = false;
        isBarbeiro1 = false;
        dataSelectedInModal = null;
      });
    }
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

  Future<void> ShowModalData() async {
    setState(() {
      dataSelectedInModal = null;
    });
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

  int selectedIndex = -1;
  Map<int, Color> itemColors = {};
  Map<int, Color> _textColor = {};

  //controlers
  final nomeControler = TextEditingController();
  final numberControler = TextEditingController();

  String? userName;
  Future<void> loadUserName() async {
    String? usuario = await MyProfileScreenFunctions().getUserName();

    if (userName != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      userName = usuario;
      setDataControlers();
      LoadFolgaDatetime();
    });
  }

  //
  String? phoneNumber;
  Future<void> loadUserPhone() async {
    String? number = await MyProfileScreenFunctions().getPhone();

    if (phoneNumber != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      phoneNumber = number;
    });
  }

  void setDataControlers() {
    setState(() {
      nomeControler.text = userName!;
    });
  }

  int? atualPrice;

  Future<void> LoadPrice() async {
    int? priceDB = await ManagerScreenFunctions().getPriceCorte();
    print("pegamos a data do databse");

    setState(() {
      atualPrice = priceDB!;
    });
  }

  String? hourSetForUser;

  Future<void> CreateAgendamento() async {
    await initializeDateFormatting('pt_BR');

    String monthName =
        await DateFormat('MMMM', 'pt_BR').format(dataSelectedInModal!);
    var rng = new Random();
    int number = rng.nextInt(90000) + 10000;
    int diaDoCorte = dataSelectedInModal!.day;
    Provider.of<CorteProvider>(context, listen: false)
        .AgendamentoCortePrincipalFunctions(
      pricevalue: atualPrice ?? 00,
      nomeBarbeiro: isBarbeiro1
          ? "${profList[0].nomeProf}"
          : isBarbeiro2
              ? "${profList[1].nomeProf}"
              : isBarbeiro3
                  ? "${profList[2].nomeProf}"
                  : "Não Definido",
      corte: CorteClass(
        totalValue: atualPrice ?? 0,
        isActive: true,
        DiaDoCorte: diaDoCorte,
        NomeMes: monthName,
        dateCreateAgendamento: DateTime.now(),
        ramdomCode: number,
        clientName: nomeControler.text,
        id: Random().nextDouble().toString(),
        numeroContato: numberControler.text,
        barba: false,
        diaCorte: dataSelectedInModal!,
        horarioCorte: hourSetForUser!,
        profissionalSelect: isBarbeiro1
            ? "${profList[0].nomeProf}"
            : isBarbeiro2
                ? "${profList[1].nomeProf}"
                : isBarbeiro3
                    ? "${profList[2].nomeProf}"
                    : "Não Definido",
      ),
      selectDateForUser: dataSelectedInModal!,
    );
    await Provider.of<Twilio_messagesFunction>(context, listen: false)
        .sendWhatsMessage(numberPhone: "55${numberControler.text}");
    try {
      await analytics.logEvent(
        name: "scheduled_appointmen",
        parameters: {
          "appointment_type": "Corte-agendado",
          "appointment_datetime": DateTime.now().toIso8601String(),
        },
      );

      print("evento enviado");
    } catch (e) {
      print("erro ao enviar evento: $e");
    }
  }

  //Fazendo o filtro para exibir quais horarios estao disponíveis
  List<Horarios> _horariosLivresSabados = sabadoHorariosEncaixe;
  List<Horarios> _horariosLivres = listaHorariosEncaixe;
  List<Horarios> horarioFinal = [];
  List<Horarios> Horariopreenchidos = [];
  //Aqui pegamos o dia selecionado, e usamos para buscar os dados no banco de dados
  //a funcao abaixo é responsavel por pegar o dia, entrar no provider e pesquisar os horarios daquele dia selecionado
  Future<void> loadListCortes() async {
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
                Barbeiroselecionado: isBarbeiro1
                    ? "${profList[0].nomeProf}"
                    : isBarbeiro2
                        ? "${profList[1].nomeProf}"
                        : isBarbeiro3
                            ? "${profList[2].nomeProf}"
                            : "Não Definido");
        List<Horarios> listaCort =
            await Provider.of<CorteProvider>(context, listen: false)
                .horariosListLoad;

        for (var horario in listaCort) {
          Horariopreenchidos.add(
            Horarios(
              horario: horario.horario,
              id: horario.id,
            ),
          );
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

  void showModalConfirmAgend() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1,
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 22,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Resumo do encaixe",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Revise os dados",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Estabelecimento.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(217, 217, 217, 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //nome
                          Text(
                            "Nome do Cliente",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),
                          Text(
                            nomeControler.text,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          //contato
                          Text(
                            "Contato",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),
                          Text(
                            numberControler.text,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //data
                          const SizedBox(
                            height: 15,
                          ),
                          //contato
                          Text(
                            "Data",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),
                          Text(
                            DateFormat("dd/MM/yyy")
                                .format(dataSelectedInModal!),
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //Horario
                          Text(
                            "Horário",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),
                          Text(
                            hourSetForUser!,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //profissional
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Profissional",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),

                          Text(
                            isBarbeiro1 == true
                                ? "${profList[0].nomeProf}"
                                : isBarbeiro2 == true
                                    ? "${profList[1].nomeProf}"
                                    : isBarbeiro3 == true
                                        ? "${profList[2].nomeProf}"
                                        : "Não Definido",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      CreateAgendamento();
                      Navigator.of(context).pushReplacementNamed(
                          AppRoutesApp.ConfirmScreenCorteEncaixeFuncionario);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Estabelecimento.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Agendar",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                color: Estabelecimento.contraPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Estabelecimento.contraPrimaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final widhScren = MediaQuery.of(context).size.width;
    final heighScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: SingleChildScrollView(
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
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Encaixe um cliente na agenda",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Liberou horário? Faça um encaixe na agenda de Hoje",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black45,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //CONTAINER DO NOME inicio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Estabelecimento.secondaryColor
                                  .withOpacity(0.4)),
                          child: const Text("1"),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Nome do Cliente",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        controller: nomeControler,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //CONTAINER DO NOME fim
                    //CONTAINER DO NUMERO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Estabelecimento.secondaryColor
                                  .withOpacity(0.4)),
                          child: const Text("2"),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Telefone de contato",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "(Não obrigatório)",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black38,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        controller: numberControler,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    //CONTAINER DO NUMERO

                    const SizedBox(
                      height: 25,
                    ),
                    //CONTAINER DO PROFISSIONAL - INICIO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Estabelecimento.secondaryColor
                                  .withOpacity(0.4)),
                          child: const Text("3"),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Adicionar na agenda de qual profissional?",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: setBarber1,
                              child: Container(
                                width: widhScren * 0.25,
                                height: 130,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          _profList[0].assetImage,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    if (isBarbeiro1)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          child: const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          width: widhScren * 0.25,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              _profList[0].nomeProf,
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: setBarber2,
                              child: Container(
                                width: widhScren * 0.25,
                                height: 130,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          _profList[1].assetImage,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    if (isBarbeiro2)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          child: const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          width: widhScren * 0.25,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              _profList[1].nomeProf,
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: setBarber3,
                              child: Container(
                                width: widhScren * 0.25,
                                height: 130,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          _profList[2].assetImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    if (isBarbeiro3)
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          child: const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          width: widhScren * 0.25,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              _profList[2].nomeProf,
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    //CONTAINER DO PROFISSIONAL - FIM
                    //CONTAINER DA DATA - INICIO
                    const SizedBox(
                      height: 25,
                    ),
                    //CONTAINER DO PROFISSIONAL - INICIO
                    if (isBarbeiro1 || isBarbeiro2 || isBarbeiro3 != false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Estabelecimento.secondaryColor
                                    .withOpacity(0.4)),
                            child: const Text("5"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Selecione uma data",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (isBarbeiro1 || isBarbeiro2 || isBarbeiro3 != false)
                      InkWell(
                        onTap: () {
                          ShowModalData();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                Estabelecimento.secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dataSelectedInModal != null
                                    ? "${DateFormat("dd/MM/yyyy").format(dataSelectedInModal!)}"
                                    : "Escolha uma data",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 15,
                                color: Colors.grey.shade500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 25,
                    ),
                    //CONTAINER DA DATA - FIM
                    //CONTAINER DA HORA - INICIO
                    if (isBarbeiro1 ||
                        isBarbeiro2 ||
                        isBarbeiro3 != false && dataSelectedInModal != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Estabelecimento.secondaryColor
                                    .withOpacity(0.4)),
                            child: const Text("6"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Selecione um horário",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (isBarbeiro1 ||
                        isBarbeiro2 ||
                        isBarbeiro3 != false && dataSelectedInModal != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 2, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //ja preenchido
                            Text(
                              "Já preenchido - ",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              color: Colors.orangeAccent,
                            ),
                          ],
                        ),
                      ),
                    if (dataSelectedInModal != null)
                      Container(
                        width: double.infinity,
                        //  height: heighScreen * 0.64,
                        child: GridView.builder(
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: horarioFinal.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.3,
                            childAspectRatio: 2.3,
                          ),
                          itemBuilder: (BuildContext ctx, int index) {
                            bool presentInBothLists = Horariopreenchidos.any(
                                (horario) =>
                                    horarioFinal[index].horario ==
                                    horario
                                        .horario); // Verifica se o horário está presente nas duas listas
                            Color color = selectedIndex == index
                                ? Colors
                                    .green // Se o item estiver selecionado, a cor é verde
                                : presentInBothLists
                                    ? Colors
                                        .orangeAccent // Se o horário estiver presente em ambas as listas, a cor é vermelha
                                    : Estabelecimento
                                        .primaryColor; // Caso contrário, use a cor primária do Estabelecimento
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex =
                                      selectedIndex == index ? -1 : index;

                                  hourSetForUser = horarioFinal[index].horario;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 3),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.elliptical(20, 20),
                                      bottomRight: Radius.elliptical(20, 20),
                                      topLeft: Radius.elliptical(20, 20),
                                      topRight: Radius.elliptical(20, 20),
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
                        ),
                      ),
                    //CONTAINER DA HORA - FIM
                    //botao do agendar - inicio

                    if (hourSetForUser != null)
                      InkWell(
                        onTap: showModalConfirmAgend,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Estabelecimento.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Próximo",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                    color: Estabelecimento.contraPrimaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  )),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Estabelecimento.contraPrimaryColor,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 25,
                    ),
                    //botao do agendar - fim
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
