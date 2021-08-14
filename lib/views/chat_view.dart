import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String initialCountry = "NG";
  PhoneNumber number = PhoneNumber(isoCode: "NG");
  TextEditingController name = TextEditingController();
  TextEditingController message = TextEditingController();

  openWhatsapp() async {
    var whatsapp = "+234" + name.text;
    var whatsappMessage = message.text;
    var whatsappURLAndroid = "whatsapp://send?"
            "phone=" +
        whatsapp +
        "&text=$whatsappMessage";

    var whatsappIOs = "https://wa.me/$whatsapp?text=${Uri.parse("$message")}";
    if (Platform.isIOS) {
      if (await canLaunch(whatsappIOs)) {
        await launch(whatsappIOs, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No whatsapp")));
      }
    } else {
      if (await canLaunch(whatsappURLAndroid)) {
        await launch(whatsappURLAndroid);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No whatsapp")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2, 2),
              spreadRadius: 2,
              blurRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: name,
              formatInput: false,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                print("on saved $number");
              },
            ),
            TextFormField(
              controller: message,
              maxLines: null,
              decoration: InputDecoration(hintText: "Enter Your message"),
            ),
            ElevatedButton(
              onPressed: () {
                openWhatsapp();
              },
              child: Text("Start Chat"),
            )
          ],
        ),
      ),
    );
  }
}
