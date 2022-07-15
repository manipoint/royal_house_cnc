const express = require("express");
const User = require("../models/user");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const authRouter = express.Router();
const authMiddleware =  require("../middlewares/auth");


authRouter.post("/api/signup", async (req, res) => {
    try {
        const {
            name,
            email,
            password
        } = req.body;
        const existingUser = await User.findOne({
            email,
        });
        if (existingUser) {
            return res.sendStatus(400).json({
                msg: "User with same email already exists!",
            });
        }

        const bcryptPassword = await bcrypt.hash(password, 8);
        let user = new User({
            email,
            password: bcryptPassword,
            name,
        });
        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({
            error: e.message,
        });
    }
});

authRouter.post("/api/signin", async (req, res) => {
    try {
        const {
            email,
            password
        } = req.body;

        //find user with email
        const user = await User.findOne({
            email,
        });
        //if user is not register send message to user
        if (!user) {
            return res.status(400).json({
                msg: "No user register with this email yet!",
            });
        }
        //match user password with password store in db
        const isMatched = await bcrypt.compare(password, user.password);

        //if password don't match send message
        if (!isMatched) {
            return res.status(400).json({
                msg: "Incorrect password.",
            });
        }

        // get jwt to store in device for reuseable
        const token = jwt.sign({
            id: user._id,
        },
            "passwordKey"
        );
        // update user with token
       
        res.json({
            token,
            ...user._doc,
        });
    } catch (e) {
        res.status(500).json({
            error: e.message,
        });
    }
});

authRouter.post("/isTokenValid", async (req, res) => {
    try {
        const token = req.header("x-auth-token");

        if (!token) return res.json(false);
        const isVerified = jwt.verify(token, "passwordKey");
        if (!isVerified) return res.json(false);
        // now if token is verified lets check user is available or not this is because
        //token is just a random number it's possible app may create same token witch was already
        // store in db
        const user = User.findById(isVerified.id); // User.findById(isVerified.id) is because we at line 69 we signin with id, const token = await jwt.sign({id:user._id},"passwordKey");
        if (!user) return res.json(false);
        res.json(true);
    } catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
});

// get user data
// now we need to create a middleware witch authorize only those user who's id and token is matched

authRouter.get("/", authMiddleware, async (req, res) => {
    const user = await User.findById(req.user);
   
    res.json({
        ...user._doc,
        token: req.token,
    });
});


module.exports = authRouter;