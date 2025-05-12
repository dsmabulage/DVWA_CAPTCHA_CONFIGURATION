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
### 4. Reset Database
Open your browser and navigate to the DVWA URL and go to the Setup tab.
Scroll down and click Create/Reset Database.

### 5. Access DVWA

After the setup is complete, open your browser and navigate to the DVWA URL to test the reCAPTCHA integration.

## 🧨 Exploitation Steps: Bypassing CAPTCHA by Tampering the Request
#### ✅ 1. Submit CAPTCHA Form Once

- Enter values for new_password, confirm_password, and keep CAPTCHA blank.
- Submit the form
- Capture the request using Developer Tools.

### ✅ 2. Select the form and find the value field
Search for the 'form' in DevTools and in the form select 'step=1&password_new=123&password_conf=123&Change=Change'
![image](https://github.com/user-attachments/assets/889839e7-0ac3-43c7-8b5e-7c8074b4d7ba)


#### ✅ 3. Intercept and Modify the Request

- Change the request to directly submit `step=2` like this:
  ![image](https://github.com/user-attachments/assets/c7d1f75f-c46c-4d7d-8857-bfdb5d4a20dd)


Then submit the form again by entering new_password, confirm_password 
This bypasses CAPTCHA verification entirely.

#### ✅ 4. Observe the Response

- You should see the message:

![image](https://github.com/user-attachments/assets/5e7155d2-e21a-4d4e-a0a1-119976f4c5f0)


#### ✅ CAPTCHA successfully bypassed using a direct POST to Step 2.
- The application trusts the step=2 parameter to indicate that CAPTCHA verification has already been completed. By directly submitting a POST request with step=2 and matching passwords, an attacker can bypass CAPTCHA entirely, exposing a critical flaw in the authentication flow that relies on client-side input for server-side validation.

