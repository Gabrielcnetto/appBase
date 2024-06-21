import 'package:flutter/material.dart';
import 'package:lionsbarberv1/classes/horarios.dart';

class AgendaData with ChangeNotifier {
  double _linhaPosicao = 0;

  double get linhaPosicao => _linhaPosicao;

  void atualizarLinhaPosicao(
 {
   required double linhaAltura,
  required List<Horarios> listaHorarios,
 }
) {
  // Calcular a nova posição da linha com base no tempo atual
  final now = DateTime.now();
  final horaAtual = now.hour;
  final minutoAtual = now.minute;

  // Definir horário inicial e final para a linha animada
  final int horaInicio = 8;  // 08:00
  final int horaFim = 20;    // 20:00

  // Verificar se está dentro do horário permitido
  if (horaAtual < horaInicio || horaAtual >= horaFim) {
    // Fora do horário permitido, manter a linha no topo
    _linhaPosicao = 0;
  } else {
    // Encontrar o primeiro horário válido na lista
    Horarios? horarioInicial;
    for (final horario in listaHorarios) {
      final horarioSplit = horario.horario.split(':');
      final hora = int.parse(horarioSplit[0]);
      final minuto = int.parse(horarioSplit[1]);
      
      // Comparar com o horário atual
      if ((hora > horaAtual || (hora == horaAtual && minuto >= minutoAtual)) && hora >= horaInicio && hora < horaFim) {
        horarioInicial = horario;
        break;
      }
    }

    if (horarioInicial != null) {
      // Calcular a posição da linha com base no horário inicial encontrado
      final horarioSplit = horarioInicial.horario.split(':');
      final horaSelecionada = int.parse(horarioSplit[0]);
      final minutoSelecionado = int.parse(horarioSplit[1]);
      
      final posicaoLinha = (horaSelecionada * 60 + minutoSelecionado) * linhaAltura / (24 * 60);

      // Atualizar a propriedade linhaPosicao e notificar listeners
      _linhaPosicao = posicaoLinha;
    } else {
      // Caso não encontre nenhum horário válido na lista, manter a linha no topo
      _linhaPosicao = 0;
    }
  }

  notifyListeners();
}

  void resetLinhaPosicao() {
    // Resetar a posição da linha para o topo
    _linhaPosicao = 0.0;
    notifyListeners();
  }
}
