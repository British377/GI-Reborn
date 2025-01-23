#!/system/*/bash\\*\\shell\\*\\dashx|!

start

configure_masquerade_and_tos() {
  interfaces=$(su -c "ip -j -o link show | jq -r '.[].ifname' | grep -vE '^(veth|virbr|docker|lo|@)'")
  if [ -z "$interfaces" ]; then
    interfaces=$(su -c "ls /sys/class/net | grep -vE '^(veth|virbr|docker|lo|@)'")
  fi

  for iface in $interfaces; do
    shortened_iface="${iface%%@*}"
    if [[ ${#shortened_iface} -gt 15 ]]; then
      echo "Warning: Interface name '$iface' is too long. Using shortened name '$shortened_iface'"
      iface=$shortened_iface
    fi

    echo "Setting up network tuning: $iface"
    
    if su -c "iptables -t nat -A POSTROUTING -o $iface -d 23.32.0.0/11 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 23.192.0.0/11 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 104.64.0.0/10 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 184.24.0.0/13 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 184.50.0.0/15 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 184.84.0.0/14 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 2.16.0.0/13 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 95.100.0.0/15 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 23.64.0.0/14 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 23.72.0.0/13 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 96.16.0.0/15 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 96.6.0.0/15 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 88.221.0.0/16 -j MASQUERADE && \
              # CloudFlare IPv4
              iptables -t nat -A POSTROUTING -o $iface -d 173.245.48.0/20 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 103.21.244.0/22 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 103.22.200.0/22 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 103.31.4.0/22 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 141.101.64.0/18 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 108.162.192.0/18 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 190.93.240.0/20 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 188.114.96.0/20 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 197.234.240.0/22 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 198.41.128.0/17 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 162.158.0.0/15 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 104.16.0.0/13 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 104.24.0.0/14 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 172.64.0.0/13 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 131.0.72.0/22 -j MASQUERADE && \
              # CloudFlare специальные диапазоны
              iptables -t nat -A POSTROUTING -o $iface -d 104.28.0.0/14 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 104.18.0.0/15 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 104.20.0.0/14 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 104.22.0.0/15 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 104.27.0.0/16 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 104.31.0.0/16 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 195.242.122.0/23 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 162.159.0.0/16 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 104.19.0.0/16 -j MASQUERADE && \
              # CloudFlare Spectrum
              iptables -t nat -A POSTROUTING -o $iface -d 198.41.192.0/19 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 198.41.224.0/19 -j MASQUERADE && \
              # CloudFlare China
              iptables -t nat -A POSTROUTING -o $iface -d 45.156.92.0/24 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 45.156.93.0/24 -j MASQUERADE && \
              # CloudFlare WARP
              iptables -t nat -A POSTROUTING -o $iface -d 162.159.192.0/24 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 162.159.193.0/24 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 162.159.195.0/24 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 188.114.97.0/24 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 188.114.98.0/24 -j MASQUERADE && \
              iptables -t nat -A POSTROUTING -o $iface -d 188.114.99.0/24 -j MASQUERADE"; then
      echo "Masquerade rules added successfully for $iface with Akamai IP ranges"
    else
      echo "Error adding Masquerade rules for $iface. Trying fallback method..."
      if su -c "iptables -t nat -A POSTROUTING -o $iface -j SNAT --to-source 2.17.128.0"; then
        echo "Masquerade rules added successfully for $iface with Akamai IP ranges"
      else
        echo "Error adding fallback Masquerade rule for $iface. Check iptables output."
      fi
    fi
    
    if su -c "iptables -A OUTPUT -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 500"; then
      echo "TCPMSS rule added successfully for $iface"
    else
      echo "Error adding TCPMSS rule for $iface. Skipping this step."
    fi
  done

  echo "Configuring TOS and DSCP for specific domains..."
  tos_rules=(
    # Социальные сети
    "https://facebook.com"
    "https://fbcdn.net"
    "https://instagram.com"
    "https://tiktok.com"
    "https://twitter.com"
    "https://t.co"
    "https://linkedin.com"
    "https://pinterest.com"
    "https://vk.com"
    "https://vk.me"
    
    # Мессенджеры
    "https://whatsapp.com"
    "https://telegram.org"
    "https://t.me"
    "https://viber.com"
    "https://signal.org"
    
    # Стриминговые сервисы
    "https://netflix.com"
    "https://nflxvideo.net"
    "https://spotify.com"
    "https://deezer.com"
    "https://twitch.tv"
    "https://ttvnw.net"
    "https://hulu.com"
    "https://primevideo.com"
    "https://disneyplus.com"
    
    # Google сервисы
    "https://google.com"
    "https://googleapis.com"
    "https://gstatic.com"
    "https://googleusercontent.com"
    "https://chrome.com"
    "https://googlevideo.com"
    "https://youtube.com"
    "https://ytimg.com"
    "https://ggpht.com"
    
    # Microsoft сервисы
    "https://microsoft.com"
    "https://microsoftonline.com"
    "https://live.com"
    "https://office.com"
    "https://office365.com"
    "https://skype.com"
    "https://azure.com"
    
    # Облачные хранилища
    "https://dropbox.com"
    "https://onedrive.com"
    "https://box.com"
    "https://icloud.com"
    "https://mega.nz"
    
    # Почтовые сервисы
    "https://gmail.com"
    "https://outlook.com"
    "https://yahoo.com"
    "https://mail.ru"
    
    # Игровые платформы
    "https://steampowered.com"
    "https://steamcommunity.com"
    "https://epicgames.com"
    "https://ea.com"
    "https://origin.com"
    "https://battlenet.com"
    "https://playstation.com"
    "https://xbox.com"
    
    # Видеоконференции
    "https://zoom.us"
    "https://meet.google.com"
    "https://teams.microsoft.com"
    "https://webex.com"
    
    # Образовательные платформы
    "https://coursera.org"
    "https://udemy.com"
    "https://edx.org"
    "https://duolingo.com"
    
    # Новостные сайты
    "https://cnn.com"
    "https://bbc.com"
    "https://reuters.com"
    "https://news.google.com"
    "https://4pda.me"
    "https://4pda.to"
    "https://4pda.ru"
    
    # Развлекательные платформы
    "https://reddit.com"
    "https://imgur.com"
    "https://9gag.com"
    "https://giphy.com"
    
    # Файлообменники
    "https://wetransfer.com"
    "https://mediafire.com"
    "https://4shared.com"
    
    # Рабочие инструменты
    "https://github.com"
    "https://githubusercontent.com"
    "https://gitlab.com"
    "https://bitbucket.org"
    "https://stackoverflow.com"
    "https://slack.com"
    "https://atlassian.com"
    "https://jira.com"
    "https://trello.com"
    
    # Платежные системы
    "https://paypal.com"
    "https://stripe.com"
    "https://visa.com"
    "https://mastercard.com"
    
    # Торговые площадки
    "https://amazon.com"
    "https://ebay.com"
    "https://aliexpress.com"
    "https://walmart.com"
    
    # Карты и навигация
    "https://maps.google.com"
    "https://waze.com"
    "https://here.com"
    "https://openstreetmap.org"
  )

  for domain in "${tos_rules[@]}"; do
    echo "Adding TOS rule for domain: $domain"
    
    if su -c "iptables -t mangle -A PREROUTING -m string --string \"$domain\" --algo bm --to 65535 -j TOS --set-tos Maximize-Throughput"; then
      echo "TOS rule added successfully for $domain"
    else
      echo "Error adding TOS rule for $domain. Trying DSCP method..."
      if su -c "iptables -t mangle -A PREROUTING -m string --string \"$domain\" --algo bm --to 65535 -j DSCP --set-dscp-class AF41"; then
        echo "DSCP rule added successfully for $domain with AF41 class"
      else
        echo "Error adding DSCP rule for $domain. Trying DSCP fallback method..."
        if su -c "iptables -t mangle -A PREROUTING -m string --string \"$domain\" --algo bm --to 65535 -j DSCP --set-dscp 46"; then
          echo "DSCP rule added successfully for $domain with codepoint 46"
        else
          echo "Failed to add any rule for $domain. Check iptables output."
        fi
      fi
    fi
  done
}

configure_masquerade_and_tos

exit 0