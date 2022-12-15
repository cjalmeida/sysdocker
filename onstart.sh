#/bin/bash
#
# commands to run on start

# start tailscale daemon
nohup tailscaled --tun=userspace-networking &> /var/log/tailscaled.log &

# connect to network if possible
tailscale up --timeout 5s || true

# at daemon
atd

# vm stop command 
echo '#!/bin/bash
/usr/local/bin/vast stop instance $(cat ~/.vast_containerlabel | cut -d . -f 2)' > /usr/local/bin/vm-stop
chmod +x /usr/local/bin/vm-stop

# schedule hard stop in 8h
echo /usr/local/bin/vm-stop | at now + 8 hours
