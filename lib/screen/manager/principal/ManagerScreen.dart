import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:barbershop2/rotas/Approutes.dart';
import 'package:barbershop2/screen/home/homeScreen01.dart';
import 'package:barbershop2/screen/manager/principal/components/Blocks.dart';
import 'package:barbershop2/screen/manager/principal/components/agendaDia/CortesHojeLista.dart';
import 'package:barbershop2/screen/manager/principal/components/verticalOptions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../functions/profileScreenFunctions.dart';

class ManagerScreenView extends StatefulWidget {
  const ManagerScreenView({super.key});

  @override
  State<ManagerScreenView> createState() => _ManagerScreenViewState();
}

class _ManagerScreenViewState extends State<ManagerScreenView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName;
    loadUserName();
    urlImagePhoto;
    urlImageFuncion();
    loadUserIsManager();
  }

  String? userName;
  Future<void> loadUserName() async {
    String? usuario = await MyProfileScreenFunctions().getUserName();

    if (userName != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      userName = usuario;
    });
  }

  String? urlImagePhoto;
  Future<void> urlImageFuncion() async {
    String? urlPhoto = await MyProfileScreenFunctions().getUserImage();

    if (urlImagePhoto != null) {
      print("imagem do usuario nao definidida");
    } else {
      const Text('N/A');
    }

    setState(() {
      urlImagePhoto = urlPhoto;
    });
  }

  bool? isManager;

  Future<void> loadUserIsManager() async {
    bool? bolIsManager = await MyProfileScreenFunctions().getUserIsManager();

    if (isManager != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      isManager = bolIsManager!;
    });
  }

  final String fotoPadraoUserError =
      "https://firebasestorage.googleapis.com/v0/b/easecortebaseversion-7100f.appspot.com/o/systemFotos%2FdefaultImages%2Fdefaultuser.jpeg?alt=media&token=d74b47d1-e4e8-40fb-a683-e65dbeedddc2";
  @override
  Widget build(BuildContext context) {
    return isManager == true
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const HomeScreen01(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade200,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                size: 15,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profissional - Principal",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${userName ?? "Carregando..."}",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 75,
                                height: 75,
                                child: urlImagePhoto == null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(45),
                                        child: Image.network(
                                          "${fotoPadraoUserError}",
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(45),
                                        child: Image.network(
                                          urlImagePhoto!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Dashboard",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const BlocksManagerComponent(),
                      const ManagerVerticalOptions(),
                      const CortesHojeLista(),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Text(
                "Dados Restritos",
              ),
            ),
          );
  }
}
