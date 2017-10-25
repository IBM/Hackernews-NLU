#!/bin/sh
set -e
function install_bluemix_cli() {
#statements
echo "Installing Bluemix cli"
curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
sudo mv cf /usr/local/bin
sudo curl -o /usr/share/bash-completion/completions/cf https://raw.githubusercontent.com/cloudfoundry/cli/master/ci/installers/completion/cf
cf --version
curl -L public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli/Bluemix_CLI_0.5.4_amd64.tar.gz > Bluemix_CLI.tar.gz
tar -xvf Bluemix_CLI.tar.gz
cd Bluemix_CLI
sudo ./install_bluemix_cli
}

function bluemix_auth() {
echo "Authenticating with Bluemix"
echo "y" | bx login -a https://api.ng.bluemix.net --apikey $API_KEY
echo "y" | bx target -o $ORG -s $SPACE
}

function deploy_application() {
  #statements
  echo "Creating service..."
  bx service create natural-language-understanding free "Hackernews-NLU"
  echo "Service created."
  git clone https://github.com/IBM/Hackernews-NLU.git
  cd Hackernews-NLU
  echo "Starting Application"
  bx app push
  echo "Application Started"
}

function destroy_application() {
  #statements
  echo "Destroying application"
  echo "y" | bx app delete HackernewsNLU
  echo "y" | bx service delete Hackernews-NLU
}

install_bluemix_cli
bluemix_auth
deploy_application
destroy_application
