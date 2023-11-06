echo "################ Download Prometheus & Alertmanager ################"
wget https://github.com/prometheus/prometheus/releases/download/v2.37.5/prometheus-2.37.5.linux-amd64.tar.gz
wget https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.linux-amd64.tar.gz
tar -xvf prometheus-2.37.5.linux-amd64.tar.gz 
tar -xvf alertmanager-0.25.0.linux-amd64.tar.gz
echo "################ Deploy Prometheus ################"
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus
sudo cp file-yaml/prometheus.yml /etc/prometheus/
sudo cp prometheus-2.37.5.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.37.5.linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-2.37.5.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.37.5.linux-amd64/console_libraries /etc/prometheus
sudo cp service/prometheus.service /etc/systemd/system/
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
sudo chown -R prometheus:prometheus /usr/local/bin/prometheus
sudo chown -R prometheus:prometheus /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
echo "################ Deploy alertmanager ################"
sudo useradd --no-create-home --shell /bin/false alertmanager
sudo mkdir -p /etc/alertmanager
sudo mkdir -p /data/alertmanager
sudo cp alertmanager-0.25.0.linux-amd64/amtool /usr/local/bin
sudo cp alertmanager-0.25.0.linux-amd64/alertmanager /usr/local/bin
sudo cp service/alertmanager.service /etc/systemd/system/
sudo cp file-yaml/alertmanager.yml /etc/alertmanager/
sudo chown alertmanager:alertmanager /usr/local/bin/amtool 
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown -R alertmanager:alertmanager /etc/alertmanager/*
sudo chown -R alertmanager:alertmanager /data/alertmanager/
echo "################ Enable Service prometheus ################"
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl enable alertmanager
sudo systemctl start prometheus
sudo systemctl start alertmanager
echo "################ Verify Service prometheus & alertmanager ################"
STATUS1="$(systemctl is-active prometheus.service)"
STATUS2="$(systemctl is-active alertmanager.service)"
if [ "${STATUS1}" = "active" ]; then
    echo "Service Prometheus = Active"
else 
    echo "Service prometheus not running.... Please Check Your Config "   
fi
if [ "${STATUS2}" = "active" ]; then
    echo "Service AlertManager = Active"
else 
    echo "Service alertmanager not running.... Please Check Your Config "  
fi
