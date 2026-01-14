# ---------------------------------------------------------------
# DOCKERFILE FULLSTACK (BACKEND + FRONTEND)
# ---------------------------------------------------------------

# 1. Gunakan Node.js versi ringan (Alpine Linux)
FROM node:18-alpine

# 2. Set folder kerja di dalam container
WORKDIR /app

# 3. Copy file konfigurasi dependency (package.json)
# Kita copy ini DULUAN biar proses build lebih cepat (memanfaatkan cache Docker)
COPY package*.json ./
COPY backend/package*.json ./backend/
COPY frontend/package*.json ./frontend/

# 4. Install semua library yang dibutuhkan
# Install dependency di root (jika ada)
RUN npm install
# Install dependency backend
RUN cd backend && npm install
# Install dependency frontend
RUN cd frontend && npm install

# 5. Copy SELURUH kode sumber project (Backend + Frontend) ke dalam container
COPY . .

# 6. Build Frontend
# Langkah ini mengubah kode React menjadi HTML/CSS/JS biasa
# Hasilnya biasanya ada di folder 'frontend/dist'
RUN cd frontend && npm run build

# 7. Set Environment Variable Penting
# Pastikan aplikasi berjalan dalam mode production
ENV NODE_ENV=production
# Pastikan port diset ke 5000 sesuai server.js
ENV PORT=5000

# 8. Buka Port 5000 agar bisa diakses dari luar container
EXPOSE 5000

# 9. Jalankan server backend
# Backend ini nanti yang akan melayani API sekaligus menampilkan frontend
CMD ["node", "backend/server.js"]