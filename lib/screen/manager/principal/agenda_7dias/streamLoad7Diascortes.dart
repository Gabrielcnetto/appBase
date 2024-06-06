import 'package:barbershop2/classes/cortecClass.dart';
import 'package:barbershop2/functions/managerScreenFunctions.dart';
import 'package:barbershop2/screen/manager/principal/agenda_7dias/corte7diasItem.dart';
import 'package:barbershop2/screen/manager/principal/agenda_7dias/semItems.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreamLoad7dias extends StatefulWidget {
  const StreamLoad7dias({super.key});

  @override
  State<StreamLoad7dias> createState() => _StreamLoad7diasState();
}

class _StreamLoad7diasState extends State<StreamLoad7dias> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<ManagerScreenFunctions>(context, listen: true)
          .CorteslistaManager,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.data!.isEmpty) {
          return Container(
            child: const SemItens(),
          );
        } else if (snapshot.hasData) {
          final List<CorteClass>? cortes = snapshot.data;
          return Corte7DiasItem(
            corte: cortes!,
          );
        }
        return Container();
      },
    );
  }
}
