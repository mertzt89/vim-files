# Neovim Configuration

## Requirements

- Neovim v0.11 or greater.
- git.
- A `C` compiler. Can be `gcc`, `tcc` or `zig`.
- [make](https://www.gnu.org/software/make/), the build tool.
- [npm cli](https://docs.npmjs.com/cli/v8/commands/npm). Javascript package manager.
- [nodejs](https://nodejs.org/es/). Javascript runtime. Required by the language servers listed above.
- (optional) [ripgrep](https://github.com/BurntSushi/ripgrep). Improves project wide search speed.
- (optional) [fd](https://github.com/sharkdp/fd). Improves file search speed.
- (optional) A patched font to display icons. I hear [nerdfonts](https://www.nerdfonts.com/) has a good collection.

## Installation

- Backup your existing configuration if you have one.

- If you don't know the path of the Neovim configuration folder use this command.

```sh
nvim --headless -c 'echo stdpath("config") | quit'
```

- Now clone this repository in that location.

```sh
git clone https://github.com/mertzt89/vim-files <path-from-above>
```

> Do not execute this command as is. Replace `<path-from-above>` with the correct path from the previous step.

- Next time you start Neovim all plugins will be downloaded automatically. 
