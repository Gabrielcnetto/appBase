import 'package:lionsbarberv1/classes/horarios.dart';

class CorteClass {
  final String id;
  final bool isActive;
  final String clientName;
  final String numeroContato;
  final bool barba;
  final int DiaDoCorte;
  final String NomeMes;
  final DateTime diaCorte;
  final int ramdomCode;
  final String horarioCorte;
  final String profissionalSelect;
  final DateTime dateCreateAgendamento;
  final int totalValue;
  final List<String> horariosExtra;
  CorteClass({
    required this.isActive,
    required this.DiaDoCorte,
    required this.clientName,
    required this.totalValue,
    required this.NomeMes,
    required this.id,
    required this.numeroContato,
    required this.profissionalSelect,
    required this.diaCorte,
    required this.horarioCorte,
    required this.barba,
    required this.ramdomCode,
    required this.dateCreateAgendamento,
    required this.horariosExtra,
  });
}

class CorteClassEmpty extends CorteClass {
  CorteClassEmpty()
      : super(
          DiaDoCorte: 0,
          NomeMes: "",
          barba: false,
          clientName: "",
          dateCreateAgendamento: DateTime.now(),
          diaCorte: DateTime.now(),
          horarioCorte: "",
          horariosExtra: [],
          id: "",
          isActive: false,
          numeroContato: "",
          profissionalSelect: "",
          ramdomCode: 0,
          totalValue: 0,
        );
}
