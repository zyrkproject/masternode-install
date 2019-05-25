#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="Zyrk Masternode Setup"
TITLE="Zyrk Masternode Setup"
MENU="Please select one of the following options:"

OPTIONS=(1 "Install fresh Masternode"
         2 "Update Masternode wallet"
         3 "Start Masternode"
	     4 "Stop Masternode"
	     5 "Check Masternode status"
	     6 "Rebuild Masternode")

CHOICE=$(whiptail --clear\
		          --backtitle "$BACKTITLE" \
                  --title "$TITLE" \
                  --menu "$MENU" \
                  $HEIGHT $WIDTH $CHOICE_HEIGHT \
                  "${OPTIONS[@]}" \
                  2>&1 >/dev/tty)

clear
case $CHOICE in
         1)
            echo Starting the installation process...
echo Checking and installing VPS dependencies, please wait...
echo -e "Checking memory available, creating swap space if nescecary."
PHYMEM=$(free -g|awk '/^Mem:/{print $2}')
SWAP=$(swapon -s)
if [[ "$PHYMEM" -lt "2" && -z "$SWAP" ]];
  then
    echo -e "${GREEN}VPS has less than 2G of RAM available, creating swap space.${NC}"
    dd if=/dev/zero of=/swapfile bs=1024 count=2M
    chmod 600 /swapfile
    mkswap /swapfile
    swapon -a /swapfile
else
  echo -e "${GREEN}VPS has atleast 2G of RAM available.${NC}"
fi
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}VPS is not running Ubuntu 16.04. Not compatable.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 Installation must be run as root.${NC}"
   exit 1
