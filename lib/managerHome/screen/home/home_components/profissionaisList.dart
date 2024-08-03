import 'package:lionsbarberv1/classes/profissionais.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/rotas/Approutes.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/home/homeScreen01.dart';

class ProfissionaisList extends StatefulWidget {
  final double widhScreen;
  final double heighScreen;
  const ProfissionaisList({
    super.key,
    required this.heighScreen,
    required this.widhScreen,
  });

  @override
  State<ProfissionaisList> createState() => _ProfissionaisListState();
}

class _ProfissionaisListState extends State<ProfissionaisList> {
  @override
  Widget build(BuildContext context) {
    final List<Profissionais> _listProfs = profList;

    return Container(
      padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profissionais disponíveis",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _listProfs.length == 2
                    ? _listProfs.map((prof) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: InkWell(
                            onTap: () {
                              print("teste");
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext ctx) {
                                    return const HomeScreen01(
                                      selectedIndex: 1,
                                      cupomIsAcitve: false,
                                    );
                                  },
                                ),
                                (Route<dynamic> route) =>
                                    false, // Remove todas as rotas anteriores
                              );
                            },
                            child: Container(
                              width: widget.widhScreen > 300
                                  ? widget.widhScreen * 0.45
                                  : widget.widhScreen * 0.24,
                              height: widget.heighScreen * 0.35,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: widget.widhScreen > 250
                                            ? widget.widhScreen * 0.40
                                            : widget.widhScreen * 0.24,
                                        height: widget.heighScreen * 0.30,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.asset(
                                            prof.assetImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        prof.nomeProf,
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    : _listProfs.map((prof) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: widget.widhScreen > 300
                                ? widget.widhScreen * 0.27
                                : widget.widhScreen * 0.24,
                            height: 160,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: widget.widhScreen > 250
                                          ? widget.widhScreen * 0.27
                                          : widget.widhScreen * 0.24,
                                      height: 130,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          prof.assetImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      prof.nomeProf,
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
          )
        ],
      ),
    );
  }
}
