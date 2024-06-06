import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class Twilio_messagesFunction with ChangeNotifier {
  //classe principal com os dados da minha conta twilio
  final TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC78f5246efce768e4def34ca919bef5d9',
    authToken: '1426cbbebab6ff5b3728cce5be313875',
    twilioNumber: '+5511918838485',
    messagingServiceSid: 'MG5e9904ae446f79b1af5ae64b9e5ac381',
  );
  //funcao do whatsapp
  Future<void> sendWhatsMessage({required String numberPhone}) async {
    try {
      String cleanedNumber = numberPhone.replaceAll(RegExp(r'^\+?55|\-'), '');
      await twilioFlutter.sendWhatsApp(
        toNumber:
            '+55$cleanedNumber', // replace with Mobile Number(With country code)
        messageBody:
            "Olá! 🪒✂️ Tudo certo! Recebemos a confirmação do seu agendamento para o corte. Aguardamos você na data marcada. Até breve!",
      );
      print("enviando mensagem para o whatsapp");
    } catch (e) {
      print("nao enviamos mensagem no whatsapp pois deu este erro:${e}");
    }
  }

  //Funcao de enviar com uma data pré programada no app
  Future<void> agendarMensagemWhatsApp({
    required String numberPhone,
    required DateTime dataFinal,
  }) async {
    DateTime horaAtrasada = dataFinal.subtract(Duration(hours: 1));
    String dataFormatFinal =
        await horaAtrasada.toIso8601String().split('.')[0] + 'Z';
              String cleanedNumber = numberPhone.replaceAll(RegExp(r'^\+?55|\-'), '');

    try {
      await twilioFlutter.sendScheduledWhatsAppMessage(
        toNumber: '+55$cleanedNumber',
        messageBody:
            "Olá! Só uma rápida lembrança: você tem um compromisso marcado na barbearia daqui a uma hora. Tudo certo com o seu horário? Se por algum motivo não puder comparecer, por favor, cancele pelo app ou entre em contato. Obrigado!",
        sendAt: dataFormatFinal,
      );
      print("a hora foi agendada no dia: ${dataFormatFinal}");
    } catch (e) {
      print("Erro ao agendar mensagem do WhatsApp: $e");
    }
  }

  //tela do profissional
  Future<void> sendWhatsMessageLembrete({required String numberPhone}) async {
    try {
      String cleanedNumber = numberPhone.replaceAll(RegExp(r'^\+?55|\-'), '');
      await twilioFlutter.sendWhatsApp(
        toNumber:
            '+55$cleanedNumber', // replace with Mobile Number(With country code)
        messageBody:
            "Ei! Vi que você atrasou um pouco do horário da agenda na barbearia. O que você acha de remarcar? 😁",
      );
      print("enviando mensagem para o whatsapp");
    } catch (e) {
      print("nao enviamos mensagem no whatsapp pois deu este erro:${e}");
    }
  }
}
