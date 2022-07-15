//Import from npm packages
require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const adminRouter = require("./routers/admin");

// import from files
const authRouter = require("./routers/auth");
const productRouter = require("./routers/products");
const userRouter = require("./routers/user");
const stripeRouter = require("./routers/stripe");

//initializations
const app = express();
const PORT = process.env.PORT || 4242;
const db = process.env.DB;
//middle ware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
app.use(stripeRouter);

//db connections
mongoose
  .connect(db)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

// creating api

app.listen(PORT, async() => {
  console.log(`connected to port ${PORT}`);
});
