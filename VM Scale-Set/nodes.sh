sudo apt-get update --yes
sudo apt-get install nodejs --yes
sudo apt-get install npm --yes
rm -rf nodejs_express    
git clone https://github.com/SmithMMTK/nodejs-express
cd nodejs-express
npm install --yes
nodejs app.js
