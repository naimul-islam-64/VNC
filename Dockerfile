FROM --platform=linux/amd64 ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y && apt install --no-install-recommends -y xfce4 xfce4-goodies tigervnc-standalone-server novnc websockify sudo xterm init systemd snapd vim net-tools curl wget git tzdata
RUN apt update -y && apt install -y dbus-x11 x11-utils x11-xserver-utils x11-apps
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:mozillateam/ppa -y
RUN echo 'Package: *' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:jammy";' | tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
RUN apt update -y && apt install -y firefox
RUN apt update -y && apt install -y xubuntu-icon-theme
RUN apt install -y cpulimit bc

# Tune kernel memory behavior to avoid OOM kills
RUN echo 'vm.swappiness=10' >> /etc/sysctl.conf
RUN echo 'vm.overcommit_memory=2' >> /etc/sysctl.conf
RUN echo 'vm.overcommit_ratio=90' >> /etc/sysctl.conf

RUN touch /root/.Xauthority

EXPOSE 5901
EXPOSE 6080

# Limits explained:
# ulimit -v 471040  → caps virtual memory at ~460MB (90% of 512MB) in KB
# ulimit -m 471040  → caps resident memory at ~460MB
# cpulimit -l 45    → caps total CPU at 45% of 1 core (= 90% of 0.5 CPU)
CMD bash -c "\
  ulimit -v 471040 && \
  ulimit -m 471040 && \
  vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
  openssl req -new -subj \"/C=JP\" -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
  websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
  cpulimit -l 45 --include-children -b -p \$\$ && \
  tail -f /dev/null"
