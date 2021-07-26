echo

ssh root@192.168.1.18 << EOF
uptime;
df -h;
cat /proc/loadavg
EOF

pause

