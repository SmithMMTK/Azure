
```bash
gitrepo=https://github.com/SmithMMTK/nodejs-express.git
webappname=az300webapp$RANDOM

rm -rf quickstart
mkdir quickstart
cd quickstart

git clone $gitrepo


cd nodejs-docs-hello-world

az webapp up -n $webappname --location "southeastasia" --resource-group $webappname --sku S1


az webapp deployment source config \
--name webappname \
--resource-group webappname \
--repo-url $gitrepo \
--branch master --manual-integration
 
```