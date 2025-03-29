# Battery alarm for laptop with Linux

## Description
This script is designed to monitor the battery level of a laptop running Linux. It will send a notification when the battery level drops below a certain threshold (default is 15%) or is bigger than a certain threshold (default is 80%).

**Note**: You can change the values and modify them according to your need.

# Dependencies
 - `sudo apt-get install pulseaudio`
 - `sudo apt install libnotify-bin`

 **Note**: Please find these dependencies for your Linux distribution. 
  
# Installation
1. Save the script `alarm-status-battery-laptop.sh` in whatever directory you want.
    
    In this case I saved in `/usr/bin/`. Take into account as you need to modify the service in the line:
    ```bash
    ExecStart=/bin/bash /usr/bin/alarm-status-battery-laptop.sh
    ```

    After this `ExecStart=/bin/bash` put your path where you have your file.

2. Create a service to run the script in the background.
   ```bash
   sudo nano /etc/systemd/system/battery-laptop-alarm.service
    ```

    Before pasting this, change `User=<YOUR_NAME>`
    ```bash
    [Unit]
    Description=Check battery level and notify when high

    [Service]
    Type=oneshot
    User=<YOUR_USER>
    ExecStart=/bin/bash /usr/bin/alarm-status-battery-laptop.sh

    [Install]
    WantedBy=default.target
    ``` 
3. Create a timer in order to execute this services just created in the previous step.

    ```bash
    sudo nano /etc/systemd/system/battery.timer
    ```

    Paste this inside:
    ```bash
    [Unit]
    Description=Ejecuta el script de batería cada 2 minutos

    [Timer]
    OnUnitActiveSec=2min
    Unit=battery-laptop-alarm.service

    [Install]
    WantedBy=timers.target
    ```
4. Starting your servie

```bash
sudo systemctl daemon-reload
sudo systemctl start battery-laptop-alarm.service
sudo systemctl enable battery-laptop-alarm.service
sudo systemctl start battery.timer
sudo systemctl enable battery.timer
```

5. Check the satus
```bash
systemctl status battery-laptop-alarm.service
```

6. Restart

```bash
sudo systemctl daemon-reload
sudo systemctl restart battery-laptop-alarm.service
sudo systemctl restart battery.timer
```