import 'package:lionsbarberv1/classes/GeralUser.dart';
import 'package:lionsbarberv1/classes/cortecClass.dart';
import 'package:lionsbarberv1/functions/managerScreenFunctions.dart';
import 'package:lionsbarberv1/functions/profileScreenFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/principal/visao_clientesPlano/clientesComAssinaturas.dart';
import 'package:lionsbarberv1/managerHome/screen/profile/profileScreen.dart';
import 'package:lionsbarberv1/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class BlocksManagerComponent extends StatefulWidget {
  const BlocksManagerComponent({super.key});

  @override
  State<BlocksManagerComponent> createState() => _BlocksManagerComponentState();
}

class _BlocksManagerComponentState extends State<BlocksManagerComponent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ManagerScreenFunctions>(context, listen: false).loadClientes();
    loadTotalClientes();
    totalCortesNomES;
    loadTotalcortesmes();
    totalClientes;
    mesAtual;
    loadAtualMonth();
    loadTotalFaturamento();
    loadTotalCortes();
  }

  int? totalClientes;
  void loadTotalClientes() async {
    List<GeralUser> listClientes =
        await Provider.of<ManagerScreenFunctions>(context, listen: false)
            .clientesLista;

    setState(() {
      totalClientes = listClientes.length;
    });
    print("o tamanho é ${totalClientes}");
  }
  //

  int? totalCortesNomES;
  void loadTotalcortesmes() async {
    List<CorteClass> listCortesfinal =
        await Provider.of<ManagerScreenFunctions>(context, listen: false)
            .listaCortes;

    setState(() {
      totalCortesNomES = listCortesfinal.length;
      loadAssinatura1();
      loadSaques();
    });
  }
  //total para saque

  double valorAssinatura1 = 0;
  Future<void> loadAssinatura1() async {
    double? PointOfClient =
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .gettTotalemAssinaturasParaSaque();
    setState(() {
      valorAssinatura1 = PointOfClient!.toDouble();
      calculoReducaoFaturamentoPorAssinaturas();
    });
  }

  double totalSaquedisponivel = 0;
  Future<void> loadSaques() async {
    double? PointOfClient =
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .valorpossiveldesaque();
    setState(() {
      totalSaquedisponivel = PointOfClient!.toDouble();
    });
  }

  double faturamentofinalSemAssinaturas = 0;
  void calculoReducaoFaturamentoPorAssinaturas() {
    setState(() {
      faturamentofinalSemAssinaturas = (totalFaturamento - valorAssinatura1);
    });
  }

  String? mesAtual;
  Future<void> loadAtualMonth() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);

    setState(() {
      mesAtual = monthName;
    });
  }

  //faturamento total
  int totalFaturamento = 0;
  Future<void> loadTotalFaturamento() async {
    int totalFaturamentoGet =
        await ManagerScreenFunctions().loadFaturamentoBarbearia();

    setState(() {
      totalFaturamento = totalFaturamentoGet;
      calculoReducaoFaturamentoPorAssinaturas();
    });
  }

  //total cortes
  int totalCortes = 0;
  Future<void> loadTotalCortes() async {
    int totalCortesGet = await ManagerScreenFunctions().TotalcortesMes();

    setState(() {
      totalCortes = totalCortesGet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        //  color: Colors.red,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(
                            Icons.people,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${totalClientes}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Clientes cadastrados",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  child: Icon(
                                    Icons.cut,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  totalCortes > 1
                                      ? "${totalCortes} cortes"
                                      : "${totalCortes} corte",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Agendados em ${mesAtual ?? "Carregando..."}",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  child: Icon(
                                    Icons.paid,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "R\$${totalFaturamento.toStringAsFixed(2).replaceAll('.', ',') ?? 00}",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Faturamento esperado",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          DialogRoute(
                            context: context,
                            builder: (ctx) =>
                                ClientesComAssinaturaGeralScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(45),
                              ),
                              child: Icon(
                                Icons.credit_card,
                                color: Colors.grey.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                "R\$${valorAssinatura1.toStringAsFixed(2).replaceAll('.', ',')}",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total em mensalidades",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  size: 15,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: Icon(
                              Icons.currency_exchange,
                              color: Colors.grey.shade700,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "R\$${totalSaquedisponivel.toStringAsFixed(2).replaceAll('.', ',')}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Saque de Saldo",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_right,
                                size: 15,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutesApp.GraphicsManagerScreen);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 26, 82, 118),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Veja o resumo do estabelecimento",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //view screen graphic - DIVISAO
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              AppRoutesApp.ProfileScreenManagerWithScafol);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Editar Perfil",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
