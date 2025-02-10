FROM nvidia/cuda:12.0-base

# Встановлення необхідних пакетів
RUN apt-get update && apt-get install -y \
    wget \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Створення робочої директорії
WORKDIR /app

# Копіюємо весь код у контейнер
COPY . /app

# Встановлення залежностей
RUN pip3 install -r requirements.txt

# Створення необхідних директорій
RUN mkdir -p data/MBD/checkpoint checkpoints

# Завантаження ваг моделі
RUN wget -O data/MBD/checkpoint/mbd.pkl "https://1drv.ms/f/s!Ak15mSdV3Wy4iahoKckhDPVP5e2Czw?e=iClwdK" || echo "Не вдалося завантажити mbd.pkl"
RUN wget -O checkpoints/docres.pkl "https://1drv.ms/f/s!Ak15mSdV3Wy4iahoKckhDPVP5e2Czw?e=iClwdK" || echo "Не вдалося завантажити docres.pkl"

# Команда за замовчуванням
CMD ["python3", "inference.py", "--im_path", "./input/for_dewarping.png", "--task", "dewarping", "--save_dtsprompt", "1"]
