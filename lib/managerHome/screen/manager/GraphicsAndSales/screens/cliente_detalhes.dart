import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClienteDetalhes extends StatelessWidget {
  const ClienteDetalhes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25, right: 15, left: 15),
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: const Color.fromARGB(255, 28, 28, 28),
                          size: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
