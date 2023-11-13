# My config_files

Collection of config files and setup instructions for software I use. This includes `rc` and `env` files, `.config` files, and software setup through GUIs.
It's best to soft-link to the files in this repo instead of directly copying them to their respective locations.

Clone this repo to you home directory:

```zsh
cd
git clone git@github.com:MantiMantilla/config_files.git
```

Update the system before setting any of this software up.

```zsh
nobara-sync
# or
# sudo dnf update
```

## 1. Kitty

Kitty is a hardware accelerated, highly customizable graphical terminal emulator.

Setting up Kitty on GNOME requires updating gsettings, setting up Nautilus File Explorer with a custom terminal plugin (remove `nautilus-extension-gnome-terminal`) and replacing the gnome-terminal binary with a symbolic link to the Kitty binary. If you do not wish to get rid of gnome-terminal, any `.desktop` file that launches a terminal window needs to be updated to launch a Kitty window instead.

I recommend using dconf Editor for anything involving gsettings, but terminal commands are provided.

```zsh
sudo dnf install kitty
```

```zsh
gsettings set org.gnome.desktop.default-applications.terminal exec kitty
gsettings set org.gnome.desktop.default-applications.terminal exec-arg command
```

```zsh
pip install --user nautilus-open-any-terminal
sudo dnf remove nautilus-extension-gnome-terminal
```

```zsh
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
```

```zsh
sudo dnf remove gnome-terminal
ln -s /usr/bin/kitty /usr/bin/gnome-terminal
```

