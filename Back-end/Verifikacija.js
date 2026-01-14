const express = require('express');
const app = express();
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

    // Sending information to serve if everything is all right
    res.status(201).json({ success: true, message: "Account created successfully!" });
};


app.use(express.json()); // Obavezno, da bi server mogao da čita podatke iz Fluttera

// Povezujemo tvoju funkciju sa rutom '/register'
app.post('/register', registerUser);

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server radi na portu ${PORT}`);
});