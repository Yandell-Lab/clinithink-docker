The files in this repository make it possible to run the Clinithink software on
CentOS Linux without a virtual machine.

## Getting started
1. Clone this repository in `/opt`.
2. Copy `CLiX_insight_Setup_6_800_135_1.exe` to `/opt/clinithink-docker`.
3. Run `sudo ./build.sh` to create the `clinithink` Docker image for the root
   user.
4. Run `chcon -t bin_t run.sh` to allow systemd to invoke `run.sh`.
5. Run `sudo cp clinithink.service /etc/systemd/system/` to install the Clinithink
   service.
6. Run `sudo systemctl start clinithink` to start Clinithink. It will bind to
   TCP port 49120 on the host.
7. Run `sudo systemctl enable clinithink` to automatically start the Clinithink
   service on boot.
8. Run
   `sudo semanage port -a -t http_port_t -p tcp 49120 && sudo firewall-cmd --zone=public --add-port=49120/tcp --permanent && sudo firewall-cmd --reload`
   to allow connecting to Clinithink from another machine.

The Docker container contains a Wine bottle which contains Clinithink. The Wine
bottle is stored in  `/var/lib/containers/storage/volumes/clinithink` on the
host and can be freely backed up or manipulated from the host. Or use
`sudo docker attach clinithink` to get a shell on the container.
