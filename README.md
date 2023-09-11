# My config_files

Collection of config files and setup instructions for software I use. This includes `rc` and `env` files, `.config` files, and software setup through GUIs.
It's best to soft-link to the files in this repo instead of directly copying them to their respective locations.

Clone this repo to you home directory:

```zsh
cd
git clone git@github.com:MantiMantilla/config_files.git
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

Link to this config (you may need to delete the `$HOME/.config/kitty` directory):

```zsh
cd $HOME/.config/
ln -s $HOME/config_files/kitty ./kitty
```

### 1.1 Zsh

Zsh is a highly extensible shell scripting environment. Features like cycling through completion options and default shorthand commands make it more comfortable to use than alternatives like bash.

Zsh can be installed through dnf and can be setup as the default system shell.

#### 1.1.1 Oh My Zsh

Oh My Zsh is a framework for managing a Zsh configuration. It enables easy inclusion of completion files, plugins and themes.

##### 1.1.1.1 PowerLevel10k

PowerLevel10k is a collection of beautiful theme settings and reasonable Zsh feature setup. Can be installed through Oh My Zsh.

### 1.2 Git

Git is a distributed version control system used mainly for software development. For proper commit signatures, set up with ssh-agent.

#### 1.2.1 GitHub CLI

GitHub CLI (`gh`) is a command line tool for managing remote repositories hosted on GitHub.

### 1.3 Ranger

Terminal based file explorer with vim-like bindings.

### 1.4 Micromamba

Micromamba is a lightweight package manager used primarily for Python and R environments.

### 1.5 LunarVim

Preconfigured Neovim environment. Includes themes, a plugin manager, versatile default plugins, completion tools, git integration, and more.

### 1.5.1 NodeJS

A runtime environment for JavaScript. Should be installed through nvm and not directly.

### 1.5.2 Rust

A compiled language for low-level software development. Can be installed through rust-up.

#### 1.5.3 Zathura

Simple document viewer with vim-like motions. Integrates with VimTex in LunarVim for a versatile development experience for the LaTeX language.

### 1.6 Docker

Docker is a platform for developing, building, and running container applications.

#### 1.6.1 Portainer

Portainer is an engine-agnostic container management platform. It hosts a web service with a GUI for easy container orchestration.

## 2. GNOME

GNOME is a desktop environment that comes prepackaged with Fedora, Nobara, and many other Linux and BSD distributions.

### 2.1 GNOME Settings

The settings application bundled with GNOME.

### 2.3 GNOME Tweaks

Minor GTK settings.

### 2.3 GNOME Extensions

Third-party modifications to GNOME for ease of use and appearance.

## 3. Steam

An online store for video games. Runs Windows games on Linux through the Proton (Wine) compatibility layer.

## 3. DNF

The Fedora package manager. I make minor changes to the config for convenience and faster installs.
