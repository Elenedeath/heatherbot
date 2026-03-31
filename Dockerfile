FROM python:3.14.3-slim-trixie
WORKDIR /app
COPY . /app
RUN pip3 install -r requirements.txt
CMD ["python", "heather_telegram_bot.py"]