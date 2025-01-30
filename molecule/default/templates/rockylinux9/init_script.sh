#!/bin/bash

systemctl start sshd 
sleep 3 

# Execute the original CMD
exec "$@"
EOF