#!/bin/sh
echo "⏳ Waiting for llama-server..."
i=1
while [ $i -le 20 ]; do
  if curl -f http://llama-server:1234/health 2>/dev/null; then
    echo "✅ llama-server ready!"
    exec python heather_telegram_bot.py
  fi
  echo "Wait $i/20..."
  sleep 5
  i=$((i + 1))
done
echo "Timeout - starting anyway"
exec python heather_telegram_bot.py