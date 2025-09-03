const express= require("express");// Import Express framework// Web framework to create APIs.
const multer=require("multer"); // Import Multer for handling file uploads
const mysql=require("mysql2");// Import MySQL2 for database connection
const cors=require("cors");// Import CORS for cross-origin requests
const path=require("path");// Import Path module to manage file paths
const bodyparser=require("body-parser");
const fs = require("fs");
require("dotenv").config();

const app= express();
app.use(cors());
app.use(bodyparser.json());
app.use(express.json({ limit: "100mb" }));
app.use(express.urlencoded({ limit: "100mb", extended: true }));
app.use("/uploads",express.static("uploads"));

const db=mysql.createConnection({
host: "localhost",
user:"root",
password:"mysql_admin123",
database:"noon_cart_DB",
});

db.connect((err)=>{
if(err){
    console.error("Database connection failed "+err.stack);
    return;
}
console.log("Connected to mysql database");
});

app.get("/products", (req,res)=>{
    db.query("SELECT * FROM PRODUCTS", (err,results)=>{
        if(err){
            res.status(500).json({error: err.message});
        }
        else{
            res.json(results);
        }
    });
});

const storage = multer.diskStorage({
    destination:"./uploads",
    filename:(req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }

});
const upload= multer({storage, limits: { fileSize: 100 * 1024 * 1024 } });


// app.post("/products",(req,res)=>{
//     const {name, description, price, imageurl}=req.body;
//     db.query(
//         "INSERT INTO PRODUCT (name, description, price, imageurl ) values (?,?,?,?)",nodn
//         [name,description,price,imageurl],
//         (err,result)=>{
//             if(err){
//                 res.status(500).json({error:err.message});
//             }else{
//                 res.json({message:"Product added",id: result.id});
//             }
//         }

//         );
// });

app.post("/products",upload.single("image"),(req,res)=>{
    const {name, description, price, image_url}=req.body;
    let imageurl;
    if(image_url)
    {
        const imagepath=`uploads/${Date.now()}.png`;
        fs.writeFileSync(imagepath,Buffer.from(image_url,"base64"));
        imageurl=`http://localhost:5000/${imagepath}`
    }else if(req.file){
         imageurl=`http://localhost:5000/uploads/${req.file.filename}`;
    }
   
    const sql="INSERT INTO PRODUCTS(name, description, price, imageurl) values (?,?,?,?)"
    db.query(
        sql,    
        [name,description,price,imageurl],
        (err,result)=>{
            if(err){
                res.status(500).json({error:err.message});
            }else{
                res.json({message:"Product added",id: result.id});
            }
        }

        );
});
const PORT = process.env.PORT || 5000;
app.listen(PORT, ()=> {
    console.log(`Server running on port, ${PORT}`);
});