import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeCobrancasProvider with ChangeNotifier {
  String chavePublicavel =
      'pk_live_51PhN0AJbuFc8lkJcbRa8cs7RwiwCSYLDN9t0fYZBDzPljS3IZdjsjLnXdfySp6ag69vuah4kvBkEvrwaVpqvgi1700YJEUalH6';
  String chaveSecreta =
      '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';
  final StripeChama = Stripe.instance;


}
