const jwt = require("jsonwebtoken");

const authMiddleware = async (req, res,next) => {
    try {
        const token = req.header("x-auth-token");
        if (!token) res.status(401).json({
            msg: "No auth token found, access denied"
        });
        const verified = jwt.verify(token, "passwordKey");
        if (!verified)
            return res.status(401).json({
                msg: "Token verification failed, authorization denied."
            }, );
            req.user = verified.id;
            req.token = token;
            next();


    } catch (error) {
res.status(500).json({error:error.msg});
    }
};
module.exports = authMiddleware;