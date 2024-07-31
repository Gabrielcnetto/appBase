import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeSubscriptions with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseAuth.instance;
  String chavePublicavel =
      'pk_live_51PhN0AJbuFc8lkJcbRa8cs7RwiwCSYLDN9t0fYZBDzPljS3IZdjsjLnXdfySp6ag69vuah4kvBkEvrwaVpqvgi1700YJEUalH6';
  String chaveSecreta =
      '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';
  final StripeChama = Stripe.instance;

  Future<Map<String, dynamic>> createCustomer(String email) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<Map<String, dynamic>> createPrice(double amount) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/prices'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'unit_amount': amount.toString(),
        'currency': 'BRL',
        'recurring[interval]': 'month',
        'product_data[name]': 'Monthly Subscription',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create price');
    }
  }

  Future<Map<String, dynamic>> createSubscription(
      String customerId, String priceId) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/subscriptions'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'customer': customerId,
        'items[0][price]': priceId,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create subscription');
    }
  }

  Future<Map<String, dynamic>> attachPaymentMethod(
      String customerId, String paymentMethodId) async {
    final response = await http.post(
      Uri.parse(
          'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'customer': customerId,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to attach payment method');
    }
  }

  Future<void> createAndSubscribeCustomer(
      String email, double amount, PaymentMethod paymentMethod) async {
    final customer = await createCustomer(email);
    final customerId = customer['id'];

    await attachPaymentMethod(customerId, paymentMethod.id!);

    await http.post(
      Uri.parse('https://api.stripe.com/v1/customers/$customerId'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'invoice_settings[default_payment_method]': paymentMethod.id!,
      },
    );

    final price = await createPrice(amount);
    final priceId = price['id'];

    await createSubscription(customerId, priceId);
  }

  //parte do banco de dados onde envia ao usuario que ele tem um bool positivo para assinatura

  Future<void> enviarAssinaturaAtivaAoBancodeDados({required String tipoassinatura}) async {
    final userid = await authSettings.currentUser!.uid;
    try{
      final postSignature = await database.collection('usuarios').doc(userid).update({
        'assinatura': true,
        'tipo_assinatura': tipoassinatura,
      });
    }catch(e){
      print('ao enviar bool deu isto:$e');
    }
  }
}
