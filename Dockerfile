# Gunakan Node.js versi Alpine (Ringan)
FROM node:18-alpine

# Set folder kerja
WORKDIR /app

# --- FIX ERROR EXIT CODE 2 ---
# Kita install alat bantu (Python, Make, G++) karena library backend
# sering membutuhkannya untuk di-build.
RUN apk add --no-cache python3 make g++

# --- COPY SEMUANYA SEKALIGUS ---
# Kita copy semua file dari laptop ke dalam container
# (Ini lebih aman daripada copy satu-satu)
COPY . .

# --- INSTALL & BUILD ---
# 1. Install library di folder ROOT (jika ada)
RUN npm install

# 2. Install library BACKEND
RUN cd backend && npm install

# 3. Install library FRONTEND & Build React
RUN cd frontend && npm install
RUN cd frontend && npm run build

# --- SETTING APLIKASI ---
ENV NODE_ENV=production
ENV PORT=5000

# Buka port 5000
EXPOSE 5000

# Jalankan aplikasi
CMD ["node", "backend/server.js"]