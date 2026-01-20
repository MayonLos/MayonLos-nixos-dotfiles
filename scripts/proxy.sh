sudo mkdir -p /run/systemd/system/nix-daemon.service.d/

sudo tee /run/systemd/system/nix-daemon.service.d/proxy.conf <<'EOF'
[Service]
Environment="https_proxy=socks5h://localhost:7890"
EOF

sudo systemctl daemon-reload
sudo systemctl restart nix-daemon