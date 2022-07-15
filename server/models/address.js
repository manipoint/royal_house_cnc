const mongoose = require("mongoose");
const addressSchema = mongoose.Schema({
  line1: {
    type: String,
    // default:"",
    trim: true,
  },
  line2: {
    type: String,
    default:"",
    trim: true,
  },

  city: {
    type: String,
    // default:"",
    trim: true,
  },
  postalCode: {
    type: String,
    // default:"",
    trim: true,
  },
  state: {
    type: String,
    default:"",
    trim: true,
  },
  country: {
    type: String,
    default:"",
    trim: true,
  },
});
module.exports = addressSchema;
