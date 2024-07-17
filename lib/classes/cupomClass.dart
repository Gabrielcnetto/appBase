class cupomClass {
  final String name;
  final String id;
  final String horario;
  final bool isActive;
  final String codigo;

  final int percentage;
  cupomClass({
    required this.codigo,
    required this.name,
    required this.horario,
    required this.id,
    required this.isActive,
    required this.percentage,
  });
}

List<cupomClass> listaTeste = [
  cupomClass(
    codigo: "#PROMO15",
    name: "manhã barata",
    horario: "08:30",
    id: "",
    isActive: true,
    percentage: 30,
  ),
   cupomClass(
    codigo: "#PROMO30",
    name: "Tarde barata",
    horario: "14:30",
    id: "",
    isActive: true,
    percentage: 20,
  ),
];
