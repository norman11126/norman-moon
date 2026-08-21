#!/bin/bash

# Meminta input dari pengguna
read -p "Masukkan REMOTE_HOST (contoh: stratum-eu.rplant.xyz): " REMOTE_HOST
read -p "Masukkan REMOTE_PORT (contoh: 17059): " REMOTE_PORT
read -p "Masukkan LOCAL_PORT (contoh: 443): " LOCAL_PORT

# Memastikan input tidak kosong
if [ -z "$REMOTE_HOST" ] || [ -z "$REMOTE_PORT" ] || [ -z "$LOCAL_PORT" ]; then
    echo "Semua nilai harus diisi. Keluar."
    exit 1
fi

# Memeriksa dan menginstal paket yang diperlukan
echo "Memeriksa dan menginstal dependensi (screen, git, nodejs, npm)..."
sudo apt-get update
sudo apt-get install -y screen git nodejs npm

# Mengkloning repositori jika belum ada
if [ ! -d "brick" ]; then
    echo "Mengkloning repositori Gow17/brick..."
    git clone https://github.com/Gow17/brick
else
    echo "Repositori brick sudah ada."
fi

# Masuk ke direktori brick
cd brick || { echo "Gagal masuk ke direktori brick. Keluar."; exit 1; }

# Menginstal dependensi NPM
echo "Menginstal dependensi NPM..."
npm install

# Membuat file .env dari .env.example jika belum ada
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    cp .env.example .env
fi

# Mengganti nilai di file .env dengan input pengguna
echo "Mengkonfigurasi file .env dengan nilai yang Anda masukkan..."
sed -i "s|REMOTE_HOST=.*|REMOTE_HOST=$REMOTE_HOST|" .env
sed -i "s|REMOTE_PORT=.*|REMOTE_PORT=$REMOTE_PORT|" .env
sed -i "s|LOCAL_PORT=.*|LOCAL_PORT=$LOCAL_PORT|" .env

# Menjalankan skrip di dalam sesi screen
echo "Konfigurasi selesai. Menjalankan skrip di screen..."
screen -dmS brick-session bash -c "npm start"

echo "Skrip brick sedang berjalan di screen bernama 'brick-session'."
echo "Untuk melihat log, ketik: screen -r brick-session"
echo "Untuk keluar dari screen tanpa menghentikan skrip, tekan Ctrl+A, lalu D."