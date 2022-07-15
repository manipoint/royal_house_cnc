const jwt = require("jsonwebtoken");
const User = require("../models/user");
const admin = async(req,res,next)=>{
    try {
        //we passed token via header from admin service
        const token = req.header("x-auth-token");
        // if there is no token return with status code 401 
        if(!token) return res.status(401).json({msg:"No auth token, access denied"});
        // now verified user password 
        const verified = jwt.verify(token,"passwordKey");
        if(!verified) return res.status(401).json({msg: "Token verification failed, authorization denied."});

        // All ok now find user by id
        const user = User.findById(verified.id);
        // checking user type from db
        if(user.type == "user"||user.type=="seller"){
            return res.status(401).json({msg:"You are not an admin!"});
        }
        req.user = verified.id;
        req.token = token;
        next();
    } catch (error) {
        res.status(500).json({ error: err.message });
    }
};
module.exports = admin;