Kitty is not compatible with a lot of patched Nerd-Fonts. I recommend the [CascadiaCode](https://github.com/ryanoasis/nerd-fonts/releases) fonts, they are referenced in the Kitty config.

```zsh
wget -qO - https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.tar.xz | sudo tar -xJ -C /usr/share/fonts/
rm /usr/share/fonts/LICENSE /usr/share/fonts/readme.md /usr/share/fonts/README.md
```

Link to this config (you may need to delete the `$HOME/.config/kitty` directory):

```zsh
cd ~/.config/
ln -s $HOME/config_files/kitty ./kitty
```

### 1.1 Zsh

Zsh is a highly extensible shell scripting environment. Features like cycling through completion options and default shorthand commands make it more comfortable to use than alternatives like bash.

Zsh can be installed through dnf and can be setup as the default system shell.

```zsh
sudo dnf install zsh util-linux-user
chsh -s $(which zsh)
sudo dnf remove util-linux-user
```

Log out and log back in for the changes to take effect. When running zsh for the first time, don't configure it. OMZ will take care of that.

#### 1.1.1 Oh My Zsh

Oh My Zsh is a framework for managing a Zsh configuration. It enables easy inclusion of completion files, plugins and themes.

```zsh
cd
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Let's now link to our own `.zshrc`.
```zsh
ln -s $HOME/config_files/zsh/.zshrc .zshrc
```

##### 1.1.1.1 PowerLevel10k

PowerLevel10k is a collection of beautiful theme settings and reasonable Zsh feature setup. Can be installed through Oh My Zsh. Do not follow the configuration prompts. We will use our own P10k config.

```zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -s $HOME/config_files/zsh/.p10k.zsh .p10k.zsh
```

### 1.2 Git

Git is a distributed version control system used mainly for software development. For proper commit signatures, set up with ssh-agent.

```zsh
git config --global user.name "MantiMantilla"
git config --global user.email "<user>@protonmail.com"
```

To set up a secure ssh connection to remote Git repositories, follow the steps from [this link](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

#### 1.2.1 GitHub CLI

GitHub CLI (`gh`) is a command line tool for managing remote repositories hosted on GitHub.

```zsh
sudo dnf install gh
gh auth login
```

Follow the configuration prompts. Make sure to set up SSH as the preferred protocol.

#### 1.2.2 LazyGit

TUI for Git repo management. Used to integrate with LunarVim.

```zsh
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit
```

### 1.3 Ranger

Terminal based file explorer with vim-like bindings.

```zsh
cd ~/.config/
sudo dnf install ranger
ln -s $HOME/config_files/ranger/rc.conf ./ranger/rc.conf
```

### 1.4 Micromamba

Micromamba is a lightweight package manager CLI utility used primarily for Python and R environments.

```zsh
cd
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
micromamba shell completion
ln -s $HOME/config_files/mamba/.mambarc ./.mambarc
```

You may also want to install miniforge. Currently, exporting an environment that includes pip packages is unsupported. When installing, do not enable mamba initialization as the `.zshrc` already addresses this with an alias.

```zsh
cd
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
rm Miniforge3-$(uname)-$(uname -m).sh
```

Restart your shell for changes to take effect.

### 1.5 LunarVim

Preconfigured Neovim environment. Includes themes, a plugin manager, versatile default plugins, completion tools, git integration, and more. Make sure to install NodeJS and rust before setting up LunarVim. Also, make sure to install the latest release available as it might not be v1.3.

```zsh
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
cd ~/.config
ln -s $HOME/config_files/lvim/config.lua ./lvim/config.lua
```

For LunarVim to be available as an application in context menus or in GNOME search, link the included (in it's installation path) `.desktop` to where it can be detected.

```zsh
cd
ln -s $HOME/.local/share/lunarvim/lvim/utils/desktop/lvim.desktop $HOME/.local/share/applications/lvim.desktop
```

#### 1.5.1 nvm / NodeJS

A runtime environment for JavaScript. Should be installed through nvm and not directly.

```zsh
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
```

Restart your terminal for the changes to take effect.

```zsh
nvm install --lts
```

#### 1.5.2 Rust

A compiled language for low-level software development. Can be installed through rust-up.

```zsh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

You may need to restart your shell.

#### 1.5.3 Zathura

Simple document viewer with vim-like motions. Integrates with VimTex in LunarVim for a versatile development experience for the LaTeX language.

```zsh
cd ~/.config/
sudo dnf install zathura zathura-pdf-mupdf
ln -s $HOME/config_files/zathura/zathurarc ./zathura/zathurarc
```

### 1.6 Docker

Docker is a platform for developing, building, and running container applications.

To install, follow the instructions from [this link](https://docs.docker.com/engine/install/fedora/).

#### 1.6.1 Portainer

Portainer is an engine-agnostic container management platform. It hosts a web service with a GUI for easy container management.

To install, follow the instructions from [this link](https://docs.portainer.io/start/install-ce/server/docker/linux).

#### 1.6.2 Kubernetes / Minikube

Orchestration engine for containers. A local cluster can be installed with Minikube which includes kubectl.

```zsh
cd
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
rm minikube-latest.x86_64.rpm
```

#### 1.6.3 K9s

A TUI for managing Kubernetes clusters.

```zsh
wget -qO - https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz | tar -xz -C $HOME/.local/bin/
rm $HOME/.local/bin/LICENSE $HOME/.local/bin/README.md
```

#### 1.6 LSD

A prettier alternative to the `ls` command.

```zsh
sudo dnf install lsd
```

#### 1.7 SDKMAN!

An SDK installer and manager for UNIX systems. Can be used to install different JDK versions and the Spring Boot CLI, among others.

```zsh
curl -s "https://get.sdkman.io" | bash
```

Tools like Spring Boot CLI can be installed as follows:

```zsh
sdk install springboot
```

## 2. GNOME

GNOME is a desktop environment that comes prepackaged with Fedora, Nobara, and many other Linux and BSD distributions.

### 2.1 GNOME Settings

The settings application bundled with GNOME.

### 2.3 GNOME Tweaks

Minor GTK settings.

### 2.3 GNOME Extensions

Third-party modifications to GNOME for ease of use and appearance.

### 2.4 Login Background Image

Even though Nobara supports changing the session manager, I've tried changing to SDDM and features like the lock-screen simply do not work. The next best thing to achieve a login screen with a background image is a tool called gdm-settings.

## 3. Virtualization

Tools like kvm, qemu and VirtMan, along with several libraries, are required to run some Docker / Kubernetes environments and virtual machines.

## 4. Steam

An online store for video games. Runs Windows games on Linux through the Proton (Wine) compatibility layer.

## 5. DNF

The Fedora package manager. I make minor changes to the config for convenience and faster installs.

## 6. OBS

A screencasting and streaming app with scene compositing features.

### 6.1 MESA Hardware Encoding

Freeworld drivers to enable H265 encoding on AMD graphics cards.

## 7. Timeshift

An application included with Nobara that backs up BTRFS drives.

## 8. OpenTabletDriver

An application included with Nobara that manages tablet devices (such as Huion and Wacom). Replaces the Wacom interface in GNOME Settings.
