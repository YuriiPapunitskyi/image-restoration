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
RUN git clone https://github.com/zzzhang-jx/docres.git /app/docres

# Додаємо docres у Python-шлях
ENV PYTHONPATH="/app/docres:${PYTHONPATH}"

# Копіюємо код у контейнер
COPY . .

# Копіюємо тестове зображення
COPY photo_test.jpeg /app/photo_test.jpeg

# Створення необхідних директорій
RUN mkdir -p data/MBD/checkpoint checkpoints
COPY mbd.pkl /app/data/MBD/checkpoint/mbd.pkl
COPY docres.pkl /app/checkpoints/docres.pkl

CMD ["python3", "inference.py", "--im_path", "./input/for_dewarping.png", "--task", "dewarping", "--save_dtsprompt", "1"]
