<p align="center">
    <img src="https://github.com/ZyrkProject/masternode-install/blob/master/images/header.png">
</p>

<a href="https://discord.gg/QHRk9NF"><img src="https://discordapp.com/api/guilds/569285452213911552/embed.png" alt="Discord Server" /></a> <a href="https://twitter.com/intent/follow?screen_name=ProjectZyrk"><img src="https://img.shields.io/twitter/follow/ProjectZyrk.svg?style=social&logo=twitter" alt="Follow on Twitter"></a> [![HitCount](http://hits.dwyl.io/zyrkproject/masternode-install.svg)](http://hits.dwyl.io/zyrkproject/masternode-install)

# Zyrk Masternode Setup Guide
***

## Generating a Masternode Private Key

Please follow the below steps to generate a Masternode private key.

1.  Download and install the latest Zyrk wallet on Windows - https://github.com/ZyrkProject/zyrk-core/releases
2.  Open the wallet and go to **Help**->**Debug window** and then click on the **Console** tab.
3.  In the console screen type and execute this command: **masternode genkey**  
4.  Copy this to a blank text document as you will need this later.

## VPS Wallet Installation

You will need a VPS for this part of the guide, so you do not have to keep your Windows wallet open 24/7. 
If you do not have a VPS you can get one from here [Vultr.](https://www.vultr.com/?ref=8069528)

Once you have setup your VPS you need to download and run the install script using this command:

```
cd && bash -c "$(wget -O - https://raw.githubusercontent.com/ZyrkProject/masternode-install/master/install.sh)"
```

The installation script will give you 6 different options to choose from:

1. Install a fresh Masternode
2. Update Masternode Wallet
3. Start Masternode
4. Stop Masternode
5. Show Masternode status
6. Rebuild Masternode

Once your VPS installation has finished type **zyrk-cli getinfo** and check the block count against the official explorer.
When the block count is the same you have finished with the setup.
***

## Windows Wallet Setup

Once your VPS is up and running and your Zyrk wallet has synced, you then need to configure your Windows wallet.

1. Open your Zyrk Windows wallet.
2. Click **Help** -> **Debug window** and then click on the **console** tab.
3. Enter **getnewaddress MN1 masternode** and send exactly **7500** ZYRK to this address.
4. **Please note this address must start with an X not a Z**. If you have a **Z** address read above step again.
4. Go to back into the **console** tab and type **masternode outputs**
5. Copy this to the same place your copied your **Masternode Private Key** earlier.
6. Go to %appdata%\Zyrk and create a file called **masternode.conf** and fill it with the following.

Layout of masternode.conf
```
LABEL IP_ADDRESS:PORT MASTERNODE_PRIVATE_KEY MASTERNODE_OUTPUTS
```

Example masternode.conf
```
MN1 127.0.0.1:19655 5J35uXCcNFaQByrnK4YEFqCPQErJ8SzU7QPyjFg5atiC4BH3yqU 3d4011efd463f55cad9021899b8c7b06494e27ba0d186cc2de39d6d0d0ebbb4d 0
```

Restart your Windows wallet and go to the masternode tab. You should see your masternode sitting there with a status of **MISSING**.
Click **Start all** and the status should change to **PRE_ENABLED**. After 15-30 minutes this should then change to **ENABLED**.
***

## Checking if Masternode Enabled

1. Log back into your VPS and type **zyrk-cli masternode status**
2. If you see **Masternode successfully started** everything is setup correctly.
3. Check the official block explorer to see if your masternode is listed - https://explorer.zyrk.io/masternodes
4. You are now finished and should start receiving rewards in the next **1 - 3 hours**. 