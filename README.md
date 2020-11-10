# just-devops

## Setup environment

- zsh

```
apt update && apt install zsh
```

- oh-my-zsh

```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# When the installation is done, edit ~/.zshrc and set ZSH_THEME="agnoster"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Add plugins=(zsh-autosuggestions) in ~/.zshrc. If doesn't work then add `source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.sh`
```

- Install docker: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04

- [k3d](https://k3d.io): `wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash`


