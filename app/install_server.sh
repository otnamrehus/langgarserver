apt update -y  && \
apt -y install screen sudo net-tools curl git  gpg openssh-server && \
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common  && \
sudo cp /etc/ssh/sshd_config  /etc/ssh/sshd_config.backup && \
sudo echo "PermitRootLogin Yes" >> /etc/ssh/sshd_config && \
sudo echo 'root:1' | chpasswd && \
apt install docker docker-compose && \
sudo groupadd docker  && \
sudo usermod -aG docker $USER && \
sudo systemctl enable docker && \
sudo systemctl start docker && \
docker volume create portainer_data  && \
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce &&\
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import &&  \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi &&\
zerotier-cli join 565799d8f6bdd3cdx && \
zerotier-cli join 8bd5124fd6f987b8x
