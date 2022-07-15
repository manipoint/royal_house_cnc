import 'package:amazon_clone/pages/address/services/address_service.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/util/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../../../.env.example.dart';
import '../../../util/widgets/bottom_bar.dart';
import 'app_scaffold.dart';
import 'loading_button.dart';

class PaymentSheetScreen extends StatefulWidget {
  static const String routeName = '/payment';
  final int amount;
  const PaymentSheetScreen({super.key, required this.amount});
  @override
  State<PaymentSheetScreen> createState() => _PaymentSheetScreenState();
}

class _PaymentSheetScreenState extends State<PaymentSheetScreen> {
  int step = 0;

  AddressService addressService = AddressService();
  void navigateToHome() {
    Navigator.restorablePushNamedAndRemoveUntil(
        context, BottomBar.routeName, (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = stripePublishableKey;
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Payment Sheet',
      tags: const ['Single Step'],
      children: [
        Stepper(
          controlsBuilder: emptyControlBuilder,
          currentStep: step,
          steps: [
            Step(
              title: Text("Pay ${widget.amount}"),
              content: LoadingButton(
                onPressed: initPaymentSheet,
                text: 'Init payment sheet',
              ),
            ),
            Step(
              title: const Text('Confirm payment'),
              content: LoadingButton(
                onPressed: confirmPayment,
                text: 'Pay now',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> initPaymentSheet() async {
    try {
      final userProvide = Provider.of<UserProvider>(context, listen: false);
      int amountToPay = widget.amount;
      // 1. create payment intent on the server
      final data = await addressService.paymentSheet(
          context: context, amount: amountToPay);

      // create some billing details
      final billingDetails = BillingDetails(
        name: userProvide.user.name,
        email: userProvide.user.email,
        phone: "+923209509822",
        address: Address(
          city: userProvide.user.address!.city,
          country: userProvide.user.address!.country,
          line1: userProvide.user.address!.line1,
          line2: userProvide.user.address!.line2,
          state: userProvide.user.address!.state,
          postalCode: userProvide.user.address!.postalCode,
        ),
      ); // mocked data for tests

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: data['paymentIntent'],
          merchantDisplayName: 'Royal house',
          // Customer params
          customerId: data['customer'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          // Extra params
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Colors.lightBlue,
              primary: Colors.blue,
              componentBorder: Colors.red,
            ),
            shapes: PaymentSheetShape(
              borderWidth: 4,
              shadow: PaymentSheetShadowParams(color: Colors.red),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color.fromARGB(255, 231, 235, 30),
                  text: Color.fromARGB(255, 235, 92, 30),
                  border: Color.fromARGB(255, 235, 92, 30),
                ),
              ),
            ),
          ),
          billingDetails: billingDetails,
          testEnv: true,
          merchantCountryCode: 'DE',
        ),
      );
      setState(() {
        step = 1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> confirmPayment() async {
    double totalSum = double.parse(widget.amount.toString());
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet().then((value) async {
        setState(() {
          step = 0;
        });
        await showSnackBar(context, 'Payment successfully completed');
        await addressService
            .placeOrder(context: context, totalSum: totalSum)
            .then((value) => navigateToHome());
      });
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: $e'),
          ),
        );
      }
    }
  }
}

final ControlsWidgetBuilder emptyControlBuilder = (_, __) => Container();