fi
clear
sudo apt update
sudo apt-get -y upgrade
sudo apt-get install git -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils -y
sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev -y
sudo apt-get install libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev -y
sudo apt-get install libboost-all-dev -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y
sudo apt-get install libqt4-dev libprotobuf-dev protobuf-compiler -y
clear
echo VPS dependencies are now installed.
echo Creating and setting up VPS firewall...
sudo apt-get install -y ufw
sudo ufw allow 19655 
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo VPS firewall setup is completed.
echo "Downloading Zyrk Wallet (v1.1.4)..."
wget https://github.com/zyrkproject/zyrk-core/releases/download/1.1.4/zyrk-1.1.4-x86_64-linux-gnu.tar.gz
tar -xvf zyrk-1.1.4-x86_64-linux-gnu.tar.gz
chmod +x zyrk-1.1.4/bin/zyrkd
chmod +x zyrk-1.1.4/bin/zyrk-cli
sudo cp zyrk-1.1.4/bin/zyrkd /usr/bin/zyrkd
sudo cp zyrk-1.1.4/bin/zyrk-cli /usr/bin/zyrk-cli
sudo rm -rf zyrk-1.1.4-x86_64-linux-gnu.tar.gz
echo Zyrk Wallet successfully installed.
clear
echo Configuring Zyrk Wallet configuration...
RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
EXTIP=`curl -s4 icanhazip.com`
echo "Please enter your Masternode Privatekey (masternode genkey):"
read GENKEY
mkdir -p /root/.zyrk && touch /root/.zyrk/zyrk.conf
cat << EOF > /root/.zyrk/zyrk.conf
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
server=1
listen=1
daemon=1
staking=1
rpcallowip=127.0.0.1
rpcport=19656
port=19655
addnode=1.159.64.193:63700
addnode=1.215.154.59:64015
addnode=109.252.7.84:8984
addnode=109.81.215.75:23244
addnode=110.190.149.63:44431
addnode=115.211.243.71:59134
addnode=115.77.130.242:64978
addnode=116.10.142.135:5820
addnode=121.201.66.128:54932
addnode=122.59.124.31:59401
addnode=125.161.127.73:26109
addnode=125.161.130.20:63250
addnode=134.175.71.218:54884
addnode=172.10.45.202:59815
addnode=173.212.217.91:41920
addnode=173.244.44.92:55703
addnode=176.88.36.241:53217
addnode=178.120.72.144:51042
addnode=178.187.61.234:54506
addnode=184.147.48.133:58372
addnode=184.162.129.24:54106
addnode=185.153.177.5:60212
addnode=185.50.24.14:37674
addnode=185.6.53.57:58598
addnode=188.218.21.85:63469
addnode=188.234.213.120:52288
addnode=191.189.14.133:3901
addnode=192.222.239.164:55186
addnode=2.7.235.158:63530
addnode=207.180.239.207:51426
addnode=211.215.25.139:7739
addnode=212.55.74.54:50331
addnode=217.182.185.221:19655
addnode=23.130.96.44:47172
addnode=39.98.69.85:52741
addnode=45.32.203.103:42386
addnode=45.32.9.132:19655
addnode=45.59.113.99:40794
addnode=45.76.111.243:19655
addnode=45.77.37.80:36164
addnode=46.188.121.83:6394
addnode=46.201.229.51:25798
addnode=47.92.253.223:51340
addnode=5.175.116.16:44824
addnode=5.20.41.87:59030
addnode=50.53.178.252:51308
addnode=51.6.16.254:52056
addnode=68.231.75.162:53223
addnode=73.164.245.130:54779
addnode=76.193.46.227:2193
addnode=78.36.193.51:49196
addnode=80.92.29.81:17827
addnode=81.166.105.8:58027
addnode=81.227.15.206:19245
addnode=82.60.54.254:54046
addnode=83.84.31.169:62901
addnode=84.108.157.86:57223
addnode=85.15.176.1:50331
addnode=85.173.130.250:56256
addnode=86.125.238.106:52344
addnode=87.10.190.254:53036
addnode=89.230.195.67:61579
addnode=91.214.117.126:19655
addnode=93.115.27.15:49810
addnode=93.32.73.93:2803
addnode=94.180.241.171:62680
addnode=94.28.131.180:49198
addnode=95.179.159.134:54012
addnode=95.216.101.102:60816
addnode=95.216.70.224:45638
addnode=95.217.48.200:19655
addnode=95.217.48.200:41840
addnode=95.34.76.112:62324
addnode=95.46.40.13:60960
addnode=96.35.47.97:55778
addnode=97.127.212.195:50434
logtimestamps=1
maxconnections=256
masternode=1
externalip=$EXTIP
masternodeprivkey=$GENKEY
EOF
clear
./zyrkd
echo Zyrk Wallet has been successfully configured and started.
echo If you get a message asking to rebuild the database, run ./zyrkd -reindex
echo If you still have further issues please reach out a member in our Discord channel. 
echo Ensure you use this Masternode Private Key on your Windows Wallet: $GENKEY
            ;;
	    
    
         2)
sudo ./zyrk-cli stop
echo "! Stopping Zyrk Wallet !"
echo Configuring VPS firewall...
sudo apt-get install -y ufw
sudo ufw allow 19655
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo VPS firewall configured.
echo "Downloading Zyrk Wallet (v1.1.4)..."
wget https://github.com/zyrkproject/zyrk-core/releases/download/1.1.4/zyrk-1.1.4-x86_64-linux-gnu.tar.gz
echo Updating Zyrk Wallet...
tar -xvf zyrk-1.1.4-x86_64-linux-gnu.tar.gz
chmod +x zyrk-1.1.4/bin/zyrkd
chmod +x zyrk-1.1.4/bin/zyrk-cli
sudo cp zyrk-1.1.4/bin/zyrkd /usr/bin/zyrkd
sudo cp zyrk-1.1.4/bin/zyrk-cli /usr/bin/zyrk-cli
sudo rm -rf zyrk-1.1.4-x86_64-linux-gnu.tar.gz
./zyrkd
echo Zyrk Wallet update complete. 
            ;;
         3)
            ./zyrkd
            ;;
         4)
            ./zyrk-cli stop
            ;;
	     5)
	        ./zyrk-cli masternode status
	        ;;
         6)
	        ./zyrkd -reindex
            ;;
esac

