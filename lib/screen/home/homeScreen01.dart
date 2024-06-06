import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:barbershop2/classes/cortecClass.dart';
import 'package:barbershop2/functions/CorteProvider.dart';
import 'package:barbershop2/functions/managerScreenFunctions.dart';
import 'package:barbershop2/screen/add/addScreen.dart';
import 'package:barbershop2/screen/calendar/calendarScreen.dart';
import 'package:barbershop2/screen/home/homeOnlyWidgets.dart';
import 'package:barbershop2/screen/profile/profileScreen.dart';
import 'package:barbershop2/screen/History/History.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeScreen01 extends StatefulWidget {
  const HomeScreen01({super.key});

  @override
  State<HomeScreen01> createState() => _HomeScreen01State();
}

class _HomeScreen01State extends State<HomeScreen01> {
  //configuracoes do messagin cloud - inicio
  
  //configuracoes do messagin cloud - fim
  int screen = 0;
  List<Map<String, Object>>? _screensSelect;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.subscribeToTopic("clientes");
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
