# to get this file, open terminal, 
# install git (sudo apt install git)
# git clone https://github.com/ahmedsaoudi/dotfiles
# to run the script: . dotfiles/init.sh

# add APPs
sudo add-apt-repository -yn ppa:christian-boxdoerfer/fsearch-daily

# don't remove this
# apt-get doesn't automatically update
# after adding a new repo.
# failing to do so, causes failure of whole
# apt install command
sudo apt-get update

sudo apt-get -y install \
  neovim \
  curl \
  tmux \
  rofi \
  xclip \
  python3-pip \
  python3-dev \
  build-essential \
  cmake \
  fonts-hack \
  # arc-theme \ no longer needed with modern ubuntu
  ubuntu-restricted-extras \
  fsearch-trunk \
  pylint \
  htop \
  nodejs \ # used by many tools (do NOT install via snap)
  gnome-sushi # macos style quick look feature for files

# sets some sensible bash defaults
sudo ln -s ~/dotfiles/.bash_profile ~/.bash_profile
sudo echo "source ~/.bash_profile" >> ~/.bashrc

# install python related stuff
pip3 install black
sudo ln -s ~/dotfiles/.pylintrc ~/.pylintc

# install & configure neovim
## set default config file for nvim
sudo ln -s ~/dotfiles/init.vim ~/.config/nvim/init.vim

## install vim-plug for nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
  --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

## tell vim-plug to install all plugins
nvim +PlugInstall +qall

# install & config tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins

# rofi installation & configuration 
mkdir ~/.config/rofi
ln -s ~/dotfiles/rofi/config ~/.config/rofi/config

# install tunisian keyboard
mkdir ~/dotfiles/tn
git clone https://github.com/ahmedsaoudi/klavietn ~/dotfiles/tn
sudo ln -s ~/dotfiles/tn/tn /usr/share/X11/xkb/symbols/tn

# install docker
curl -fsSL https://get.docker.com | sh

## to be able to invoke docker without sudo
sudo usermod -aG docker $USER
newgrp docker 

# install docker-compose
sudo curl -L \
  "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
