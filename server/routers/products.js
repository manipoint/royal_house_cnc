const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");

productRouter.get("/api/products", auth, async (req, res) => {
  try {
    const products = await Product.find({
      category: req.query.category,
    });

    res.json(products);
  } catch (e) {
    res.status(500).json({
      error: e.message,
    });
  }
});
// create a get request to search products and get them
// /api/products/search/i
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const products = await Product.find({
      //search every product contain eg
      //  if i want to search door on typing (Door,DOOR,doo) in search bar we will see all products containing door in their name shows
      name: {
        $regex: req.params.name,
        $options: "i",
      },
    });
    res.json(products);
  } catch (error) {
    res.status(500).json({
      error: error.message,
    });
  }
});

productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);
    //this for loop is iterate all rating object like[ {userId = abc,rating:4},{userId = xyz,rating:4},{userId = gma,rating:3.5}]

    for (let i = 0; i < product.ratings.length; i++) {
      /* 
    if user previously add rating but in some case want to change then
     first we delate rating object by  userId == req.user 
     (req.user we can get through auth middleware and break for loop to avoid extra iterations )
     */
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }
    const ratingSchema = {
      userId: req.user,
      rating,
    };
   
    // push array end of product schema
    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (error) {
    res.status(500).json({ error: error.message });
    console.log(error.message);
  }
});

productRouter.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});
    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;

      for (let i = 0; i < a.ratings.length; i++) {
        aSum += a.ratings[i].rating;
      }

      for (let i = 0; i < b.ratings.length; i++) {
        bSum += b.ratings[i].rating;
      }
      return aSum < bSum ? 1 : -1;
    });
    res.json(products[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
module.exports = productRouter;
