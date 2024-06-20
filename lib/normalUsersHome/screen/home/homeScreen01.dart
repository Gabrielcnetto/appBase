import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/cortecClass.dart';
import 'package:lionsbarberv1/functions/CorteProvider.dart';
import 'package:lionsbarberv1/functions/managerScreenFunctions.dart';
import 'package:lionsbarberv1/functions/profileScreenFunctions.dart';
import 'package:lionsbarberv1/managerHome/screen/home/homeOnlyWidgets.dart';
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
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeScreen01 extends StatefulWidget {
  final int selectedIndex;
  const HomeScreen01({super.key, required this.selectedIndex});

  @override
  State<HomeScreen01> createState() => _HomeScreen01State();
}

class _HomeScreen01State extends State<HomeScreen01> {
  bool isManager = false;
  bool isFuncionario = false;
  int screen = 0;
  List<Map<String, Object>>? _screensSelect;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _screensSelect;
    loadInitialData();
    loadUserIsFuncionario();
    loadUserIsManager();
  }

  Future<void> loadInitialData() async {
    await loadUserIsManager();
    await loadUserIsFuncionario();
    setState(() {
      _screensSelect = [
        {
          'tela': isManager == true
              ? const HomeOnlyWidgetsForManagers()
              : const HomeOnlyWidgets(),
        },
        {
          'tela': (isManager || isFuncionario) == true
              ? const EncaixeScreenProfissionalOptionHomeProf()
              : const AddScreen(),
        },
        {
          'tela': const HistoryScreen(),
        },
        {
          'tela': isManager == true
              ? const ManagerScreenViewHomeNewView()
              : isFuncionario == true
                  ? const FuncionarioScreenHomeScreenNew()
                  : const ProfileScreen(),
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

  Future<void> loadUserIsManager() async {
    bool? bolIsManager = await MyProfileScreenFunctions().getUserIsManager();

    if (isManager != null) {
      setState(() {
        isManager = bolIsManager!;
      });
    } else {
      print("erro ao logar ismanager");
    }
  }

  Future<void> loadUserIsFuncionario() async {
    bool? funcionario = await MyProfileScreenFunctions().getUserIsFuncionario();
    if (isFuncionario != null) {
      setState(() {
        isFuncionario = funcionario!;
      });
    } else {
      print("erro ao carregar funcionario");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CurvedNavigationBar(
          height: 50,
          animationDuration: const Duration(milliseconds: 80),
          onTap: attScren,
          index: screen,
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
      body: _screensSelect != null && _screensSelect![screen]['tela'] != null
          ? _screensSelect![screen]['tela'] as Widget
          : Container(),
    );
  }
}
