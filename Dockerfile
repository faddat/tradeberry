FROM ghcr.io/faddat/sos-lite

COPY motd /etc/motd

COPY osmosis.service /etc/systemd/system/osmosis.service
COPY front.service /etc/systemd/system/front.service
COPY pi-dashboard.service /etc/systemd/system/pi-dashboard.service


# Disk space thing
# Download starport, too
RUN sed -i -e "s/^CheckSpace/#!!!CheckSpace/g" /etc/pacman.conf && \
        # Dependencies & monitoring tools
        pacman -Syyu --noconfirm wget sudo && \
        # Install Osmosis
        wget https://github.com/plutobell/pi-dashboard-go/releases/download/v1.3.1/pi-dashboard-go_linux_armv7_64 && \
        mv pi-dashboard-go_linux_armv7_64 /usr/bin/pi-dashboard && \
        chmod +x /usr/bin/pi-dashboard && \
        systemctl enable pi-dashboard.service && \
        wget https://github.com/osmosis-labs/osmosis/releases/download/v3.1.0/osmosisd-3.1.0-linux-arm64 && \
        mv osmosisd-3.1.0-linux-arm64 /usr/bin/osmosisd && \
        chmod +x /usr/bin/osmosisd && \
        systemctl enable osmosis.service && \
        wget https://github.com/osmosis-labs/networks/raw/main/osmosis-1/genesis.json && \
	echo 'cd /home/gaia' >> /usr/local/bin/firstboot.sh && \
	echo 'INIT="gaiad init tradeberrhy$RANDOM"' >> /usr/local/bin/firstboot.sh && \
	echo 'su -c gaia bash -c $INIT' >> /usr/local/bin/firstboot.sh && \
	echo 'cp /genesis.json /root/osmosisd/config' >> /usr/local/bin/firstboot.sh && \
        sed -i -e "s/^#!!!CheckSpace/CheckSpace/g" /etc/pacman.conf


