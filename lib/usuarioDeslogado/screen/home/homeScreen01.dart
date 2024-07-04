import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/cortecClass.dart';
import 'package:lionsbarberv1/functions/CorteProvider.dart';
import 'package:lionsbarberv1/functions/managerScreenFunctions.dart';
import 'package:lionsbarberv1/functions/profileScreenFunctions.dart';
import 'package:lionsbarberv1/managerHome/screen/home/homeOnlyWidgets.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/principal/GeralTasks/ScheduleWithTwolists.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/principal/ManagerScreen.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/principal/encaixe/encaixeScreen.dart';
import 'package:lionsbarberv1/managerHome/screen/manager/principal/funcionario/funcionario_screen.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/add/addScreen.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/calendar/calendarScreen.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/home/homeOnlyWidgets.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/profile/profileScreen.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/History/History.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lionsbarberv1/rotas/Approutes.dart';
import 'package:lionsbarberv1/usuarioDeslogado/screen/History/History.dart';
import 'package:lionsbarberv1/usuarioDeslogado/screen/add/addScreen.dart';
import 'package:lionsbarberv1/usuarioDeslogado/screen/home/homeOnlyWidgets.dart';
import 'package:lionsbarberv1/usuarioDeslogado/screen/profile/profileScreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeScreen01Deslogado extends StatefulWidget {
  final int selectedIndex;
  const HomeScreen01Deslogado({super.key, required this.selectedIndex});

  @override
  State<HomeScreen01Deslogado> createState() => _HomeScreen01DeslogadoState();
}

class _HomeScreen01DeslogadoState extends State<HomeScreen01Deslogado> {
  //configuracoes do messagin cloud - inicio

  //configuracoes do messagin cloud - fim

  int screen = 0;
  List<Map<String, Object>>? _screensSelect;

  @override
  void initState() {
    // TODO: implement initState

    _screensSelect;
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    setState(() {
      _screensSelect = [
        {
          'tela': HomeOnlyWidgetsDeslogado(),
        },
        {
          'tela': AddScreenUserDeslogado(),
        },
        {
          'tela': HistoryScreenDeslogado(),
        },
        {
          'tela': const ProfileScreenDeslogado(),
        },
      ];
      screen = widget.selectedIndex;
    });
  }

  void attScren(int index) {
    setState(() {
      screen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CurvedNavigationBar(
          height: 50,
          animationDuration: const Duration(milliseconds: 100),
          index: screen,
          onTap: attScren,
          backgroundColor: Estabelecimento.primaryColor,
          items: const [
            Icon(
              Icons.home,
              size: 32,
            ),
            //    Icon(
            //      Icons.calendar_month,
            //   ),
            Icon(
              Icons.add,
              size: 32,
            ),
            Icon(
              Icons.timeline,
              size: 32,
            ),
            Icon(
              Icons.account_circle,
              size: 32,
            ),
          ],
        ),
      ),
      
      backgroundColor: Colors.white,
      body: _screensSelect![screen]['tela'] as Widget,
    );
  }
}
