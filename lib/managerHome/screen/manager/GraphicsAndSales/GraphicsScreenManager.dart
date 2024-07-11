import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/GraphicsAndSales/componentes/FaturamentoMesSelecionado.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/GraphicsAndSales/componentes/detailsList.dart';

class GraphicsManagerScreen extends StatefulWidget {
  const GraphicsManagerScreen({super.key});

  @override
  State<GraphicsManagerScreen> createState() => _GraphicsManagerScreenState();
}

class _GraphicsManagerScreenState extends State<GraphicsManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Estatísticas Mensais",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          Estabelecimento.urlLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FaturamentoMesSelecionado(),
                SizedBox(height: 15,),
                CardWithDetailsView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
