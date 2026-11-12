# ohmycaptcha on the official Playwright image: browsers + system deps preinstalled,
# so no `playwright install --with-deps` step in the build (that step needs apt access).
FROM mcr.microsoft.com/playwright/python:v1.49.0-jammy

WORKDIR /app

# The image bundles chromium in /ms-playwright; install the matching python
# binding explicitly (the base image does not always expose it on PATH's python).
COPY requirements.txt .
RUN sed -i '/^playwright==/d' requirements.txt \
 && pip install --no-cache-dir -r requirements.txt \
 && pip install --no-cache-dir "playwright==1.49.0" \
 && python -c "import playwright, playwright.async_api; print('playwright ok')"

COPY . .

ENV PYTHONUNBUFFERED=1 \
    SERVER_HOST=0.0.0.0 \
    SERVER_PORT=8000 \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

EXPOSE 8000
CMD ["python", "main.py"]
