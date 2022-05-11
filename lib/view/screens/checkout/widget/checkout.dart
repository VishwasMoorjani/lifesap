import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckOut extends StatefulWidget {
  final cost;
  const CheckOut(this.cost);
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': num.parse(widget.cost.toString()) * 100,
      'name': 'LIFESAP',
      'description': 'Payment',
      'prefill': {'contact': "", 'email': ""},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: ");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR: ");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Checkout',
            style: TextStyle(fontSize: 20.0, color: Color(0xFF545D68))),
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 20.0),
                  Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Text('Net Charge',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 7, 19, 54))),
                          SizedBox(width: 10.0),
                          Text('INR ${widget.cost} /-',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 77, 51, 165))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          InkWell(
              onTap: () {
                openCheckout();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Container(
                    width: MediaQuery.of(context).size.width - 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Color(0xFFF17532)),
                    child: Center(
                        child: Text('Checkout',
                            style: TextStyle(
                                fontFamily: 'nunito',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)))),
              ))
        ]),
      ),
    );
  }
}
