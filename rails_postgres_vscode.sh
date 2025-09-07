#!/bin/bash

# Lista de pacotes a serem instalados
PACKAGES=(
  "curl" "git" "openssh-client" "vim" "snap" "gnupg" "lsb-release" "weasyprint" "libmagickwand-dev"
  # Postgres packages
  "ca-certificates" "postgresql" "postgresql-client" "libpq-dev"
  # Javascript
  "npm" "build-essential" "libssl-dev" "libssl1.0.0"
)

echo "Passo 01 - Instalando dependencias"

# Preparando para instalar postgres em versões mais antigas do ubuntu
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
. /etc/os-release
sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] http://apt-archive.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"

# Adiciona repositório bionic para pacotes do ruby 2.3.8
echo "deb http://security.ubuntu.com/ubuntu/ bionic-security main" >> /etc/apt/sources.list

echo "Atualizando repositórios..."
sudo apt update

echo "Checando pacotes..."
for PACKAGE in "${PACKAGES[@]}"; do
  if dpkg -l | grep -q "^ii  $PACKAGE "; then
    echo "$PACKAGE já está instalado."
  else
    echo "Instalando $PACKAGE..."
    sudo apt install -y "$PACKAGE"
  fi
done

echo "Passo 01 - FIM"

echo "Passo 02 - Checando RVM e Ruby On Rails"

# ================================================ RVM E RUBY ON RAILS ================================================================#

if [ -d "$HOME/.rvm" ]; then
    echo "O RVM está instalado."
else
  echo "O RVM NÃO está instalado."
  echo "Instalando RVM e Ruby On Rails"
  gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  \curl -sSL https://get.rvm.io | bash -s stable --ruby --rails
  source ~/.rvm/scripts/rvm # Comando para recarregar o shell
fi

echo "Documentação RVM Install: https://rvm.io/rvm/install"

# ================================================ RVM E RUBY ON RAILS =====================ff===========================================#

echo "Passo 02 - FIM *"

echo "Passo 03 - Checando VS Code"

# ======================================================= VS CODE =====================================================================#

if command -v code &> /dev/null; then
  echo "O VS Code está instalado."
else
  echo "O VS Code NÃO está instalado."
  echo "Instalando VS Code..."
  sudo snap install code --classic

  echo "Instalando extensões do vscode"

  VSCODE_EXTENSIONS=(
    # HTML extensions
    "zignd.html-css-class-completion" "formulahendry.auto-rename-tag" "aki77.html-erb"
    # Lint extensions
    "misogi.ruby-rubocop"
    # Rails extensions
    "aki77.rails-db-schema" "hridoy.rails-snippets" "vortizhe.simple-ruby-erb"
    # Styles
    "castwide.solargraph" "mikestead.dotenv" "vscode-icons-team.vscode-icons"
    # Git
    "eamodio.gitlens"
    # Docker
    "ms-azuretools.vscode-docker" "ms-vscode-remote.remote-containers"
  )

  for EXT in "${VSCODE_EXTENSIONS[@]}"; do
    echo "Instalando extensão: $EXT"
    code --install-extension "$EXT"
  done

  echo "Instalando core gems das extensões"
  gem install solargraph rubocop
fi

echo "Documentação VS Code: https://code.visualstudio.com/docs/setup/linux#_installation"

# ======================================================= VS CODE =====================================================================#

echo "Passo 03 - FIM"

echo "Passo 04 - Instalando NVM e Yarn"

curl -O https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
npm install --global yarn

echo "Passo 04 - FIM"

echo "Passo 05 - LIMPEZA"

sudo apt autoremove -y
sudo apt clean

echo "Passo 05 - FIM"

echo "INSTALAÇÃO CONCLUÍDA!!"

echo "1. Para as mudanças fazerem efeito você precisa modificar as preferência do terminal para executar com o login do shell"
echo "2. Instale a última versão do node com nvm install node"
