# DVWA CAPTCHA CONFIGURATION

This repository configures reCAPTCHA for the **Damn Vulnerable Web Application (DVWA)** to enhance its security with CAPTCHA challenges.

## Prerequisites

To perform this check, **your Kali machine must have internet access**.

## 📌 Steps to Fix reCAPTCHA Configuration

### 1. Generate Google reCAPTCHA v2 Keys

* Visit: [Google reCAPTCHA Admin](https://www.google.com/recaptcha/admin/create)
* **Label**: Choose a descriptive name (e.g., `DVWA Local Test`).
* **reCAPTCHA Type**: Select **Challenge v2 → "I'm not a robot" Checkbox**.
* **Domains**: Add `localhost`.
* Accept Terms of Service and submit.
* Copy the **Site Key** (public) and **Secret Key** (private).

---

## Steps to Set Up

### 1. Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/dsmabulage/DVWA_CAPTCHA_CONFIGURATION.git
cd DVWA_CAPTCHA_CONFIGURATION
```

### 2. Give Execution Permissions

Give execution permission to the setup script:

```bash
chmod +x setup-dvwa-recaptcha.sh
```

### 3. Run the Script

Execute the script to configure DVWA with reCAPTCHA:

```bash
./setup-dvwa-recaptcha.sh
```

### 4. Access DVWA

After the setup is complete, open your browser and navigate to the DVWA URL to test the reCAPTCHA integration.
