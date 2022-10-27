#!/usr/bin/env bash
# minimal webserver running on non-modified image
# modified from: https://www.linux-magazine.com/Issues/2021/250/Bash-Web-Server


# open firewall a little
(
  sleep 2s
  iptables -w -I nixos-fw -p tcp --dport 80 -j nixos-fw-accept
  ip6tables -w -I nixos-fw -p tcp --dport 80 -j nixos-fw-accept
) &

while true; do
  RESPONSE="hostnamectl:
$(hostnamectl)

networkctl status:
$(networkctl status)

date: $(date)"
  LENGTH=${#RESPONSE}

  echo -ne "HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\nContent-Length: ${LENGTH}\r\n\r\n${RESPONSE}" | nc -l 80
done
