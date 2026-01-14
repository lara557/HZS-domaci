//import sql database connection



// sign up form 
function validateForm() {
    const username = document.getElementById("username").value;
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;
    const confirmPassword = document.getElementById("confirmPassword").value;
    const errorMessage = document.getElementById("errorMessage");

    // Clear previous error message
    errorMessage.textContent = "";
    let valid = true;

    // Validate username
    if (username.length < 3) {
        errorMessage.textContent += "Username must be at least 3 characters long.\n";
        valid = false;
    }
    // Validate email
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        errorMessage.textContent += "Please enter a valid email address.\n";
        valid = false;
    }
    // Validate password
    if (password.length < 8) {
        errorMessage.textContent += "Password must be at least 8 characters long.\n";
        valid = false;
    }
    if (password !== confirmPassword) {
        errorMessage.textContent += "Passwords do not match.\n";
        valid = false;
    }
    return valid;
}

// login form
function validateLoginForm() {
    const email = document.getElementById("loginEmail").value;
    const password = document.getElementById("loginPassword").value;
    const errorMessage = document.getElementById("loginErrorMessage");

    // Clear previous error message
    errorMessage.textContent = "";
    let valid = true;  

    // Validate email
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        errorMessage.textContent += "Please enter a valid email address.\n";
        valid = false;
    }

    // Validate password
    if (password.length < 8) {
        errorMessage.textContent += "Password must be at least 8 characters long.\n";
        valid = false;
    }   
    return valid;
}

// account creation success message
function showSuccessMessage() {
    if (validateForm()) {
        alert("Account created successfully!");
    }
}
// login success message
function showLoginSuccessMessage() {
    if (validateLoginForm()) {
        alert("Login successful!");
    }
}
