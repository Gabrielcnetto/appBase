
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
  });
}