import 'package:flutter/material.dart';
import 'package:lionsbarberv1/normalUsersHome/screen/profile/profilescreencomponents/ScreenMyProfileConfigs.dart';


class ProfileScreenManagerWithScafol extends StatelessWidget {
  const ProfileScreenManagerWithScafol({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ScreenComponentsMyProfile(),
      ),
    );
  }
}
