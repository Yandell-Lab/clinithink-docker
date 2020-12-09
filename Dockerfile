FROM library/ubuntu:20.10

# Install system packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y gnupg2 nmap software-properties-common sudo tzdata xvfb wget winbind

# Configure the machine
RUN ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
RUN cat /etc/sudoers
RUN sed -i 's/%sudo	ALL=(ALL:ALL) ALL/%sudo	ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

# Install Wine
RUN dpkg --add-architecture i386
RUN wget https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key
RUN add-apt-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ groovy main'
RUN apt update
RUN apt install --install-recommends -o APT::Immediate-Configure=0 -y winehq-devel

# Create and switch to clinithink user
RUN adduser --disabled-password --gecos '' clinithink
RUN usermod -a -G sudo clinithink
USER clinithink
WORKDIR /home/clinithink

# Create a Wine bottle without prompting to install Mono or Gecko
RUN xvfb-run sh -c 'WINEDLLOVERRIDES="mscoree,mshtml=" wineboot --init && wineserver -w' && rm -f /tmp/.X*-lock
RUN wget https://dl.winehq.org/wine/wine-mono/5.1.1/wine-mono-5.1.1-x86.msi
RUN xvfb-run sh -c "wine msiexec /i *.msi && wineserver -w" && rm -f /tmp/.X*-lock
RUN rm *.msi

# Install Clinithink
COPY CLiX_insight_Setup_6_800_135_1.exe /home/clinithink
RUN xvfb-run sh -c 'wine CLiX_insight_Setup_6_800_135_1.exe /VERYSILENT && wineserver -w'
RUN sed -i 's/launch = clix_insight.exe/launch = clix_insight.exe --conf=insight-prod.conf/' ~/.wine/drive_c/Clinithink/insight/bin/service.cfg
RUN rm -f *.exe

# Start the server
EXPOSE 49120
CMD wineboot &> /dev/null && bash
