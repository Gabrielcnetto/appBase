import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/horarios.dart';
import 'package:lionsbarberv1/rotas/Approutes.dart';

class MediaHorariosPreenchidos extends StatefulWidget {
  const MediaHorariosPreenchidos({super.key});

  @override
  State<MediaHorariosPreenchidos> createState() =>
      _MediaHorariosPreenchidosState();
}

class _MediaHorariosPreenchidosState extends State<MediaHorariosPreenchidos> {
  List<Horarios> _listaHorariosEncaixe = [...listaHorariosEncaixe];
  Map<String, int> horariosCount = {};

  @override
  void initState() {
    super.initState();
    fetchHorariosCount();
  }

  bool isLoadingList = false;
  Future<void> fetchHorariosCount() async {
    setState(() {
      isLoadingList = true;
    });
    try {
      for (var horario in _listaHorariosEncaixe) {
        final docRef = FirebaseFirestore.instance
            .collection("ComumPosts")
            .doc(horario.horario);
        final docSnapshot = await docRef.get();

        // Se o documento existir, pega o valor; senão, usa 0
        horariosCount[horario.horario] =
            docSnapshot.exists ? docSnapshot["totaldeMarcacoes"] : 0;
      }
    } catch (e) {
      print("##4Erro ao buscar horários: $e");
    } finally {
      setState(() {
        isLoadingList = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: isLoadingList == false
              ? Column(
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
                          "Horários preferidos",
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
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                      ),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                "Horário",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "Quantia de agendamentos",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: _listaHorariosEncaixe.length,
                          itemBuilder: (context, index) {
                            if (index >= _listaHorariosEncaixe.length) {
                              return Container(); // Previne acessos fora do range
                            }
                            final horario = _listaHorariosEncaixe[index];
                            final count = horariosCount[horario.horario] ?? 0;

                            return ListTile(
                              title: Text(horario.horario),
                              trailing: Text(count.toString()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ),
      ),
    );
  }
}
