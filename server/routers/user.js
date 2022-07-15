const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");
const addressSchema = require("../models/address");
const { Product } = require("../models/product");
const User = require("../models/user");
const OrderModel = require("../models/order");

userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }
      if (isProductFound) {
        let cartProduct = user.cart.find((productInCart) =>
          productInCart.product._id.equals(product._id)
        );

        cartProduct.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }
    user = await user.save();
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let index = 0; index < user.cart.length; index++) {
      if (user.cart[index].product._id.equals(product._id)) {
        if (user.cart[index].quantity == 1) {
          user.cart.splice(index, 1);
        } else {
          user.cart[index].quantity -= 1;
        }
      }
    }
    user = await user.save();
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
// save user address
userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { line1, line2, city, postalCode, state, country } = req.body;
    let user = await User.findById(req.user);
    let addressSchema = {
      line1: line1,
      line2: line2,
      city: city,
      postalCode: postalCode,
      state: state,
      country: country,
    };
    user.address = addressSchema;

    user = await user.save();

    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;
    // console.log(address);
    let products = [];

    for (let index = 0; index < cart.length; index++) {
      let product = await Product.findById(cart[index].product._id);

      //checking form DB that we have enough quantity
      if (product.quantity >= cart[index].quantity) {
        product.quantity -= cart[index].quantity;
        products.push({ product, quantity: cart[index].quantity });
        await product.save();
      } else {
        return res
          .status(400)
          .json({ msg: `${product.name} is out of stock!` });
      }
    }
    let user = await User.findById(req.user);

    user.cart = [];
    user.addressSchema = address;
    user = await user.save();

    let order = new OrderModel({
      products,
      totalPrice,
      address: user.address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });

    order = await order.save();
  
    res.json(order);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error.message });
  }
});
userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    const orders = await OrderModel.find({ userId: req.user });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = userRouter;
