import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/GeralUser.dart';
import 'package:lionsbarberv1/functions/rankingProviderHome.dart';
import 'package:provider/provider.dart';

class ClienteDetalhes extends StatefulWidget {
  const ClienteDetalhes({super.key});

  @override
  State<ClienteDetalhes> createState() => _ClienteDetalhesState();
}

class _ClienteDetalhesState extends State<ClienteDetalhes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadListUsers();
  }

  List<GeralUser> listadeClientes = [];
  Future<void> loadListUsers() async {
    List<GeralUser> userList =
        await Provider.of<RankingProvider>(context, listen: false)
            .listaUsersManagerView2;
    print("dentro do set ${userList.length}");
    List<GeralUser> filteredList = userList
        .where((user) => !user.isManager && !user.isfuncionario)
        .toList();

    setState(() {
      listadeClientes = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25, right: 15, left: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                    Text(
                      "CLIENTES",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.tune,
                      color: Colors.grey.shade700,
                      size: 20,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Detalhes",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_down,
                                size: 18,
                                color: Colors.grey.shade800,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Mais antigo primeiro",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: listadeClientes.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.8,
                              color: Colors.grey.shade100,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    //color: Colors.red,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        listadeClientes[index].urlImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          listadeClientes[index].name,
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Color.fromRGBO(32, 32, 32, 1),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Nome",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    listadeClientes[index].ultimoAgendamento ==
                                            DateTime.now()
                                        ? Text("teste")
                                        : Text(
                                            "${DateFormat("dd/MMM/yyyy").format(
                                              listadeClientes[index]
                                                  .ultimoAgendamento,
                                            )}",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.radio_button_checked,
                                          size: 10,
                                          color: Colors.orangeAccent,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Último corte",
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Colors.orangeAccent,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
