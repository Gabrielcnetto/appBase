import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/classes/GeralUser.dart';
import 'package:lionsbarberv1/functions/rankingProviderHome.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/principal/visao_clientesPlano/item.dart';
import 'package:provider/provider.dart';

class ClientesComAssinaturaGeralScreen extends StatefulWidget {
  const ClientesComAssinaturaGeralScreen({super.key});

  @override
  State<ClientesComAssinaturaGeralScreen> createState() =>
      _ClientesComAssinaturaGeralScreenState();
}

class _ClientesComAssinaturaGeralScreenState
    extends State<ClientesComAssinaturaGeralScreen> {
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
    List<GeralUser> filteredList =
        userList.where((user) => user.isAssinatura == true).toList();

    setState(() {
      listadeClientes = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
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
                      size: 20,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Text(
                    'Seus assinantes',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(),
                ],
              ),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: listadeClientes.length,
                    itemBuilder: (ctx, index) {
                      return ItemPremiumUser(
                        userInfs: listadeClientes[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
