#!/bin/sh
# Entrypoint: wait for llama-server, then launch all services in one container
# - Heather Telegram bot (foreground)
# - Discord daily story poster (background, if DISCORD_TOKEN is set)
# - Cohort watchdog (background, if ENABLE_COHORT_WATCHDOG=true)

echo "⏳ Waiting for llama-server..."
i=1
while [ $i -le 20 ]; do
  if curl -f http://llama-server:1234/health 2>/dev/null; then
    echo "✅ llama-server ready!"
    break
  fi
  echo "Wait $i/20..."
  sleep 5
  i=$((i + 1))
done

# Start Discord story poster in background (if configured)
if [ -n "$DISCORD_TOKEN" ] && [ "$DISCORD_TOKEN" != "CHANGE_ME" ]; then
  echo "🚀 Starting Discord story poster (--loop)..."
  python daily_story_poster.py --loop &
else
  echo "⏭️  Discord story poster disabled (no DISCORD_TOKEN)"
fi

# Start Cohort watchdog daily loop in background (if enabled)
if [ "$ENABLE_COHORT_WATCHDOG" = "true" ]; then
  echo "🚀 Starting Cohort watchdog (daily at 6am)..."
  (
    while true; do
      python cohort_watchdog.py 2>&1 | head -50
      # Sleep 24h between runs
      sleep 86400
    done
  ) &
else
  echo "⏭️  Cohort watchdog disabled (set ENABLE_COHORT_WATCHDOG=true to enable)"
fi

# Main process: Heather Telegram bot (foreground — keeps container alive)
echo "🚀 Starting Heather Telegram bot..."
exec python heather_telegram_bot.py
