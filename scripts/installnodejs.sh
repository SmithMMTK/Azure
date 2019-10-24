echo "Start Custom Script." >> /home/boot_log.txt
echo "Change directory." >> /home/boot_log.txt
cd ~/
echo "Start cloning Git." >> /home/boot_log.txt
git clone https://github.com/SmithMMTK/nodejs-express.git
echo "Update APT." >> /home/boot_log.txt
sudo apt-get update -y
echo "Install Nodejs." >> /home/boot_log.txt
sudo apt-get install nodejs -y
echo "Install Npm." >> /home/boot_log.txt
sudo apt-get install npm -y
echo "Change to Nodejs-express directory." >> /home/boot_log.txt
cd ~/nodejs-express
echo "Run Nodejs" >> /home/boot_log.txt
nodejs index.js
