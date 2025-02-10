# Використовуємо офіційний Python-образ
FROM python:3.9

# Встановлюємо робочу директорію
WORKDIR /app

# Встановлюємо необхідні бібліотеки для OpenCV та Git
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Копіюємо requirements.txt
COPY requirements.txt .

# Встановлюємо залежності
RUN pip install --no-cache-dir -r requirements.txt

# Клонуємо репозиторій DocRes
RUN git clone https://github.com/ZZZHANG-jx/DocRes.git /app/docres

# Додаємо docres у Python-шлях
ENV PYTHONPATH="/app/docres:${PYTHONPATH}"

# Створюємо необхідні директорії
RUN mkdir -p data/MBD/checkpoint checkpoints input restorted

# Копіюємо файли моделей (якщо вони є локально)
COPY mbd.pkl /app/data/MBD/checkpoint/mbd.pkl
COPY docres.pkl /app/checkpoints/docres.pkl

# Копіюємо тестове зображення
COPY photo_test.jpeg /app/input/photo_test.jpeg

# Встановлюємо залежності для DocRes (якщо потрібно)
RUN pip install -e /app/docres

# Команда для запуску скрипту
CMD ["python3", "/app/docres/inference.py", "--im_path", "./input/photo_test.jpeg", "--task", "dewarping", "--save_dtsprompt", "1"]