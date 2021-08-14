import 'package:ajocard_sales_kit/util/calculator_class.dart';
import 'package:ajocard_sales_kit/util/extras.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CalculatorForm extends StatefulWidget {
  @override
  _CalculatorFormState createState() => _CalculatorFormState();
}

class _CalculatorFormState extends State<CalculatorForm> {
  var calc = Ajo();
  final _formKey = GlobalKey<FormState>();

  String result = "NGN 0.0";
  String radioItem = "";
  TextEditingController cardsController = TextEditingController(text: "0");
  TextEditingController mposController = TextEditingController(text: "0");

  Widget build(BuildContext context) {
    return Container(
        color: Colors.white70,
        padding: const EdgeInsets.all(16.0),
        child: Card(
            child: Form(
                key: _formKey,
                child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
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
                      child: Text(
                        result,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ),
                    cardsMposColumn("Cards",
                        howMany: "How many cards are you purchasing?",
                        controller: cardsController),
                    cardsMposColumn("Mpos",
                        howMany: "how many mpos are you purchasing?",
                        controller: mposController),
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Delivery Options:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        RadioListTile(
                            value: "Within Lagos",
                            title: Text("Within Lagos"),
                            groupValue: radioItem,
                            onChanged: (val) {
                              setState(() {
                                _onChanged(val);
                              });
                            }),
                        RadioListTile(
                            value: "Outside Lagos",
                            groupValue: radioItem,
                            title: Text("Outside Lagos"),
                            onChanged: (val) {
                              setState(() {
                                _onChanged(val);
                              });
                            }),
                        RadioListTile(
                            value: "Onsite Pickup",
                            title: Text("Onsite Pickup"),
                            groupValue: radioItem,
                            onChanged: (val) {
                              setState(() {
                                _onChanged(val);
                              });
                            })
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _calculate();
                                  print(_calculate());
                                }
                              },
                              child: Text("Calculate")),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          child: ElevatedButton(
                              onPressed: () {
                                Share.share(ajocardBankAccount);
                              },
                              child: Text("Share account details")),
                        ),
                      ],
                    ),
                  ],
                ))));
  }

  Widget cardsMposColumn(String key,
      {required String howMany, required TextEditingController controller}) {
    return Container(
      padding: EdgeInsets.all(10),
      //margin: EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            key: Key(key),
            keyboardType: TextInputType.number,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "no value is inserted";
              }
              return null;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: howMany,
                fillColor: Colors.white),
          ),
        ],
      ),
    );
  }

  void _onChanged(value) {
    setState(() {
      radioItem = value;
    });
  }

  _calculate() {
    setState(() {
      var cards = int.parse(cardsController.text);
      var mpos = int.parse(mposController.text);
      var delivery = radioItem;

      result = calc.calculate(m: mpos, c: cards, d: delivery);
    });
  }
}
