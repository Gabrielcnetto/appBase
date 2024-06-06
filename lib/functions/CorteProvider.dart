import 'dart:async';

import 'package:barbershop2/classes/cortecClass.dart';
import 'package:barbershop2/classes/horarios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CorteProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseAuth.instance;

  //ENVIANDO O CORTE PARA AS LISTAS NO BANCO DE DADOS - INICIO
  Future<void> AgendamentoCortePrincipalFunctions({
    required CorteClass corte,
    required DateTime selectDateForUser,
    required String nomeBarbeiro,
    required int pricevalue,
  }) async {
    print("entrei na funcao");

    await initializeDateFormatting('pt_BR');
    int diaCorteSelect = corte.diaCorte.day;
    String monthName =
        await DateFormat('MMMM', 'pt_BR').format(selectDateForUser);
    print(monthName);
    print("entrei na funcao");
    final nomeBarber = Uri.encodeFull(nomeBarbeiro);

    try {
      //adicionado lista principal de cortes do dia
      final addOnDB = await database
          .collection("agenda")
          .doc(monthName)
          .collection("${diaCorteSelect}")
          .doc(nomeBarber)
          .collection("all")
          .doc(corte.horarioCorte)
          .set({
        "totalValue": corte.totalValue,
        'isActive': corte.isActive,
        "diaDoCorte": corte.DiaDoCorte,
        "id": corte.id,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "horarioCorte": corte.horarioCorte,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });

      //adicionado allcuts
      final addAllcuts = await database
          .collection("allCuts")
          .doc(monthName)
          .collection("${diaCorteSelect}")
          .doc(corte.id)
          .set({
        "totalValue": corte.totalValue,
        "id": corte.id,
        'isActive': corte.isActive,
        "diaDoCorte": corte.DiaDoCorte,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "horarioCorte": corte.horarioCorte,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });
      //adicionando na lista de cada funcionario - inicio
      final addOnProfListAllcuts = await database
          .collection("mensalCuts")
          .doc(monthName)
          .collection(corte.profissionalSelect)
          .add({
        "price": pricevalue,
      });
      //adicionando na lista de cada funcionario - fim

      //adicionando o valor no faturamento total da barbearia - inicio
      final addFaturamentoTotal = await database
          .collection("estabelecimento")
          .doc("faturamento")
          .collection(monthName)
          .add({
        "price": pricevalue,
      });
      //adicionando o valor no faturamento total da barbearia - fim

      final addTotalCortes = await database
          .collection("totalCortes")
          .doc(monthName)
          .collection("all")
          .add({
        "id": corte.id,
         "totalValue": corte.totalValue,
        'isActive': corte.isActive,
        "diaDoCorte": corte.DiaDoCorte,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "horarioCorte": corte.horarioCorte,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });
      //adicionando em lista aleatoria apenas para soma:
      final userId = await authSettings.currentUser!.uid;
      final myCortes = await database
          .collection("meusCortes")
          .doc(userId)
          .collection("lista")
          .doc(corte.id)
          .set({
        "id": corte.id,
         "totalValue": corte.totalValue,
        'isActive': corte.isActive,
        "diaDoCorte": corte.DiaDoCorte,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "horarioCorte": corte.horarioCorte,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });

      //adicionado aos meus cortes
      final updateLenghCortesInProfile =
          await database.collection("usuarios").doc(userId).update({
        "totalCortes": FieldValue.increment(
            1), //update do int para +1 atualizando ototal de cortes
      });
    } catch (e) {
      print("ocorreu isto:${e}");
    }
    notifyListeners();
  }
  //ENVIANDO O CORTE PARA AS LISTAS NO BANCO DE DADOS - FIM

  //CARREGANDO OS CORTES E FAZENDO A VERIFICACAO - INICIO

  List<Horarios> _horariosListLoad = [];
  List<Horarios> get horariosListLoad => [..._horariosListLoad];
  //
  Future<void> loadCortesDataBaseFuncionts(
      {required DateTime mesSelecionado,
      required int DiaSelecionado,
      required String Barbeiroselecionado}) async {
    _horariosListLoad.clear();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(mesSelecionado);
    final nomeBarber = Uri.encodeFull(Barbeiroselecionado);

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("agenda")
          .doc(monthName)
          .collection("${DiaSelecionado}")
          .doc(nomeBarber)
          .collection("all")
          .get();

      List<Horarios> horarios = querySnapshot.docs.map((doc) {
        return Horarios(
          horario: doc.id,
          id: "",
        );
      }).toList();
      for (var hor in _horariosListLoad) {
        print("horario da lista preenchido: ${hor.horario}");
      }
      _horariosListLoad = horarios;
      notifyListeners();
      DiaSelecionado = 0;
    } catch (e) {
      print("o erro especifico é: ${e}");
    } // Notifica os ouvintes sobre a mudança nos dados
  }

  final StreamController<List<CorteClass>> _cortesController =
      StreamController<List<CorteClass>>.broadcast();

  Stream<List<CorteClass>> get cortesStream => _cortesController.stream;

  List<CorteClass> _historyList = [];
  List<CorteClass> get userCortesTotal => [..._historyList];
  Future<void> loadHistoryCortes() async {
    try {
      // Emite a lista atualizada através do StreamController

      QuerySnapshot querySnapshot = await database
          .collection('meusCortes/${authSettings.currentUser!.uid}/lista')
          .get();

      _historyList = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['dataCreateAgendamento'] as Timestamp?;
        }

        DateTime diaCorte = timestamp?.toDate() ?? DateTime.now();
        //CONVERTENDO O DIA DO CORTE AGORA
        Timestamp? diafinalCorte;
        if (data != null) {
          timestamp = data['diaCorte'] as Timestamp?;
        }

        DateTime diaCorteFinal = diafinalCorte?.toDate() ?? DateTime.now();
        // Acessando os atributos diretamente usando []
        return CorteClass(
          totalValue:  data?["totalValue"], 
          isActive: data?["isActive"],
          DiaDoCorte: data?["diaDoCorte"],
          NomeMes: data?["monthName"],
          dateCreateAgendamento: diaCorte,
          clientName: data?['clientName'],
          id: data?['id'],
          numeroContato: data?['numeroContato'],
          profissionalSelect: data?['profissionalSelect'],
          diaCorte: diaCorteFinal, // Usando o atributo diaCorte
          horarioCorte: data?['horarioCorte'],
          barba: data?['barba'],
          ramdomCode: data?['ramdomNumber'],
        );
      }).toList();
      _cortesController.add(_historyList);
      // Ordenar os dados pela data
      _historyList.sort((a, b) {
        return b.dateCreateAgendamento.compareTo(a.dateCreateAgendamento);
      });

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar os dados do Firebase: $e');
    }
  }

  //CARREGANDO A LISTA DO DIA, PARA EXIBIR NA TELA DE MANAGER (lista 2) - INICIO
  final StreamController<List<CorteClass>> _CorteslistaManager =
      StreamController<List<CorteClass>>.broadcast();

  Stream<List<CorteClass>> get CorteslistaManager => _CorteslistaManager.stream;

  List<CorteClass> _managerListCortes = [];
  List<CorteClass> get managerListCortes => [..._managerListCortes];
  Future<void> loadHistoryCortesManagerScreen() async {
    print("Entrei na funcao do load Manager");
    try {
      print("Entrei no try do manager");
      // Emite a lista atualizada através do StreamController
      DateTime MomentoAtual = DateTime.now();
      await initializeDateFormatting('pt_BR');
      int diaAtual = MomentoAtual.day;
      String monthName = DateFormat('MMMM', 'pt_BR').format(MomentoAtual);
      QuerySnapshot querySnapshot =
          await database.collection('allCuts/${monthName}/${diaAtual}').get();

      _managerListCortes = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['dataCreateAgendamento'] as Timestamp?;
        }

        DateTime diaCorte = timestamp?.toDate() ?? DateTime.now();
        //CONVERTENDO O DIA DO CORTE AGORA
        Timestamp? diafinalCorte;
        if (data != null) {
          timestamp = data['diaCorte'] as Timestamp?;
        }

        DateTime diaCorteFinal = diafinalCorte?.toDate() ?? DateTime.now();
        // Acessando os atributos diretamente usando []
        return CorteClass(
          totalValue: data?["totalValue"], 
          isActive: data?["isActive"],
          DiaDoCorte: data?["diaDoCorte"],
          NomeMes: data?["monthName"],
          dateCreateAgendamento: diaCorte,
          clientName: data?['clientName'],
          id: data?['id'],
          numeroContato: data?['numeroContato'],
          profissionalSelect: data?['profissionalSelect'],
          diaCorte: diaCorteFinal, // Usando o atributo diaCorte
          horarioCorte: data?['horarioCorte'],
          barba: data?['barba'],
          ramdomCode: data?['ramdomNumber'],
        );
      }).toList();
      _CorteslistaManager.add(_managerListCortes);

      // Ordenar os dados pela data
      _managerListCortes.sort((a, b) {
        return b.dateCreateAgendamento.compareTo(a.dateCreateAgendamento);
      });
      _managerListCortes.sort((a, b) {
        // Aqui, estamos comparando os horários de corte como strings
        return a.horarioCorte.compareTo(b.horarioCorte);
      });

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar os dados do Firebase do Manager: $e');
    }
  }

  //CARREGANDO ALISTA DO DIA, PARA EXIBIR NA TELA DO MANAGER(LISTA2) - FIM

  Future<void> desmarcarCorte(CorteClass corte) async {
    try {
      //DELETANDO DA LISTA PRINCIPAL - INICIO
      print("Entramos na configuração de excluir");
      final nomeBarber = Uri.encodeFull(corte.profissionalSelect);
      final referencia = await database
          .collection("agenda")
          .doc(corte.NomeMes)
          .collection("${corte.DiaDoCorte}")
          .doc(nomeBarber)
          .collection("all")
          .doc(corte.horarioCorte);

      print("Esta é a referência: ${referencia.path}");

      await referencia.delete();
      //DELETANDO DA LISTA PRINCIPAL - FIM
      //DELETANDO DA MINHA LISTA - INICIO
      final referenciaMeusCortes = database
          .collection("meusCortes")
          .doc(authSettings.currentUser!.uid)
          .collection("lista")
          .doc(corte.id);
      print("referenciaMeus: ${referenciaMeusCortes.path}");
      await referenciaMeusCortes.delete();
      //DELETANDO DA MINHA LISTA FIM
      print("Deletamos com sucesso");
    } catch (e) {
      print("Não conseguimos excluir, houve um erro: ${e}");
    }
    notifyListeners();
  }

  Future<void> desmarcarCorteMeus(CorteClass corte) async {
    try {
      final referenciaMeusCortes = database
          .collection("meusCortes")
          .doc(authSettings.currentUser!.uid)
          .collection("lista")
          .doc(corte.id);
      print("referenciaMeus: ${referenciaMeusCortes.path}");
      await referenciaMeusCortes.delete();
      _historyList.removeWhere((item) => item.id == corte.id);
      _cortesController.add(_historyList);

      print("Deletamos com sucesso o do MeusCortes");
    } catch (e) {
      print("Não conseguimos excluir, houve um erro: ${e}");
    }
    notifyListeners();
  }

  Future<void> desmarcarAgendaManager(CorteClass corte) async {
    try {
      final referenciaMeusCortes = database
          .collection("allCuts")
          .doc(corte.NomeMes)
          .collection("${corte.DiaDoCorte}")
          .doc(corte.id);
      print("referenciaMeus: ${referenciaMeusCortes.path}");
      await referenciaMeusCortes.delete();
      _historyList.removeWhere((item) => item.id == corte.id);
      _cortesController.add(_historyList);

      print("Deletamos com sucesso o do MeusCortes");
    } catch (e) {
      print("Não conseguimos excluir, houve um erro: ${e}");
    }
    notifyListeners();
  }
}

//load dos cortes do usuario, e eadicionando a uma list - FIM
