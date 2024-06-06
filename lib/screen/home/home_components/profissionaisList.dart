import 'package:barbershop2/classes/profissionais.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfissionaisList extends StatelessWidget {
  final double widhScreen;
  final double heighScreen;
  const ProfissionaisList({
    super.key,
    required this.heighScreen,
    required this.widhScreen,
  });

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
              children: 
              _listProfs.length == 2 ?
               _listProfs.map((prof) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: widhScreen > 300
                        ? widhScreen * 0.45
                        : widhScreen * 0.24,
                    height: heighScreen * 0.35,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: widhScreen > 250
                                  ? widhScreen * 0.40
                                  : widhScreen * 0.24,
                              height: heighScreen * 0.30,
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
              }).toList() :              _listProfs.map((prof) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: 
                  Container(
                    width: widhScreen > 300
                        ? widhScreen * 0.27
                        : widhScreen * 0.24,
                    height: 160,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: widhScreen > 250
                                  ? widhScreen * 0.27
                                  : widhScreen * 0.24,
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
              }).toList()
            ),
          )
        ],
      ),
    );
  }
}
