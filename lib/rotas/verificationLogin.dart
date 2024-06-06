import 'package:barbershop2/rotas/Approutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationLoginScreen01 extends StatelessWidget {
  const VerificationLoginScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snpshot) {
        if (snpshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snpshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed(
             AppRoutesApp.HomeScreen01
            );
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed(AppRoutesApp.InitialScreenApp);
          });
        }
        return Container();
      },
    );
  }
}
