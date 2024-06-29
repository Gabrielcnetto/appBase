import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/GraphicsAndSales/components/mensalView.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/GraphicsAndSales/components/pizzaProfs.dart';

class GraphicsManagerScreen extends StatefulWidget {
  const GraphicsManagerScreen({super.key});

  @override
  State<GraphicsManagerScreen> createState() => _GraphicsManagerScreenState();
}

class _GraphicsManagerScreenState extends State<GraphicsManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15, right: 15, left: 15),
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
                      Icons.arrow_back,
                      size: 22,
                    ),
                  ),
                  Text(
                    "Performance Geral",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "imagesOfApp/barbeariaLogo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              MensalViewFirstGraphic(),
              PizzaProfsHot(),
            ],
          ),
        ),
      ),
    );
  }
}
