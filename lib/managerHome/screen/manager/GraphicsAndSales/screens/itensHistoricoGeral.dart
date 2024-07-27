import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/cortecClass.dart';
import 'package:lionsbarberv1/classes/profissionais.dart';

class ItemHistoricoGeral extends StatelessWidget {
  final CorteClass corteClassItem;
  const ItemHistoricoGeral({
    super.key,
    required this.corteClassItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      corteClassItem.profissionalSelect == profList[0].nomeProf
                          ? profList[0].assetImage
                          : corteClassItem.profissionalSelect ==
                                  profList[1].nomeProf
                              ? profList[1].assetImage
                              : '${Estabelecimento.defaultAvatar}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.done_all,
                      color: Colors.blue.shade600,
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Feito por: ',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          '${corteClassItem.profissionalSelect}',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      corteClassItem.detalheDoProcedimento,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    'R\$${corteClassItem.totalValue ?? 0}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    corteClassItem.clientName,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${corteClassItem.DiaDoCorte} de ${corteClassItem.NomeMes} ',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.blue.shade600,
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
  }
}
