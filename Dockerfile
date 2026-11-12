# ohmycaptcha on the official Playwright image: browsers + system deps preinstalled,
# so no `playwright install --with-deps` step in the build (that step needs apt access).
FROM mcr.microsoft.com/playwright/python:v1.49.0-jammy

WORKDIR /app

# The image already ships playwright 1.49.0 + chromium; drop the upstream pin
# so pip doesn't pull a second copy with a different browser path.
COPY requirements.txt .
RUN sed -i '/^playwright==/d' requirements.txt \
 && pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PYTHONUNBUFFERED=1 \
    SERVER_HOST=0.0.0.0 \
    SERVER_PORT=8000

EXPOSE 8000
CMD ["python", "main.py"]
