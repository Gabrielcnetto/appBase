import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:barbershop2/classes/horarios.dart';
import 'package:barbershop2/classes/profissionais.dart';
import 'package:barbershop2/functions/CorteProvider.dart';
import 'package:barbershop2/functions/providerFilterStrings.dart';
import 'package:barbershop2/rotas/Approutes.dart';
import 'package:barbershop2/screen/manager/funcionario/componentes/diaListComponent.dart';
import 'package:barbershop2/screen/manager/principal/components/agendaDia/diaListComponent.dart';
import 'package:barbershop2/screen/manager/principal/components/agendaDia/itemComponentHour.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CortesHojeListaFuncionario extends StatefulWidget {
  const CortesHojeListaFuncionario({super.key});

  @override
  State<CortesHojeListaFuncionario> createState() => _CortesHojeListaState();
}

class _CortesHojeListaState extends State<CortesHojeListaFuncionario> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CorteProvider>(context, listen: false).horariosListLoad;
    print("o nome do 1 é: ${profissional2}");
    filterProfissional1;
  }

  final String profissional1 = profList[0].nomeProf;
  final String profissional2 = profList[1].nomeProf;
  final String profissional3 = profList[2].nomeProf;
  bool filterProfissional1 = false;
  bool filterProfissional2 = false;
  bool filterProfissional3 = false;

  returnCorretct() {
    try {
      if (filterProfissional1 == true) {
        setState(() {
          Provider.of<ProviderFilterManager>(context, listen: false)
              .filtroParaUsar = profissional1;
        });
      } else if (filterProfissional2 == true) {
        setState(() {
          Provider.of<ProviderFilterManager>(context, listen: false)
              .filtroParaUsar = profissional2;
        });
      } else if (filterProfissional3 == true) {
        setState(() {
          Provider.of<ProviderFilterManager>(context, listen: false)
              .filtroParaUsar = profissional3;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void setFilterProfissional1() async {
    setState(() {
      filterProfissional1 = true;

      filterProfissional3 = false;
      filterProfissional2 = false;
      returnCorretct();
    });

    Navigator.of(context).pushReplacementNamed(
      AppRoutesApp.ManagerScreenView,
    );
  }

  void setFilterProfissional2() {
    try {
      setState(() {
        filterProfissional2 = true;
        filterProfissional1 = false;
        filterProfissional3 = false;
        returnCorretct();
      });
      Navigator.of(context).pushReplacementNamed(
        AppRoutesApp.ManagerScreenView,
      );
    } catch (e) {
      print("sem barbeiro 2");
    }
  }

  void setFilterProfissional3() {
    try {
      setState(() {
        filterProfissional2 = false;
        filterProfissional1 = false;
        filterProfissional3 = true;
        returnCorretct();
      });
      Navigator.of(context).pushReplacementNamed(
        AppRoutesApp.ManagerScreenView,
      );
    } catch (e) {
      print("sem barbeiro 3");
    }
  }

  void screenEncaixe() {
    Navigator.of(context).pushNamed(AppRoutesApp.EncaixeScreenFuncionario);
  }

  @override
  Widget build(BuildContext context) {
    int diaAtual = DateTime.now().day;
    int mesAtual = DateTime.now().month;
    final List<Horarios> _horariosLOad =
        Provider.of<CorteProvider>(context, listen: false).horariosListLoad;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Agenda do dia",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Estabelecimento.primaryColor,
                        borderRadius: BorderRadius.circular(30)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                    child: Text(
                      "Dia ${diaAtual ?? "Carregando..."}/0${mesAtual ?? "Carregando..."}",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: screenEncaixe,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.greenAccent.shade700),
                      child: const Icon(
                        Icons.add_box,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          ),
          const DiaListaComponentFuncionario()
        ],
      ),
    );
  }
}
