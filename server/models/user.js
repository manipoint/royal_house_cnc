const mongoose = require("mongoose");
const addressSchema = require("./address");
const { productSchema } = require("./product");

const userSchema = mongoose.Schema({
  name: {
    type: String,
    require: true,
    trim: true,
  },
  email: {
    type: String,
    require: true,
    trim: true,
    validate: {
      validator: (value) => {
        const regExp =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(regExp);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    require: true,
    type: String,
  },
  address: {
    type: addressSchema,
    default: {
      line1: "line1",
      line2: "line2",
      city: "city",
      postalCode: "postalCode",
      state: "state",
      country: "country",
    },
  },

  type: {
    type: String,
    default: "user",
  },
  cart: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        required: true,
      },
    },
  ],
});

const User = mongoose.model("User", userSchema);
module.exports = User;
