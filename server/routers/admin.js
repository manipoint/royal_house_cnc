const express = require("express");

const { Product } = require("../models/product");
const Order = require("../models/order");
const adminRouter = express.Router();
const adminMiddleware = require("../middlewares/admin");

adminRouter.post("/admin/add-product", adminMiddleware, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });
    product = await product.save();
    res.json(product);
  } catch (error) {
    res.status(500).json({
      error: error.message,
    });
  }
});
// Get all your products
adminRouter.get("/admin/get-products/", adminMiddleware, async (req, res) => {
  try {
    const product = await Product.find({});
    res.json(product);
  } catch (error) {
    res.status(500).json({
      error: error.message,
    });
  }
});
// Delete the product
adminRouter.post("/admin/delete-product", adminMiddleware, async (req, res) => {
  try {
    const { id } = req.body;

    let product = await Product.findByIdAndDelete(id);

    res.json(product);
  } catch (error) {
    res.status(500).json({
      error: error.message,
    });
  }
});
// Get all your Orders
adminRouter.get("/admin/get-orders/", adminMiddleware, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (error) {
    res.status(500).json({
      error: error.message,
    });
  }
});
adminRouter.post(
  "/admin/change-order-status",
  adminMiddleware,
  async (req, res) => {
    try {
      const { id, status } = req.body;
      let order = await Order.findById(id);
      order.status = status;
      order = await order.save();
      res.json(order);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);

adminRouter.get("/admin/analytics", adminMiddleware, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;

    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarnings +=
          orders[i].products[j].quantity * orders[i].products[j].product.price;
      }
    }
    // CATEGORY WISE ORDER FETCHING
    let mobileCoverEarning = await fetchCategoryWiseProduct("Mobiles");
    let table_topsEarning = await fetchCategoryWiseProduct("Table Tops");
    let shirtsEarning = await fetchCategoryWiseProduct("Shirts");
    let doorsEarning = await fetchCategoryWiseProduct("Doors");
    let cupsEarning = await fetchCategoryWiseProduct("Cup");
    let jaliEarning = await fetchCategoryWiseProduct("Jali");
    let calligraphyEarning = await fetchCategoryWiseProduct("Calligraphy");
    let wallsEarning = await fetchCategoryWiseProduct("Walls");

    let earnings = {
      totalEarnings,
      mobileCoverEarning,
      table_topsEarning,
      shirtsEarning,
      doorsEarning,
      cupsEarning,
      jaliEarning,
      calligraphyEarning,
      wallsEarning,
    };
    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

async function fetchCategoryWiseProduct(category) {
  let earnings = 0;
 try {
  let categoryOrders = await Order.find({
    'products.product.category':category,
  });

  for (let i = 0; i < categoryOrders.length; i++) {
    for (let j = 0; j < categoryOrders[i].products.length; j++) {
      earnings +=
        categoryOrders[i].products[j].quantity *
        categoryOrders[i].products[j].product.price;
    }
  }
 } catch (error) {
   console.log(error.message);
 }
  return earnings;
}

module.exports = adminRouter;
