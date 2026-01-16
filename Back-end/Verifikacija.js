const express = require('express');
const mysql = require('mysql2');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const cors = require('cors');
require('dotenv').config();
const app = express();

const JWT_SECRET = process.env.JWT_SECRET || 'tvoj_tajni_kljuc_promeni_ovo';

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'wellness_db'
});

db.connect((err) => {
    if (err) {
        console.error('Greška pri povezivanju sa bazom:', err);
    } else {
        console.log('Uspešno povezan sa MySQL bazom!');
    }
});

const registerUser = (req, res) => {
    // Information from flutter
    const { username, email, password, confirmPassword } = req.body;
    
    let errors = [];

    // Validate username
    if (!username || username.length < 3) {
        errors.push("Username must be at least 3 characters long.");
    }

    // Validate email
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern || !emailPattern.test(email)) {
        errors.push("Please enter a valid email address.");
    }

    // Validate password
    if (!password || password.length < 8) {
        errors.push("Password must be at least 8 characters long.");
    }

    const passwordPattern = /^(?=.*[A-Z])(?=.*\W)(?!.*\s).+$/;
    if (!passwordPattern.test(password)) {
        errors.push("Password must contain at least one capital letter, special character, and no spaces.");
    }

    if (password !== confirmPassword) {
        errors.push("Passwords do not match.");
    }

    // If there is an error
    if (errors.length > 0) {
        return res.status(400).json({ success: false, messages: errors });
    }
    const checkUserSql = "SELECT * FROM korisnici WHERE email = ?";
    db.query(checkUserSql, [email], (err, results) => {
        if (err) return res.status(500).json({ success: false, message: "Database error" });
        
        if (results.length > 0) {
            return res.status(400).json({ success: false, messages: ["Email is already registered."] });
        }

        const insertSql = "INSERT INTO korisnici (ime, email, lozinka) VALUES (?, ?, ?)";
        
        // Heširaj lozinku pre nego što je sačuvaš
        const hashedPassword = bcrypt.hashSync(password, 10);
        
        db.query(insertSql, [username, email, hashedPassword], (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ success: false, message: "Error saving user." });
            }

            // Sending information to serve if everything is all right
            res.status(201).json({ success: true, message: "Account created successfully!" });
        });
    });
};
const loginUser = (req, res) => {
    const { username, password } = req.body;

    const sql = "SELECT * FROM korisnici WHERE ime = ?";

    db.query(sql, [username], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ success: false, message: "Database error." });
        }

        if (results.length > 0) {
            // Proveri hešovanu lozinku
            const isPasswordValid = bcrypt.compareSync(password, results[0].lozinka);
            
            if (isPasswordValid) {
                // Kreiraj JWT token
                const token = jwt.sign(
                    { 
                        userId: results[0].id, 
                        email: results[0].email,
                        username: results[0].ime 
                    },
                    JWT_SECRET,
                    { expiresIn: '24h' }
                );

                res.status(200).json({ 
                    success: true, 
                    message: "Login successful!", 
                    token: token,
                    user: {
                        id: results[0].id,
                        username: results[0].ime,
                        email: results[0].email
                    }
                });
            } else {
                res.status(401).json({ 
                    success: false, 
                    message: "Invalid username or password." 
                });
            }
        } else {
            res.status(401).json({ 
                success: false, 
                message: "Invalid username or password." 
            });
        }
    });
};

// Middleware za verifikaciju JWT tokena
const verifyToken = (req, res, next) => {
    const token = req.headers['authorization'];

    if (!token) {
        return res.status(403).json({ 
            success: false, 
            message: "Token nije pronađen." 
        });
    }

    // Ukloni "Bearer " iz tokena ako postoji
    const tokenValue = token.startsWith('Bearer ') ? token.slice(7) : token;

    try {
        const decoded = jwt.verify(tokenValue, JWT_SECRET);
        req.user = decoded;
        next();
    } catch (err) {
        return res.status(401).json({ 
            success: false, 
            message: "Nevažeći ili istekao token." 
        });
    }
};

app.use(express.json());

// CORS konfiguracija
const corsOptions = {
    origin: ['http://localhost:3000', 'http://localhost:8080', '*'],
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
};

app.use(cors(corsOptions));

app.post('/register', registerUser);
app.post('/login', loginUser);

// Primer zaštićene rute - samo autentifikovani korisnici
app.get('/protected', verifyToken, (req, res) => {
    res.status(200).json({ 
        success: true, 
        message: "Pristup dozvoljen!",
        user: req.user 
    });
});

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server radi na portu ${PORT}`);
});