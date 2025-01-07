# basic info 

## tmux
The tmux config file should be installed at ~/.tmux.conf. 
To so, we should create a symlink: 
```
sudo ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
```
### install TPM and plugins
After setting up the tmux conf file we need to install TPM:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then, we load that into memory with `tmux source ~/.tmux.conf`.
Once that done, we install all the plugins from the conf file with `[prefix] + I`.

## vim
After installing vim and setting up the vimrc file, we need to install Vundle:
```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
Once complete, we install the plugins by invoking the `:PluginInstall` command.

## rofi
The rofi config file should be set up at ~/.config/rofi/config.
To do so, we create this symlink:
```
sudo ln -s ~/dotfiles/rofi/config ~/.config/rofi/config
```

## bash_profile

This sets some basic bash profile settings:
```bash
sudo ln -s ~/dotfiles/.bash_profile ~/.bash_profile
```

In order for the changes to be applied, the `.bash_profile` file must be 
sourced in the main `.bashrc` file by adding this at the end: 

```bash
# At the top or near the top of ~/.bashrc:
if [ -f "$HOME/.bash_profile" ]; then
    . "$HOME/.bash_profile"
fi
```
