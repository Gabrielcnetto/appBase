import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';

class ComponentDataRewards extends StatefulWidget {
  const ComponentDataRewards({super.key});

  @override
  State<ComponentDataRewards> createState() => _ComponentDataRewardsState();
}

class _ComponentDataRewardsState extends State<ComponentDataRewards> {
  void showModalRegras() {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
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
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Voltar",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Text(
                    "Regras da Troca de pontos",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Text(
                    "Você poderá trocar seus pontos por um corte grátis quando alcançar a quantidade necessária definida pela ${Estabelecimento.nomeLocal}. Ao usá-los, seus pontos serão reduzidos e você começará a acumular novamente após o próximo agendamento. Agende com mais frequência para atingir a meta mais rapidamente.",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resgate seus pontos',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      'Seus benefícios por acumular',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.17,
                          height: MediaQuery.of(context).size.height * 0.083,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.3,
                              color: Colors.grey.shade400,
                            ),
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "73",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              "imagesOfApp/coroa.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                // color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Stack(
                              children: [
                                LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade300,
                                  value: 1,
                                ),
                                LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.green.shade600,
                                  value: 0.5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Image.asset(
                            "imagesOfApp/trophy.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        "Colete 520 pontos para resgatar o prêmio",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 0.3,
              color: Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(25, 25),
              bottomRight: Radius.elliptical(25, 25),
              topLeft: Radius.elliptical(25, 25),
              topRight: Radius.elliptical(25, 25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.orange.shade400,
                      Colors.orangeAccent.shade700,
                    ], // Cores do gradiente
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds);
                },
                child: Text(
                  "80",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Corte Gratuito",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Alcance esta quantia de pontos",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "E Troque eles por um corte 100% grátis!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: showModalRegras,
                child: Text(
                  "Veja as regras...",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade400,
                      Colors.orangeAccent.shade700,
                    ],
                  ),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Text(
                  "Troque seus pontos",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
