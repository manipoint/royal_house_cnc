require("dotenv").config();
var express = require("express");
const Stripe = require("stripe");
const CurrencyConverter = require("currency-converter-lt");

// const stripePublishableKey = process.env.STRIPE_PUBLISHABLE_KEY || "";
// const stripeSecretKey = process.env.STRIPE_SECRET_KEY || "";

const stripeRouter = express.Router();

stripeRouter.post("/payment-sheet", async (req, res) => {
  const {
    name,
    email,
    currency,
    total_amount,
    metaData,
    state,
    city,
    line1,
    postal_code,
    country,
  } = req.body;
  try {
    
    let convertedAmount ;
   
    let currencyConverter = new CurrencyConverter({from:"PKR", to:"USD", amount:total_amount,})
   await currencyConverter
      .convert()
      .then((responseAmount) => {

      convertedAmount = Math.round(responseAmount);
   //or do something else
      });
     
    convertedAmount = convertedAmount*100;
    const stripe = await Stripe(process.env.STRIPE_SECRET_KEY);

    let customer;
    await stripe.customers
      .create({
        name: name,
        email: email,
        phone: "03209509822",
        metadata: {
          id: metaData,
        },
        description:
          "My First Test Customer (created for API docs at https://www.stripe.com/docs/api)",
      })
      .then((cus) => {
        customer = cus;
      });

    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customer.id },
      { apiVersion: "2020-08-27" }
    );

    const paymentIntent = await stripe.paymentIntents.create({
      amount: convertedAmount,
      currency: currency,
      customer: customer.id,
      shipping: {
        name: name,
        address: {
          state: state,
          city: city,
          line1: line1,
          postal_code: postal_code,
          country: country,
        },
      },
      // Edit the following to support different payment methods in your PaymentSheet
      // Note: some payment methods have different requirements: https://stripe.com/docs/payments/payment-methods/integration-options
      payment_method_types: [
        "card",
        // 'ideal',
        // 'sepa_debit',
        // 'sofort',
        // 'bancontact',
        // 'p24',
        // 'giropay',
        // 'eps',
        // 'afterpay_clearpay',
        // 'klarna',
      ],
    });
    return res.json({
      paymentIntent: paymentIntent.client_secret,
      ephemeralKey: ephemeralKey.secret,
      customer: customer.id,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
    console.log(error.message);
  }
});

module.exports = stripeRouter;
