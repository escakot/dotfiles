# escakot's macOS dotfiles

## Disclaimer
This is my customized setup. You are free to use it if you want, but use it at your own risk.
Please note that the git config has my git username and email, so you will need to modify these yourself.

## Usage

### Automatic Install

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/escakot/dotfiles/main/install.sh)"
```

### Manual Install

Clone this repo into your home directory. Then cd into that directory and run the boostrap script.

```sh
git clone https://github.com/escakot/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```