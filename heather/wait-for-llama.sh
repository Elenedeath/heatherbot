#!/bin/sh
echo "⏳ Waiting for llama-server..."
for i in $(seq 1 60); do
  if curl -f http://llama-server:1234/health 2>/dev/null; then
    echo "✅ llama-server ready!"
    exec python heather_telegram_bot.py
  fi
  echo "Wait $i/60..."
  sleep 5
done
echo "Timeout - starting anyway"
exec python heather_telegram_bot.py