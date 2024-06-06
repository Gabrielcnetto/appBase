import 'dart:math';

import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:barbershop2/classes/cortecClass.dart';
import 'package:barbershop2/classes/horarios.dart';
import 'package:barbershop2/functions/providerFilterStrings.dart';
import 'package:barbershop2/functions/twilio_messagesFunctions.dart';
import 'package:barbershop2/screen/manager/principal/ManagerScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemComponentHour extends StatefulWidget {
  final CorteClass Corte;
  const ItemComponentHour({
    super.key,
    required this.Corte,
  });

  @override
  State<ItemComponentHour> createState() => _ItemComponentHourState();
}

class _ItemComponentHourState extends State<ItemComponentHour> {
  Color _generateRandomLightColor() {
    Random random = Random();
    int minBrightness = 1; // ajuste este valor para controlar o brilho mínimo
    return Color.fromARGB(
      255,
      minBrightness + random.nextInt(200 - minBrightness), // red
      minBrightness + random.nextInt(200 - minBrightness), // green
      minBrightness + random.nextInt(200 - minBrightness), // blue
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetAndConfigprofffilter();
    setState(() {});
  }

  // Função para abrir o navegador
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir a URL: $url';
    }
  }

  String proffGet = "";
  void GetAndConfigprofffilter() {
    setState(() {
      proffGet =
          "${Provider.of<ProviderFilterManager>(context, listen: false).filtroParaUsar}";
    });
  }

  Future<void> setAndMyCortesIsActiveAllCuts() async {
    final DateTime dataAtual = DateTime.now();
    final int diaAtual = dataAtual.day;
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    print("allCuts/${monthName}/${diaAtual}");
    final String codeForUse = widget.Corte.ramdomCode.toString();

    final database = FirebaseFirestore.instance;
    try {
      print("entrei no try");
      QuerySnapshot querySnapshot = await database
          .collection("allCuts")
          .doc(monthName)
          .collection("$diaAtual")
          .get();
      if (querySnapshot.docs.isEmpty) {
        print("nao há nada na lista");
      } else {
        List<DocumentSnapshot> documents = querySnapshot.docs;
        for (DocumentSnapshot document in documents) {
          print("entrei no for");
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          if (data != null && data['ramdomNumber'].toString() == codeForUse) {
            // Encontrou o documento correspondente, atualize o atributo 'isActive' para false
            await document.reference.update({'isActive': false});
            // Faça qualquer outra operação necessária aqui
            print('Documento atualizado com sucesso');
            break; // Se você só precisa atualizar um documento, pode sair do loop aqui
          }
        }
      }
      final nomeBarber = Uri.encodeFull(widget.Corte.profissionalSelect);
      final removeAgenda = await database
          .collection("agenda")
          .doc("${widget.Corte.NomeMes}")
          .collection("${widget.Corte.DiaDoCorte}")
          .doc("${nomeBarber}")
          .collection("all")
          .doc("${widget.Corte.horarioCorte}")
          .delete();
    } catch (e) {
      print("Erro ao acessar/atualizar documentos: $e");
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Código Validado"),
          content: const Text("Presença do Cliente Confirmada"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const ManagerScreenView(),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> setAndMyCortesIsActive() async {
    final String codeForUse = widget.Corte.ramdomCode.toString();

    final database = FirebaseFirestore.instance;
    //=> Puxando os id´s do usuário
    QuerySnapshot querySnapshot = await database.collection("usuarios").get();
    //=> Dividindo os dados do firebase em snapshots
    List<DocumentSnapshot> docs = querySnapshot.docs;
    if (docs.isEmpty) {
    } else {
      for (var userDoc in docs) {
        try {
          //=> Acessando o item de todos os usuário(histórico)
          //a partir dos id´s coletados, entra em cada 1 e atualiza os atributos na pasta interna
          QuerySnapshot open = await database
              .collection("meusCortes")
              .doc(userDoc.id)
              .collection("lista")
              .get();

          //=> Dividindo os dados do firebase em snapshots(histórico)
          List<DocumentSnapshot> openDocs = open.docs;
          if (openDocs.isEmpty) {
          } else {
            for (var itemDoc in openDocs) {
              Map<String, dynamic> data =
                  itemDoc.data() as Map<String, dynamic>;
              if (data != null) {
                // Convertendo o ramdomNumber para String antes da comparação
                if (data['ramdomNumber'].toString() == codeForUse) {
                  // Atualizando o documento no Firestore
                  await database
                      .collection("meusCortes")
                      .doc(userDoc.id)
                      .collection("lista")
                      .doc(itemDoc.id)
                      .update({'isActive': false});
                  Future.delayed(Duration.zero, () {
                    _showErrorDialog(context);
                  });

                  break;
                } else if (data['ramdomNumber'].toString() != codeForUse) {}
              } else {}
            }
          }
        } catch (e) {
          print("Erro ao atualizar o documento Fora do allcuts: $e");
        }
      }
    }
  }

  void showPreLembrete() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Notificar cliente?"),
            content: Text(
                "O Cliente receberá uma mensagem para lembrar do horário, com opção para desmarcar"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await Provider.of<Twilio_messagesFunction>(context,
                          listen: false)
                      .sendWhatsMessageLembrete(
                          numberPhone: widget.Corte.numeroContato);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Notificar Agora",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Color _randomColor = _generateRandomLightColor();

    return widget.Corte.isActive == true &&
            widget.Corte.isActive != false &&
            (proffGet.isEmpty || proffGet == widget.Corte.profissionalSelect)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              key: Key(widget.Corte.id),
              decoration: BoxDecoration(
                  color: _randomColor, borderRadius: BorderRadius.circular(25)),
              width: MediaQuery.of(context).size.width * 1,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.8,
                            color: Colors.grey.shade100,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Text(
                          "${widget.Corte.profissionalSelect}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "${Estabelecimento.nomeLocal}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          "Cliente:",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade300,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${widget.Corte.clientName}",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          "barba:",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade300,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${widget.Corte.barba == true ? "Inclusa" : "Não Inclusa"}",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 25,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.Corte.horarioCorte}h",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () async {
                              setAndMyCortesIsActive();
                              setAndMyCortesIsActiveAllCuts();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.09,
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      widget.Corte.numeroContato.isEmpty
                          ? Container()
                          : InkWell(
                              onTap: showPreLembrete,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                    color: Colors.green.shade600,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Enviar Lembrete",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      child: Image.asset(
                                          "imagesOfApp/whatsaaplogo.png"),
                                    ),
                                  ],
                                ),
                              ),
                            )
                    ],
                  )
                ],
              ),
            ),
          )
        : SizedBox.shrink(
            key: Key(widget.Corte.id),
          );
  }
}
