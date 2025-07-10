# dotfiles

## Requirements

- [gnu stow](https://www.gnu.org/software/stow/manual/stow.html)  
`pacman -S stow`

## Usage

```sh
cd dotfiles
stow PackageName
```

File structure under `PackageName` will be symlinked into `~`.