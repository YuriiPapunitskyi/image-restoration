import sys
import time
from PIL import Image

# Додаємо шлях до docres у Python (запобігає проблемам з імпортом)
sys.path.append("/app/docres")

# Імпортуємо функцію для відновлення документа
from docres.data.MBD.infer import restore_document

# Завантаження тестового зображення
image_path = "photo_test.jpeg"

# Початок вимірювання часу
start_time = time.time()

# Обробка документа
try:
    restored_image = restore_document(image_path)
    restored_image = Image.fromarray(restored_image)  # Конвертація у формат Pillow
    restored_image.save("restored_output.jpeg")  # Збереження результату
    print(f"Документ успішно відновлено! Час обробки: {time.time() - start_time:.2f} сек")
except Exception as e:
    print(f"Помилка при обробці документа: {e}")