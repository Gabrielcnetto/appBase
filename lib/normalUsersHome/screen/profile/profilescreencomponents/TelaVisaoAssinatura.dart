import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/functions/stripe_subscriptions.dart';
import 'package:provider/provider.dart';

class TelaVisaoAssinaturaPagamento extends StatefulWidget {
  const TelaVisaoAssinaturaPagamento({super.key});

  @override
  State<TelaVisaoAssinaturaPagamento> createState() =>
      _TelaVisaoAssinaturaPagamentoState();
}

class _TelaVisaoAssinaturaPagamentoState
    extends State<TelaVisaoAssinaturaPagamento> {
  CardFieldInputDetails? _cardDetails;
  Future<void> subscriberUser() async {
    try {
      if (_cardDetails == null || !_cardDetails!.complete) {
        print('Card details not complete');
        return;
      }
      final billingDetails = BillingDetails(
        address: Address(
          city: 'parobé',
          country: 'Brasil',
          line1: 'maria de l',
          line2: '',
          postalCode: '95630000',
          state: 'Rio Grande do sul',
        ),
        email: 'gabrielcarlosnettoo@gmail.com', // Email do cliente
        name: 'Gabriel Netto',
        phone: '+5551983448088',
      );
      final payMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );
      String email = 'gabrielcarlosnettoo@gmail.com'; // Email do cliente
      int amount = 9900;
      await Provider.of<StripeSubscriptions>(context, listen: false)
          .createAndSubscribeCustomer(email, amount, payMethod);
      print('#uhs: Subscription successful');
    } catch (e) {
      print('#uhs:houve um erro ao criar um subscriber: ${e}');
    }
  }
  bool horarioFixo = false;
  bool creditos = false;

  void setTrueHorarioFixo(){
    if(horarioFixo == true){
      setState(() {
        horarioFixo = false;
        creditos = false;
      });
    } else if(horarioFixo == false){
      setState(() {
        horarioFixo = true;
        creditos = false;
      });
    }
  }
  void setTrueCreditos(){
    if(creditos == true){
      setState(() {
        creditos = false;
        horarioFixo = false;
      });
    } else if(creditos == false){
      setState(() {
        creditos = true;
        horarioFixo = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Assinatura',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Agende 1x por semana, Ganhe 4 créditos para agendar nos horários que desejar durante o mês, ou escolhe um dia e horário fixo',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'R\$ ',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '899,00',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '/mês',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green.shade800,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Pule a fila',
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green.shade800,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '1x por semana',
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              //
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green.shade800,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Crédito',
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    //
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green.shade800,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Decida e vá',
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Qual a maneira que você prefere?',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: setTrueHorarioFixo,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 30, horizontal: 5),
                                    alignment: Alignment.center,
                                    height:
                                        MediaQuery.of(context).size.height * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade600,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Horário Fixo',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Dia da semana e horário fixo',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white54,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Clique para escolher',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: setTrueCreditos,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 30, horizontal: 5),
                                    alignment: Alignment.center,
                                    height:
                                        MediaQuery.of(context).size.height * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade600,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Créditos',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'agende 1x por semana, sempre que desejar',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white54,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Clique para escolher',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //
                      ],
                    ),
                  ),
                ),
                if(horarioFixo == true)
                Text('horário fixo'),
                if(creditos == true)
                Text('créditos')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
