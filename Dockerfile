FROM python:3.14.3-slim-trixie
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf /root/.cache/pip /tmp/* /var/lib/apt/lists/*

COPY . .

EXPOSE 8888
CMD ["python", "heather_telegram_bot.py"]