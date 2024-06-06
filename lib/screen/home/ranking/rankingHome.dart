import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:barbershop2/classes/GeralUser.dart';
import 'package:barbershop2/functions/rankingProviderHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RankingHome extends StatefulWidget {
  final double widhScreen;
  final double heighScreen;
  const RankingHome({
    super.key,
    required this.heighScreen,
    required this.widhScreen,
  });

  @override
  State<RankingHome> createState() => _RankingHomeState();
}

class _RankingHomeState extends State<RankingHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<RankingProvider>(context, listen: false).loadingListUsers();
    loadListUsers();
  }

  GeralUser? top1User;
  GeralUser? top2User;
  GeralUser? top3User;
  GeralUser? top4User;
  GeralUser? top5User;
  Future<void> loadListUsers() async {
    List<GeralUser> userList =
        Provider.of<RankingProvider>(context, listen: false).listaUsers;
    print("tamanho da listaHomeCar: ${userList.length}");

    //CRIANDO OS USUARIOS
    setState(() {
      top1User = GeralUser(
        isfuncionario: userList[0].isfuncionario,
        isManager: userList[0].isManager,
        listacortes: userList[0].listacortes,
        name: userList[0].name,
        urlImage: userList[0].urlImage,
      );
      top2User = GeralUser(
        isfuncionario: userList[1].isfuncionario,
        isManager: userList[1].isManager,
        listacortes: userList[1].listacortes,
        name: userList[1].name,
        urlImage: userList[1].urlImage,
      );
      top3User = GeralUser(
        isfuncionario: userList[2].isfuncionario,
        isManager: userList[2].isManager,
        listacortes: userList[2].listacortes,
        name: userList[2].name,
        urlImage: userList[2].urlImage,
      );
      top4User = GeralUser(
        isfuncionario: userList[3].isfuncionario,
        isManager: userList[3].isManager,
        listacortes: userList[3].listacortes,
        name: userList[3].name,
        urlImage: userList[3].urlImage,
      );
      top5User = GeralUser(
        isfuncionario: userList[4].isfuncionario,
        isManager: userList[4].isManager,
        listacortes: userList[4].listacortes,
        name: userList[4].name,
        urlImage: userList[4].urlImage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
      child: Container(
        // color: Colors.green,
        width: widget.widhScreen,
        //  height: heighScreen * 0.40,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Ranking ${Estabelecimento.nomeLocal}",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            //TOP 3 RANKING
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //AQUI O TOP 2
                Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: widget.widhScreen / 3.5,
                        height: widget.heighScreen * 0.325,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.elliptical(45, 45),
                            topRight: Radius.elliptical(45, 45),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5.2, right: 2, left: 2),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.elliptical(45, 45),
                              bottomLeft: Radius.elliptical(45, 45),
                              topRight: Radius.elliptical(45, 45),
                              bottomRight: Radius.elliptical(45, 45),
                            ),
                          ),
                          width: widget.widhScreen / 3.8,
                          height: widget.heighScreen * 0.14,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.elliptical(45, 45),
                              bottomLeft: Radius.elliptical(45, 45),
                              topRight: Radius.elliptical(45, 45),
                              bottomRight: Radius.elliptical(45, 45),
                            ),
                            child: top2User != null
                                ? Container(
                                    width: widget.widhScreen / 3.8,
                                    height: widget.heighScreen * 0.14,
                                    child: Image.network(
                                      "${top2User!.urlImage}",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    Estabelecimento.defaultAvatar,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 5,
                        top: 60,
                        child: Container(
                          alignment: Alignment.center,
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "2º",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.16,
                        child: Column(
                          children: [
                            Text(
                              "${top2User!.name ?? ""}",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${top2User!.listacortes ?? 0} Cortes",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //FIM DO TOP 2
                // INICIO DO TOP 1 (MID)
                Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: widget.widhScreen / 3.5,
                        height: widget.heighScreen * 0.35,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(251, 188, 0, 0.15),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(45, 45),
                            topRight: Radius.elliptical(45, 45),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5.2, right: 2, left: 2),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(251, 188, 0, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(45, 45),
                              bottomLeft: Radius.elliptical(45, 45),
                              topRight: Radius.elliptical(45, 45),
                              bottomRight: Radius.elliptical(45, 45),
                            ),
                          ),
                          width: widget.widhScreen / 3.8,
                          height: widget.heighScreen * 0.14,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.elliptical(45, 45),
                              bottomLeft: Radius.elliptical(45, 45),
                              topRight: Radius.elliptical(45, 45),
                              bottomRight: Radius.elliptical(45, 45),
                            ),
                            child: top1User!.urlImage != null
                                ? Container(
                                    width: widget.widhScreen / 3.8,
                                    height: widget.heighScreen * 0.14,
                                    child: Image.network(
                                      "${top1User!.urlImage}",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    Estabelecimento.defaultAvatar,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 5,
                        top: 5,
                        child: Container(
                          alignment: Alignment.center,
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "1º",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 1,
                        child: Container(
                          alignment: Alignment.center,
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(251, 188, 0, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            width: 17,
                            height: 17,
                            child: Image.asset(
                              "imagesOfApp/coroa.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.16,
                        child: Column(
                          children: [
                            Text(
                              "${top1User!.name}",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${top1User!.listacortes} Cortes",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //FIM DO TOP 1 (MID)
                //INICIO TOP 3
                Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: widget.widhScreen / 3.5,
                        height: widget.heighScreen * 0.3,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(177, 79, 50, 0.3),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(45, 45),
                            topRight: Radius.elliptical(45, 45),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5.2, right: 2, left: 2),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(177, 79, 50, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(45, 45),
                              bottomLeft: Radius.elliptical(45, 45),
                              topRight: Radius.elliptical(45, 45),
                              bottomRight: Radius.elliptical(45, 45),
                            ),
                          ),
                          width: widget.widhScreen / 3.8,
                          height: widget.heighScreen * 0.14,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.elliptical(45, 45),
                              bottomLeft: Radius.elliptical(45, 45),
                              topRight: Radius.elliptical(45, 45),
                              bottomRight: Radius.elliptical(45, 45),
                            ),
                            child: top3User!.urlImage != null
                                ? Container(
                                    width: widget.widhScreen / 3.8,
                                    height: widget.heighScreen * 0.14,
                                    child: Image.network(
                                      "${top3User!.urlImage}",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    Estabelecimento.defaultAvatar,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 65,
                        child: Container(
                          alignment: Alignment.center,
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "3º",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.16,
                        child: Column(
                          children: [
                            Text(
                              "${top3User!.name}",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${top3User!.listacortes} Cortes",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //FIM TOP 3
              ],
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Container(
                width: double.infinity,
                height: widget.heighScreen * 0.38,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.black12),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //INICIO DO QUARTO LUGAR
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: top4User != null
                                      ? Image.network(
                                          "${top4User!.urlImage}",
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          Estabelecimento.defaultAvatar,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "${top4User!.name}",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${top4User!.listacortes} cortes",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color.fromRGBO(217, 217, 217, 1)),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "4",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //FIM DO QUARTO LUGAR
                    Container(
                      width: double.infinity,
                      height: 0.8,
                      color: const Color.fromRGBO(32, 32, 32, 0.2),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: top5User != null
                                      ? Image.network(
                                          "${top5User!.urlImage}",
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          Estabelecimento.defaultAvatar,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "${top5User!.name}",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${top5User!.listacortes} cortes",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color.fromRGBO(217, 217, 217, 1)),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "5",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //FI
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
