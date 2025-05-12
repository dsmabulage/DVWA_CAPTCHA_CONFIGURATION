#!/bin/bash

# === STEP 0: Prompt for reCAPTCHA Keys ===
read -rp "Enter your reCAPTCHA Public Key: " RECAPTCHA_PUBLIC_KEY
if [[ -z "$RECAPTCHA_PUBLIC_KEY" ]]; then
    echo "[!] Public key cannot be empty. Aborting."
    exit 1
fi

read -rp "Enter your reCAPTCHA Private Key: " RECAPTCHA_PRIVATE_KEY
if [[ -z "$RECAPTCHA_PRIVATE_KEY" ]]; then
    echo "[!] Private key cannot be empty. Aborting."
    exit 1
fi

# === CONFIGURATION ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RECAPTCHA_FILE_PATH="$SCRIPT_DIR/recaptchalib.php"
CONFIG_FILE="/var/www/html/config/config.inc.php"

# === STEP 1: Get DVWA Container ID ===
echo "[*] Getting DVWA container ID..."
container_id=$(docker ps --filter "name=dvwa" --format "{{.ID}}")
if [ -z "$container_id" ]; then
    echo "[!] DVWA container not found. Is it running?"
    exit 1
fi
echo "[+] DVWA container ID: $container_id"

# === STEP 2: Check if recaptchalib.php exists ===
if [ ! -f "$RECAPTCHA_FILE_PATH" ]; then
    echo "[!] Custom recaptchalib.php not found at: $RECAPTCHA_FILE_PATH"
    echo "[*] Current directory: $(pwd)"
    echo "[*] Script directory: $SCRIPT_DIR"
    echo "[*] Checking if file exists in current directory..."
    if [ -f "./recaptchalib.php" ]; then
        RECAPTCHA_FILE_PATH="./recaptchalib.php"
        echo "[+] Found recaptchalib.php in current directory"
    else
        echo "[!] WARNING: Proceeding without custom recaptchalib.php"
    fi
fi

# === STEP 3: Inject reCAPTCHA keys into config.inc.php ===
echo "[*] Updating reCAPTCHA keys in config.inc.php..."
echo "[*] Using Public Key: $RECAPTCHA_PUBLIC_KEY"
echo "[*] Using Private Key: $RECAPTCHA_PRIVATE_KEY"

echo "[*] Checking current config..."
docker exec -it "$container_id" grep -A 3 recaptcha /var/www/html/config/config.inc.php || {
    echo "[!] Failed to read config.inc.php inside the container."
    exit 1
}

docker exec -i "$container_id" bash -c \
"sed -i \"s/\\(\$_DVWA\\[ 'recaptcha_public_key' \\] *= *'\\)[^']*'/\\1$RECAPTCHA_PUBLIC_KEY'/\" /var/www/html/config/config.inc.php" || {
    echo "[!] Failed to update public key."
    exit 1
}

docker exec -i "$container_id" bash -c \
"sed -i \"s/\\(\$_DVWA\\[ 'recaptcha_private_key' \\] *= *'\\)[^']*'/\\1$RECAPTCHA_PRIVATE_KEY'/\" /var/www/html/config/config.inc.php" || {
    echo "[!] Failed to update private key."
    exit 1
}

echo "[*] Verifying changes..."
docker exec -it "$container_id" grep -A 3 recaptcha /var/www/html/config/config.inc.php

# === STEP 4: Copy custom recaptchalib.php if available ===
if [ -f "$RECAPTCHA_FILE_PATH" ]; then
    echo "[*] Copying custom recaptchalib.php to container..."
    docker cp "$RECAPTCHA_FILE_PATH" "$container_id":/var/www/html/external/recaptcha/recaptchalib.php || {
        echo "[!] Failed to copy recaptchalib.php."
        exit 1
    }
    echo "[+] recaptchalib.php copied successfully"
fi

# === STEP 5: Restart DVWA container to apply changes ===
echo "[*] Restarting DVWA container to apply changes..."
docker restart "$container_id" || {
    echo "[!] Failed to restart container."
    exit 1
}

# === STEP 6: Display the correct URL ===
port=$(docker port "$container_id" 80/tcp | sed 's/.*://')
if [ -z "$port" ]; then
    echo "[!] Could not determine port. Check if port is exposed with: docker port $container_id"
    echo "[✅] reCAPTCHA setup complete. Access DVWA using your configured Docker port."
else
    echo "[✅] reCAPTCHA setup complete."
    echo "[🌐] Open your browser and go to: http://localhost:$port"
fi
