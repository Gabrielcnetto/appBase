import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/cortecClass.dart';
import 'package:lionsbarberv1/functions/CorteProvider.dart';
import 'package:lionsbarberv1/functions/managerScreenFunctions.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/add/addScreen.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/calendar/calendarScreen.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/home/homeOnlyWidgets.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/profile/profileScreen.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/History/History.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeScreen01WithBoolManager extends StatefulWidget {
  final int selectedIndex;
  const HomeScreen01WithBoolManager({super.key, required this.selectedIndex});

  @override
  State<HomeScreen01WithBoolManager> createState() => _HomeScreen01WithBoolManagerState();
}

class _HomeScreen01WithBoolManagerState extends State<HomeScreen01WithBoolManager> {
  //configuracoes do messagin cloud - inicio

  //configuracoes do messagin cloud - fim
  int screen = 0;
  List<Map<String, Object>>? _screensSelect;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screen = widget.selectedIndex;
    Provider.of<CorteProvider>(context, listen: false).loadHistoryCortes();
    Provider.of<ManagerScreenFunctions>(context, listen: false).loadClientes();
    Provider.of<ManagerScreenFunctions>(context, listen: false)
        .loadMonthCortes();

    _screensSelect = [
      {
        'tela': const HomeOnlyWidgets(),
      },
      //  {
      //    'tela': const CalendarScreen(),
      //  },
      {
        'tela': const AddScreen(),
      },
      {
        'tela': const HistoryScreen(),
      },
      {
        'tela': const ProfileScreen(),
      },
    ];
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
          onTap: attScren,
          index: screen,
          backgroundColor: Estabelecimento.primaryColor,
          items: const [
            Icon(
              Icons.abc_outlined,
              size: 32,
            ),
            //    Icon(
            //      Icons.calendar_month,
            //   ),
            Icon(
              Icons.abc,
              size: 32,
            ),
            Icon(
              Icons.abc,
              size: 32,
            ),
            Icon(
                Icons.abc,
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
