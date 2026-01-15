const express = require('express');
const mysql = require('mysql2');
const app = express();

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
        db.query(insertSql, [username, email, password], (err, result) => {
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

    const sql = "SELECT * FROM korisnici WHERE ime = ? AND lozinka = ?";

    db.query(sql, [username, password], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ success: false, message: "Database error." });
        }

        if (results.length > 0) {
            res.status(200).json({ 
                success: true, 
                message: "Login successful!", 
                user: results[0] 
            });
        } else {
            res.status(401).json({ 
                success: false, 
                message: "Invalid username or password." 
            });
        }
    });
};

app.use(express.json());

app.post('/register', registerUser);
app.post('/login', loginUser);

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server radi na portu ${PORT}`);
});