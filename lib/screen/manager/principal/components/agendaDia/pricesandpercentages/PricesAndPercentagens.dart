import 'package:barbershop2/rotas/Approutes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../../classes/Estabelecimento.dart';
import '../../../../../../functions/managerScreenFunctions.dart';

class PricesAndPercentages extends StatefulWidget {
  const PricesAndPercentages({super.key});

  @override
  State<PricesAndPercentages> createState() => _PricesAndPercentagesState();
}

class _PricesAndPercentagesState extends State<PricesAndPercentages> {
  final newpriceControler = TextEditingController();
  final newBarbaPriceControler = TextEditingController();
  final PorcentagemFuncionarioControler = TextEditingController();
  @override
  void initState() {
    super.initState();
    LoadPrice();
    LoadPriceAdicionalBarba();
    LoadPercentual();
    newpriceControler.addListener(() {
      if (newpriceControler.text.length == 2) {
        // Fecha o teclado após 2 caracteres
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
    newBarbaPriceControler.addListener(() {
      if (newBarbaPriceControler.text.length == 2) {
        // Fecha o teclado após 2 caracteres
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
    PorcentagemFuncionarioControler.addListener(() {
      if (PorcentagemFuncionarioControler.text.length == 2) {
        // Fecha o teclado após 2 caracteres
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  void dispose() {
    // Limpa o controlador ao descartar o widget para evitar vazamentos de memória
    newpriceControler.dispose();
    newBarbaPriceControler.dispose();
    PorcentagemFuncionarioControler.dispose();
    super.dispose();
  }

  //DIALOG DO PRECO - INICIO
  void showDialogAndSubmit() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Atualizar o preço?"),
            content: const Text(
                "Este valor é exibido após o cliente agendar um horário"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue = int.tryParse(newpriceControler.text) ?? 0;
                  Provider.of<ManagerScreenFunctions>(context, listen: false)
                      .setNewprice(newprice: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.ManagerScreenView);
                },
                child: Text(
                  "Salvar preço",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  //FIM DIALOG DO PRECO
  //INICIO DIALOG DO ADICIONAL
  void showDialogAndSubmitPrecoAdicional() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Atualizar o Valor Adicional?"),
            content: const Text(
                "Este valor é exibido após o cliente agendar um horário"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue = int.tryParse(newBarbaPriceControler.text) ?? 0;
                  Provider.of<ManagerScreenFunctions>(context, listen: false)
                      .setAdicionalPriceBarba(barbaPrice: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.ManagerScreenView);
                },
                child: Text(
                  "Salvar Adicional",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  //FIM DIALOG ADICIONAL
  //DIALOG DO PERCENTUAL - INICIO
  void showDialogPercentualSet() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Atualizar o Percentual?"),
            content: const Text(
                "Este valor é usado para calcular a porcentagem de funcionários"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue =
                      int.tryParse(PorcentagemFuncionarioControler.text) ?? 0;
                  Provider.of<ManagerScreenFunctions>(context, listen: false)
                      .setPorcentagemFuncionario(porcentagem: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.ManagerScreenView);
                },
                child: Text(
                  "Salvar Adicional",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  //DIALOG DO PERCENTUAL - FIM
  int? atualPrice;

  Future<void> LoadPrice() async {
    int? priceDB = await ManagerScreenFunctions().getPriceCorte();
    print("pegamos a data do databse");

    setState(() {
      atualPrice = priceDB!;
    });
  }

  int? barbaPriceFinal;

  Future<void> LoadPriceAdicionalBarba() async {
    int? priceDB = await ManagerScreenFunctions().getAdicionalBarbaCorte();
    print("pegamos a data do databse");

    setState(() {
      barbaPriceFinal = priceDB!;
    });
  }

  //get do percentual
  int? loadPercentual;

  Future<void> LoadPercentual() async {
    int? priceDB = await ManagerScreenFunctions().getPorcentagemFuncionario();
    print("pegamos a data do databse");

    setState(() {
      loadPercentual = priceDB!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //INICIO ATUALIZE O PRECO
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            "Atualize preços e porcentagens",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Configure o preço dos cortes",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black45),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    
                    //preco cabelo - inicio
                    
                    Row(
                      children: [
                        Text(
                          "Preço Atual:",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "R\$${atualPrice ?? 0}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Preço novo:",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "R\$",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.topCenter,
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 50,
                              child: Flexible(
                                child: TextFormField(
                                  controller: newpriceControler,
                                  textAlignVertical: TextAlignVertical.top,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  decoration: const InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: 30,
                                      minHeight: 30,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: showDialogAndSubmit,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Estabelecimento.primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "Atualizar Preço",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Estabelecimento.contraPrimaryColor),
                                ),
                              ),
                            ),
                          ),
                          //FIM DO PRECO
                        ],
                      ),
                    ),
                    //cabelo fim
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 2,
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //barba inicio
                    Text(
                      "Valor Adicional barba",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black45),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Preço Atual:",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "R\$${barbaPriceFinal ?? 0}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Preço novo:",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "R\$",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.topCenter,
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 50,
                              child: Flexible(
                                child: TextFormField(
                                  controller: newBarbaPriceControler,
                                  textAlignVertical: TextAlignVertical.top,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  decoration: const InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: 30,
                                      minHeight: 30,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: showDialogAndSubmitPrecoAdicional,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Estabelecimento.primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "Atualizar Valor adicional",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Estabelecimento.contraPrimaryColor),
                                ),
                              ),
                            ),
                          ),
                          //FIM DO PRECO
                        ],
                      ),
                    ),
                    //barba fim
                  ],
                ),
                //FIM DO ATUALIZACAO DO PRECO
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                ),
                const SizedBox(
                  height: 20,
                ),
                //INICIO ATUALIZACAO %
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Configure a porcentagem dos funcionários",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black45),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Porcentagem Atual:",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "% ${loadPercentual ?? 0}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Porcentagem nova:",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              " %",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.topCenter,
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 50,
                              child: Flexible(
                                child: TextFormField(
                                  controller: PorcentagemFuncionarioControler,
                                  textAlignVertical: TextAlignVertical.top,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  decoration: const InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: 30,
                                      minHeight: 30,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: showDialogPercentualSet,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Estabelecimento.primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Atualizar Porcentagem",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Estabelecimento.contraPrimaryColor),
                            ),
                          ),
                        ),
                      ),
                      //FIM DO PRECO
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
