import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/classes/horarios.dart';
import 'package:lionsbarberv1/functions/stripe_subscriptions.dart';
import 'package:provider/provider.dart';

class TelaVisaoAssinaturaPagamento extends StatefulWidget {
  final double valorAssinatura;
  const TelaVisaoAssinaturaPagamento({
    super.key,
    required this.valorAssinatura,
  });

  @override
  State<TelaVisaoAssinaturaPagamento> createState() =>
      _TelaVisaoAssinaturaPagamentoState();
}

class _TelaVisaoAssinaturaPagamentoState
    extends State<TelaVisaoAssinaturaPagamento> {
  CardFieldInputDetails? _cardDetails;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> subscriberUser() async {
    //if (!_formKey.currentState!.validate()) {
    //  return;
    // }
    try {
      if (_cardDetails == null || !_cardDetails!.complete) {
        print('Card details not complete');
        return;
      }
      final billingDetails = BillingDetails(
        address: Address(
          city: 'parobé',
          country: 'BR',
          line1: 'maria de l',
          line2: '',
          postalCode: '95630000',
          state: 'RS',
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
      double amount = widget.valorAssinatura;
      await Provider.of<StripeSubscriptions>(context, listen: false)
          .createAndSubscribeCustomer(email, amount, payMethod);
      print('#uhs: Subscription successful');

      await Provider.of<StripeSubscriptions>(context,listen: false).enviarAssinaturaAtivaAoBancodeDados(tipoassinatura: horarioFixo == true ? 'horarioFixo' : 'creditosLivre');
    } catch (e) {
      print('#uhs:houve um erro ao criar um subscriber: ${e}');
    }
  }

  bool horarioFixo = false;
  bool creditos = false;

  void setTrueHorarioFixo() {
    if (horarioFixo == true) {
      setState(() {
        horarioFixo = false;
        creditos = false;
      });
    } else if (horarioFixo == false) {
      setState(() {
        horarioFixo = true;
        creditos = false;
      });
    }
  }

  void setTrueCreditos() {
    if (creditos == true) {
      setState(() {
        creditos = false;
        horarioFixo = false;
      });
    } else if (creditos == false) {
      setState(() {
        creditos = true;
        horarioFixo = false;
      });
    }
  }

  List<String> _DiaSemana = [
    'SEG',
    'TER',
    'QUA',
    'QUI',
    'SEX',
    'SAB',
  ];
  int selectedIndex = -1;
  String? diaSelecionado;

  String? hourSetForUser;
  List<Horarios> horarioFinal = [];
  void setList() {
    if (diaSelecionado == 'SEG' ||
        diaSelecionado == 'TER' ||
        diaSelecionado == 'QUA' ||
        diaSelecionado == 'QUI' ||
        diaSelecionado == 'SEX') {
      setState(() {
        horarioFinal = hourLists;
      });
    } else {
      setState(() {
        horarioFinal = sabadoHorarios;
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
                          'Escolha a maneira que mais combina com você, Rotina agitada? Tenha sempre 1 horário fixo ou agende pelo app sempre que quiser sem pagar além da mensalidade',
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
                              '${widget.valorAssinatura.toStringAsFixed(2).replaceAll('.', ',')}',
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
                                        'Quando quiser',
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
                                          'Preço Exclusivo',
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
                          'Qual tipo combina mais com você?',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
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
                                              'Tipo Fixo',
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
                                  onTap: () {
                                    setState(() {
                                      hourSetForUser = null;
                                      diaSelecionado = null;
                                      selectedIndex = -1;
                                    });
                                    setTrueCreditos();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 30, horizontal: 5),
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
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
                                              'Tipo livre',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Não tenha horário fixo, acesse o app e agende',
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
                if (horarioFixo == true)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecione o seu dia e horário fixo',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _DiaSemana.map((item) {
                            // Verifica se o item é o selecionado
                            bool isSelected = item == diaSelecionado;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  diaSelecionado = item;
                                  setList(); // Atualiza a lista conforme o dia selecionado
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.shade600
                                      : Colors.grey
                                          .shade300, // Altere a cor conforme necessário
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text(
                                  item,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors
                                              .black, // Altere a cor do texto conforme necessário
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (horarioFinal!.length > 1)
                          Container(
                            //color: Colors.red,
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: horarioFinal!.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2.3,
                                childAspectRatio: 2.3,
                              ),
                              itemBuilder: (BuildContext ctx, int index) {
                                Color color = selectedIndex == index
                                    ? Colors.blue.shade600
                                    : Estabelecimento.primaryColor;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex =
                                          selectedIndex == index ? -1 : index;

                                      hourSetForUser =
                                          horarioFinal![index].horario;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 3),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.elliptical(20, 20),
                                          bottomRight:
                                              Radius.elliptical(20, 20),
                                          topLeft: Radius.elliptical(20, 20),
                                          topRight: Radius.elliptical(20, 20),
                                        ),
                                        color: color,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "${horarioFinal![index].horario}",
                                        style: GoogleFonts.openSans(
                                            textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 15,
                                        )),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                //
                if (hourSetForUser != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detalhes do cartão',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.3,
                              // color: Colors.red,
                              child: CardFormField(
                                countryCode: 'BR',
                                style: CardFormStyle(
                                  backgroundColor: Colors.black,
                                ),
                                enablePostalCode: false,
                                onCardChanged: (card) {
                                  setState(() {
                                    _cardDetails = card;
                                  });
                                },
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: subscriberUser,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade600,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      'Confirmar assinatura',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (ctx) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 30, horizontal: 30),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 30, horizontal: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Icon(
                                                          Icons.arrow_back_ios,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Voltar',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      'Assinar um plano na ${Estabelecimento.nomeLocal} pelo valor R\$${widget.valorAssinatura.toStringAsFixed(2).replaceAll('.', ',')} permite cortar o cabelo ou quando desejar(Tipo Livre) ou apenas nos horário e dia definido no Tipo Fixo, a ${Estabelecimento.nomeLocal} não é obrigada a fazer procedimentos externos(sem agendameto prévio por mensagem ou agendamento feito pelo app. Para cancelamento, entre em contato com o responsável pela barbearia, e problemas com faturamento entre em contato com o WhatsApp: (51) 9 9328-0162',
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black54,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Veja as regras',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
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
                if (creditos == true)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 30),
                    child: Container(
                      padding: EdgeInsets.only(top: 15),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Como funciona?',
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Text(
                                        'Sempre que quiser, acesse o app e agende um horário, pague apenas a mensalidade e nenhuma difereça a mais pelo procedimento',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    child: Image.asset(
                                      'imagesOfApp/semhistoricodecortes.jpeg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            width: double.infinity,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Detalhes do cartão',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    // color: Colors.red,
                                    child: CardFormField(
                                      countryCode: 'BR',
                                      style: CardFormStyle(
                                        backgroundColor: Colors.black,
                                      ),
                                      enablePostalCode: false,
                                      onCardChanged: (card) {
                                        setState(() {
                                          _cardDetails = card;
                                        });
                                      },
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: subscriberUser,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade600,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            'Confirmar assinatura',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (ctx) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 30,
                                                      horizontal: 30),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 30,
                                                            horizontal: 10),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_back_ios,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Voltar',
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            'Assinar um plano na ${Estabelecimento.nomeLocal} pelo valor R\$${widget.valorAssinatura.toStringAsFixed(2).replaceAll('.', ',')} permite cortar o cabelo ou quando desejar(Tipo Livre) ou apenas nos horário e dia definido no Tipo Fixo, a ${Estabelecimento.nomeLocal} não é obrigada a fazer procedimentos externos(sem agendameto prévio por mensagem ou agendamento feito pelo app. Para cancelamento, entre em contato com o responsável pela barbearia, e problemas com faturamento entre em contato com o WhatsApp: (51) 9 9328-0162',
                                                            style: GoogleFonts
                                                                .openSans(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Veja as regras',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                   
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
