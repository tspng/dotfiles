# tspng's dotfiles

## Installation

Iinstall dotfiles on a new system with the following steps:

In you current shell, create the following alias:

```sh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Clone your dotfiles into a bare repository in a `.dotfiles` folder of your `$HOME`:

```sh
git clone --bare git@github.com:tspng/dotfiles $HOME/.dotfiles
```

Checkout the actual content from the bare repository to your `$HOME`:

```sh
dotfiles checkout
```

Configure the git repository to not show untracked files (there would be many in `$HOME`):

```sh
config config --local status.showUntrackedFiles no
```

You're done, from now on you can now type `dotfiles` commands to add and update your dotfiles as you would with `git`.
