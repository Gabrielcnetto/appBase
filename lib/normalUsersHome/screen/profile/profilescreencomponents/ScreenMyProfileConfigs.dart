import 'dart:convert';
import 'dart:io';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lionsbarberv1/classes/Estabelecimento.dart';
import 'package:lionsbarberv1/functions/StripeCobrancas.dart';
import 'package:lionsbarberv1/functions/userLogin.dart';
import 'package:lionsbarberv1/rotas/Approutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../../functions/profileScreenFunctions.dart';

class ScreenComponentsMyProfile extends StatefulWidget {
  const ScreenComponentsMyProfile({super.key});

  @override
  State<ScreenComponentsMyProfile> createState() =>
      _ScreenComponentsMyProfileState();
}

class _ScreenComponentsMyProfileState extends State<ScreenComponentsMyProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<MyProfileScreenFunctions>(context, listen: false).getUserName();
    Provider.of<MyProfileScreenFunctions>(context, listen: false).getPhone();
    phoneNumber;
    userName;
    urlImagePhoto;
    loadUserPhone();
    loadUserName();
    urlImageFuncion();
    setState(() {});
  }

  Future<void> setandonewnome() async {
    setState(() {});
    Provider.of<MyProfileScreenFunctions>(context, listen: false).newName(
      newName: nomeControler.text,
    );
    setState(() {});
  }

  Future<void> setandoPhone() async {
    setState(() {});
    Provider.of<MyProfileScreenFunctions>(context, listen: false).setPhone(
      phoneNumber: phoneNumberControler.text,
    );
    setState(() {});
  }

  //GET USERNAME - INICIO
  String? userName;
  Future<void> loadUserName() async {
    String? usuario = await MyProfileScreenFunctions().getUserName();

    if (userName != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      userName = usuario;
      setInControler();
    });
  }

  void setInControler() {
    nomeControler.text = userName!;
  }

  //GET USERNAME - FINAL
  //GET NUMERO - INCIO
  String? phoneNumber;
  Future<void> loadUserPhone() async {
    String? number = await MyProfileScreenFunctions().getPhone();

    if (phoneNumber != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      phoneNumber = number;
      setPhone();
    });
  }

  void setPhone() {
    phoneNumberControler.text = phoneNumber!;
  }

  //GET NUMERO - FINAL
  final nomeControler = TextEditingController();
  final phoneNumberControler = TextEditingController();

  //funcao geral de enviar ao db a foto nova
  void showModalPhtoNew() {
    setState(() {});
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    "imagesOfApp/shine.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Sua foto de perfil foi Atualizada!",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Uhuu! Vamos ver como ficou sua nova foto?\nEla pode levar até 5 segundos para atualizar!",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 80, left: 20, right: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Estabelecimento.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Voltar ao perfil",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Estabelecimento.contraPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> setNewimageOnDB() async {
    setState(() {});
    final String photo = await image!.path;
    try {
      if (photo != null) {
        showModalPhtoNew();
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .setImageProfile(
          urlImage: File(photo),
        );
      }
    } catch (e) {
      print("erro: $e");
    }
  }

  //GET IMAGEM DO PERFIL - INICIO(CAMERA)
  XFile? image;

  Future<void> getProfileImageCamera() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      image = pickedFile;
    });
    await setNewimageOnDB();
  }

  //GET IMAGEM DO PERFIL - FINAL(CAMERA)
  Future<void> getProfileImageBiblio() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      image = pickedFile;
    });
    await setNewimageOnDB();
  }
  //final biblioteca

  //get da imagem de perfil
  String? urlImagePhoto;
  Future<void> urlImageFuncion() async {
    String? number = await MyProfileScreenFunctions().getUserImage();

    if (urlImagePhoto != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      urlImagePhoto = number;
      setPhone();
    });
  }

  //FUNCOES DE PAGAMENTO NA STRIPE - INICIO
  Map<String, dynamic>? paymentIntent;
  void makePayment() async {
    List<ApplePayCartSummaryItem> lista = [
      ApplePayCartSummaryItem.immediate(
        label: 'item1',
        amount: '99',
        isPending: false,
      ),
    ];

    try {
      paymentIntent = await createPaymentIntent();
      print('print777: ${paymentIntent}');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: "${Estabelecimento.nomeLocal}",
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
          customerId: paymentIntent!['customer'],
          // Extra options
          applePay: PaymentSheetApplePay(
            merchantCountryCode: 'BR',
            buttonType: PlatformButtonType.buy,
            cartItems: lista,
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'BR',
            currencyCode: 'BRL',
            buttonType: PlatformButtonType.buy,
            testEnv: true,
          ),
          style: ThemeMode.light,
        ),
      );
      await displayPaymentSheet();
    } catch (e) {
      print("houve um erro no display: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro"),
            content: Text("Houve um erro no pagamento: $e"),
            actions: [
              TextButton(
                child: Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          Future.delayed(Duration(milliseconds: 4000), () {
            Navigator.pop(ctx);
          });
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'imagesOfApp/Confirmpay.gif',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Text(
                      'UHUUU! Pagamento Confirmado',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
      print("ok, done");
    } catch (e) {
      print("houve um erro no display: $e");
    }
  }

  createPaymentIntent() async {
    String myToken =
        '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';
    try {
      Map<String, dynamic> body = {
        "amount":
            "100", //colocar *centavos para um valor de R$ 99,00, você deve enviar 9900 centavos.
        "currency": "BRL",
      };
      var CreateResponse = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            "Authorization": "Bearer $myToken",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      return jsonDecode(CreateResponse.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //FUNCOES DE PAGAMENTO NA STRIPE - INICIO
  @override
  Widget build(BuildContext context) {
    final widhScren = MediaQuery.of(context).size.width;
    final heighScreen = MediaQuery.of(context).size.height;
    return Container(
      width: widhScren,
      height: heighScreen,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //HEADER - incio
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, ${userName ?? 'Carregando...'}! ',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.front_hand,
                              color: Color.fromARGB(255, 246, 206, 5),
                            )
                          ],
                        ),
                        Text(
                          'Configure seu perfil aqui',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: widhScren * 0.12,
                      height: heighScreen * 0.07,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          '${urlImagePhoto ?? Estabelecimento.defaultAvatar}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //header fim
              //BLOCO DO SALDO - INICIO
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'R\$ 129,00',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Saldo para pagamentos',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.visibility,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Adicione Créditos',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pague 100% online',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //BLOCO DO SALDO - FIM
              //BLOCO DAS CONFIGURAÇOES - INICIO
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Colors.grey.shade200,
                      ),
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  width: widhScren,
                  child: Column(
                    children: [
                      //EDITAR O NOME DO PERFIL - INCIO
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Estabelecimento.primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    ' Editar nome',
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //EDITAR O NOME DO PERFIL - FIM
                      //editar a foto - inicio
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Estabelecimento.primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    ' Editar foto de perfil',
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //editar a foto - fim
                      //salvar telefone - inicio
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Estabelecimento.primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    ' Salvar telefone(recomendado)',
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //salvar telefone - fim
                      //BLOCO DAS CONFIGURACOES - FIM
                      //configuracoes gerais - inicio
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Estabelecimento.primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    ' Configurações gerais',
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //configuracoes gerais - fim
                    ],
                  ),
                ),
              ),
              //BLOCO DAS ASSINATURAS
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Corte 1x por semana',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Pague somente 1x ao mês no crédito',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
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
    );
  }
}
