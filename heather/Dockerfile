FROM python:3.14.3-slim-trixie
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf /root/.cache/pip /tmp/*

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY . .
RUN chmod +x /app/entrypoint.sh

EXPOSE 8888
CMD ["sh", "/app/entrypoint.sh"]