exec xautolock -detectsleep \
  -time 10 -locker "light-locker-command -l" \
  -notify 60 \
  -notifier "notify-send -u critical -t 10000 -- 'LOCKING screen in 60 seconds'"
