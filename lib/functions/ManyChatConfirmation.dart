import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ManyChatConfirmation with ChangeNotifier {
  //ADICIONANDO O CONTATO

  Future<void> setClientsManyChat({
    required String userPhoneNumber,
    required String username,
    required int externalId,
  }) async {
    String cleanedNumber = userPhoneNumber.replaceAll(RegExp(r'^\+?55|\-'), '');
    var createSubscriberUrl =
        Uri.parse("https://api.manychat.com/fb/subscriber/createSubscriber");
    var myManyToken = "1438889:178a28fe8cd1db32c7fbd2e27a0c4415";

    // Dados do assinante a serem enviados
    var subscriberData = {
      "phone": "+55$cleanedNumber",
      "whatsapp_phone": "+55$cleanedNumber",
      "first_name": username,
      "external_id": externalId.toString(),
      "has_opt_in_sms": true,
      "has_opt_in_email": true,
      "consent_phrase": "I accept receiving messages"
    };

    try {
      // Criar um novo assinante
      var createResponse = await http.post(
        createSubscriberUrl,
        headers: {
          
          "Authorization": "Bearer $myManyToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(subscriberData),
      );

      if (createResponse.statusCode == 200) {
        var createResponseBody = jsonDecode(createResponse.body);
        var subscriberId = createResponseBody['data']['id'];
        await saveContactID(
            phoneNumber: userPhoneNumber, subscriber_id: subscriberId);
        // Assinante criado com sucesso, agora você pode adicionar tags, enviar mensagens, etc.
        print("Assinante criado com sucesso. ID: $subscriberId");
      } else {
        // Tratamento de erro caso o assinante já exista
        if (createResponse.statusCode == 400) {
          var responseBody = jsonDecode(createResponse.body);
          var errorMessage = responseBody['message'];
          print(errorMessage);
          try {
            if (errorMessage == "Validation error") {
              await UserExistButSendConfirmation(phoneNumber: userPhoneNumber);
            }
          } catch (e) {
            print("erro maior, nao executamos");
          }
        } else {
          print(
              "Erro ao criar assinante no ManyChat. Código de status: ${createResponse.statusCode}");
          print("Corpo da resposta: ${createResponse.body}");
        }
      }
    } catch (e) {
      print("Houve um erro geral: $e");
    }
  }

  Future<void> UserExistButSendConfirmation({
    required String phoneNumber,
  }) async {
    final getSubscriberId =
        await database.collection("ManyChatids").doc(phoneNumber).get();
    try {
      if (getSubscriberId.exists) {
        var subId = await getSubscriberId.data()?["subscriber_id"];
        var myManyToken = "1438889:178a28fe8cd1db32c7fbd2e27a0c4415";
        List<String> tag = await getTagsSystem(contactId: subId);
        List<String>? userTag =
            await fetchTags(userId: subId); // Change to nullable
        print("a tag que deveria ser usada é esta: ${tag[0]}");

        // Check if userTag is null or empty
        if (userTag == null || userTag.isEmpty || userTag[0] == null) {
          print("Não há tag definida para este usuário.");
          print("A tag que vamos adicionar será esta: ${tag[0]}");
          print("Não tem tag, vamos enviar.");

          String tagUrl = "https://api.manychat.com/fb/subscriber/addTag";

          // Corpo da requisição
          Map<String, dynamic> body = {
            'subscriber_id': subId,
            'tag_id': tag[0],
          };

          // Headers da requisição
          Map<String, String> headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $myManyToken',
          };

          String jsonBody = jsonEncode(body);

          try {
            print("Fazendo o post da tag.");
            final response = await http.post(
              Uri.parse(tagUrl),
              headers: headers,
              body: jsonBody,
            );

            if (response.statusCode == 200) {
              print('Tag atribuída com sucesso ao contato $subId.');
            } else {
              print(
                  'Erro ao atribuir tag ao contato $subId. Status code: ${response.statusCode}');
              print('Response body: ${response.body}');
            }
          } catch (e) {
            print("Ao enviar a tag ao usuário, ocorreu o seguinte erro: $e");
          }
        } else {
          removetag(
            tagId: tag[0],
            userId: subId,
          );
          print("Tinha tag atribuída, então foi removida.");
        }
      }
    } catch (e) {
      print("Problemas na função da tag, ocorreu o seguinte erro: $e");
    }
  }

  Future<List<String>> getTagsSystem({required String contactId}) async {
    String url = 'https://api.manychat.com/fb/page/getTags';
    String apiKey = '1438889:178a28fe8cd1db32c7fbd2e27a0c4415';

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta de JSON para um mapa (Map<String, dynamic>)
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        // Verifica se a chave 'data' existe no mapa
        if (data.containsKey('data')) {
          print("existe data");
          // Extrai a lista de tags do campo 'data' da resposta
          List<dynamic> tags = data['data'];

          // Mapeia as tags para obter apenas os nomes
          List<String> tagNames =
              tags.map((tag) => tag['id'].toString()).toList();
          print("tagsNames $tagNames");
          // Retorna a lista de nomes das tags
          return tagNames;
        } else {
          // Se 'data' não estiver presente na resposta
          print('Resposta da API não contém o campo "data"');
          return [];
        }
      } else {
        // Se a requisição não for bem sucedida, imprime o código de status
        print('Erro de requisição: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Captura e imprime quaisquer exceções que ocorram durante a requisição
      print("Erro geral na função: $e");
      return [];
    }
  }

  //pegando as tags que ja tem no user
  Future<List<String>> fetchTags({required String userId}) async {
    String url =
        'https://api.manychat.com/fb/subscriber/getInfo?subscriber_id=$userId';
    String accessToken = '1438889:178a28fe8cd1db32c7fbd2e27a0c4415';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('data')) {
          // Acessa o array de tags dentro de 'data'
          List<dynamic> tagsData = data['data']['tags'];

          if (tagsData is List) {
            List<String> tagNames =
                tagsData.map((tag) => tag['id'].toString()).toList();
            return tagNames;
          } else {
            print('O campo "tags" na resposta da API não é uma lista');
            return [];
          }
        } else {
          print('Resposta da API não contém o campo "data"');
          return [];
        }
      } else {
        print('Erro de requisição: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print("Erro geral na função: $e");
      return [];
    }
  }

  //removendo a tag caso preciso:
  Future<void> removetag(
      {required String userId, required String tagId}) async {
    String url = 'https://api.manychat.com/fb/subscriber/removeTag';
    String accessToken = '1438889:178a28fe8cd1db32c7fbd2e27a0c4415';
    try {
      var subscriberData = {
        "subscriber_id": userId,
        "tag_id": tagId,
      };

      var createResponse = await http.post(
        Uri.parse(url),
        headers: {
          
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(subscriberData),
      );
    } catch (e) {
      print("ao remover a tag aconteceu isto: $e");
    }
  }

  //Caso for um usuario novo, também armazenando o id dele no firebase:
  final firebaseAuth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;
  Future<void> saveContactID(
      {required String phoneNumber, required String subscriber_id}) async {
    final sendIdFirebase =
        await database.collection("ManyChatids").doc(phoneNumber).set({
      "subscriber_id": subscriber_id,
    });
  }

  Future<void> sendLembreteParaAtrasados({
    required String phoneNumber,
  }) async {
    String url = "https://api.manychat.com/fb/subscriber/setCustomFields";
    String accessToken = '1438889:178a28fe8cd1db32c7fbd2e27a0c4415';
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'^\+?55|\-'), '');

    //
    final getSubscriberId =
        await database.collection("ManyChatids").doc(cleanedNumber).get();
    var subId = await getSubscriberId.data()?["subscriber_id"];
    print("o aid do user é ${subId}");
    try {
      var subscriberData = {
        "subscriber_id": subId,
        "fields": [
          {
            "field_id": 11268302,
            "field_name": "ramdomText_lembrete",
            "field_value": "${Random().nextDouble().toString()}"
          }
        ]
      };
      var jsonBody = await jsonEncode(subscriberData);
      var createResponse = await http.post(
        Uri.parse(url),
        body: jsonBody,
        headers: {
          
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      print("o bool foi enviado");
    } catch (e) {
      print("ao enviar o lembrete pelo bool, deu este erro: $e");
    }
  }

  Future<void> ScheduleMessage({
    required String phoneNumber,
    required DateTime finalDate,
  }) async {
    String url = "https://api.manychat.com/fb/subscriber/setCustomFields";
    String accessToken = '1438889:178a28fe8cd1db32c7fbd2e27a0c4415';
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'^\+?55|\-'), '');

    try {
      // Obter o subscriber_id do banco de dados
      final getSubscriberId =
          await database.collection("ManyChatids").doc(cleanedNumber).get();
      var subId = await getSubscriberId.data()?["subscriber_id"];
      print("Schd: o subs id é ${subId}");

      // Formatando a data para o formato desejado (YYYY-MM-DDTHH:MM:SSZ)
      DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss+00:00");
      DateTime horaAtrasada = finalDate.subtract(const Duration(hours: 1));
      String formattedDate = dateFormat.format(horaAtrasada.toUtc());
      print("a hora ficou: ${formattedDate}");
      var subscriberData = {
        "subscriber_id": subId,
        "fields": [
          {
            "field_id": 11266886,
            "field_name": "ReminderTime",
            "field_value": formattedDate, // Usar a data formatada
          }
        ]
      };

      var jsonBody = jsonEncode(subscriberData);
      var createResponse = await http.post(
        Uri.parse(url),
        body: jsonBody,
        headers: {
          
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (createResponse.statusCode == 200) {
        print("Schd: a data foi enviada com sucesso.");
      } else {
        print(
            "Schd: não foi possível enviar a data. Status code: ${createResponse.statusCode}");
      }
    } catch (e) {
      print("Schd: houve um erro ao enviar a data: $e");
    }
  }
}
