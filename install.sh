#!/usr/bin/env bash

cd $(dirname "$0")
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
git clone --recurse-submodules https://github.com/freenet/freenet-core
cd freenet-core
cargo install --path crates/core
cargo install --path crates/fdev
echo -e "\
[Unit]\n\
Description=FreeNet daemon\n\
After=network.target\n\
\n\
[Service]\n\
MemorySwapMax=0\n\
TimeoutStartSec=infinity\n\
Type=notify\n\
User=$USER\n\
Group=$USER\n\
ExecStart=/home/$USER/.cargo/bin/freenet\n\
Restart=on-failure\n\
KillSignal=SIGINT\n\
\n\
[Install]\n\
WantedBy=default.target\n\
" | sudo tee /etc/systemd/system/freenet.service
sudo systemctl daemon-reload
sudo systemctl enable freenet
sudo systemctl restart freenet
sudo reboot