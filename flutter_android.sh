#!/bin/bash

echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando dependências do Flutter e Android Studio..."
sudo apt install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    lib32stdc++6 \
    lib32z1 \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    lib32gcc-s1 \
    lib32ncurses6 \
    lib32z1 \
    adb \
    clang \
    cmake \
    ninja-build \
    libgtk-3-dev

echo "Dependências instaladas com sucesso."

# Instalar o Flutter SDK
echo "Baixando o Flutter SDK..."
FLUTTER_DIR="$HOME/flutter"
if [ ! -d "$FLUTTER_DIR" ]; then
  curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_stable.tar.xz
  echo "Extraindo o Flutter SDK..."
  tar -xf flutter_linux_stable.tar.xz -C "$HOME"
  rm flutter_linux_stable.tar.xz
  echo "Flutter SDK instalado em $FLUTTER_DIR"
else
    echo "O Flutter já está instalado em $FLUTTER_DIR"
fi

# Adicionar Flutter ao PATH
if ! grep -q 'export PATH="$PATH:$HOME/flutter/bin"' ~/.bashrc; then
  echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
  export PATH="$PATH:$HOME/flutter/bin"
fi

# Instalar o Android Studio
echo "Baixando o Android Studio..."
ANDROID_STUDIO_DIR="/opt/android-studio"
if [ ! -d "$ANDROID_STUDIO_DIR" ]; then
  curl -LO https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.2.1.15/android-studio-2023.2.1.15-linux.tar.gz
  echo "Extraindo o Android Studio..."
  sudo tar -xvzf android-studio-2023.2.1.15-linux.tar.gz -C /opt
  sudo mv /opt/android-studio-* /opt/android-studio
  rm android-studio-2023.2.1.15-linux.tar.gz
  echo "Android Studio instalado em $ANDROID_STUDIO_DIR"
else
echo "O Android Studio já está instalado em $ANDROID_STUDIO_DIR"
fi

# Configurar variáveis de ambiente para Android SDK
ANDROID_HOME="$HOME/Android/Sdk"
if [ ! -d "$ANDROID_HOME" ]; then
  mkdir -p "$ANDROID_HOME"
fi

if ! grep -q 'export ANDROID_HOME=$HOME/Android/Sdk' ~/.bashrc; then
  echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
  echo 'export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"' >> ~/.bashrc
  export ANDROID_HOME="$HOME/Android/Sdk"
  export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
fi

# Aceitar as licenças do Android SDK
echo "Aceitando licenças do Android SDK..."
flutter doctor --android-licenses

# Verificar instalação do Flutter
echo "Executando flutter doctor para verificar a instalação..."
flutter doctor

echo "Limpeza..."
sudo apt autoremove -y
sudo apt clean

echo "Instalação concluída! Abra um novo terminal ou execute 'source ~/.bashrc' para carregar as configurações."
echo "Se quiser instalar a interface do android studio execute no terminal /opt/android-studio/bin/studio.sh"
