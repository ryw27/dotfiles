# Neovim Config

Leader is `<Space>`. Plugin-specific keymaps live with their plugin specs in `lua/plugins/*.lua`; general maps live in `lua/vim-keymaps.lua`.

## GNU Stow

Recommended dotfiles layout:

```text
~/dotfiles/
├── nvim/.config/nvim/
└── tmux/.tmux.conf
```

Move and stow:

```sh
mkdir -p ~/dotfiles/nvim/.config
mv ~/.config/nvim ~/dotfiles/nvim/.config/nvim
cd ~/dotfiles
stow nvim
```

For tmux:

```sh
mkdir -p ~/dotfiles/tmux
mv ~/.tmux.conf ~/dotfiles/tmux/.tmux.conf
cd ~/dotfiles
stow tmux
```

Move or back up existing target files before running `stow`.

## Core Editing

| Key                       | Action                                 |
| ------------------------- | -------------------------------------- |
| `n` / `N`                 | Next / previous search match, centered |
| `<Esc>`                   | Clear search highlight                 |
| `J`                       | Join lines without moving cursor       |
| `J` / `K` in visual       | Move selection down / up               |
| `<` / `>` in visual       | Indent and keep selection              |
| `<leader>d`               | Delete without yanking                 |
| `<leader>p`               | Paste replace without yanking          |
| `<leader>y` / `<leader>Y` | Yank to system clipboard               |

## Files, Search, Buffers

| Key                         | Action                                  |
| --------------------------- | --------------------------------------- |
| `<leader>ff`                | Find files                              |
| `<leader>fp`                | Find git/project files                  |
| `<leader>fP`                | Find projects                           |
| `<leader>fb`                | Find open buffers                       |
| `<leader>fr`                | Recent files                            |
| `<leader>fc`                | Find config files                       |
| `<leader>fC`                | Grep config files                       |
| `<leader>fg`                | Live grep                               |
| `<leader>fw` / `<leader>fW` | Grep word / WORD under cursor           |
| `<leader>/`                 | Fuzzy search current buffer             |
| `<leader>fR`                | Resume last picker                      |
| `<leader>ft`                | Find TODO comments                      |
| `<leader>fx` / `<leader>fX` | Document / workspace diagnostics        |
| `<C-d>` / `<C-u>` in picker | Page preview down / up                  |
| `<C-q>` in picker           | Send selections to quickfix             |
| `<leader><Tab>`             | Switch to last buffer                   |
| `[b` / `]b`                 | Previous / next buffer                  |
| `[q` / `]q`                 | Previous / next quickfix item           |
| `<leader>bd` / `<leader>bD` | Delete buffer / all buffers             |
| `<leader>cd`                | Set local cwd to current file directory |
| `<leader>fz`                | Jump to recent directory via zoxide     |
| `-`                         | Open parent directory in Oil            |
| `<leader>e` / `<leader>E`   | Neo-tree floating / left sidebar        |

## Harpoon

| Key                         | Action                        |
| --------------------------- | ----------------------------- |
| `<leader>a`                 | Add current file              |
| `<C-e>`                     | Harpoon menu                  |
| `<M-1>` ... `<M-4>`         | Jump to Harpoon slots 1-4     |
| `<leader>ap` / `<leader>an` | Previous / next Harpoon entry |

## LSP and Code

| Key                         | Action                                        |
| --------------------------- | --------------------------------------------- |
| `K`                         | Hover docs                                    |
| `<C-s>`                     | Signature help                                |
| `gd` / `gD`                 | Definition / declaration                      |
| `gi` / `gr` / `gy`          | Implementation / references / type definition |
| `<leader>fs` / `<leader>fS` | Document / workspace symbols                  |
| `<leader>ca`                | Code action                                   |
| `<leader>rn`                | Rename symbol                                 |
| `<leader>cf`                | Format buffer/range                           |
| `<leader>cL`                | Show transient code lens                      |
| `<leader>ih`                | Toggle inlay hints                            |

## Surround

| Key                 | Action                  |
| ------------------- | ----------------------- |
| `ys{motion}{char}`  | Add surrounding pair    |
| `yss{char}`         | Surround current line   |
| `cs{old}{new}`      | Change surrounding pair |
| `ds{char}`          | Delete surrounding pair |
| `S{char}` in visual | Surround selection      |

## Diagnostics and Lists

| Key                         | Action                                    |
| --------------------------- | ----------------------------------------- |
| `[d` / `]d`                 | Previous / next diagnostic                |
| `<leader>vd`                | Diagnostic float                          |
| `<leader>xd`                | Diagnostics to quickfix                   |
| `<leader>xx` / `<leader>xX` | Workspace / buffer diagnostics in Trouble |
| `<leader>xL` / `<leader>xQ` | Location / quickfix list in Trouble       |
| `<leader>xt`                | TODOs in Trouble                          |
| `<leader>cs`                | Document outline                          |
| `<leader>cl`                | LSP defs/refs/impls                       |

## Git

| Key                         | Action                            |
| --------------------------- | --------------------------------- |
| `<leader>gg`                | LazyGit                           |
| `<leader>gf`                | LazyGit for current file repo     |
| `<leader>gl`                | LazyGit log                       |
| `[h` / `]h`                 | Previous / next hunk              |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk                |
| `<leader>hS` / `<leader>hR` | Stage / reset buffer              |
| `<leader>hp`                | Preview hunk                      |
| `<leader>hd` / `<leader>hD` | Diff this / diff against previous |
| `<leader>hb` / `<leader>hB` | Blame line / toggle inline blame  |
| `ih` in operator/visual     | Select hunk                       |

## Sessions, UI, Vim

| Key                                        | Action                                       |
| ------------------------------------------ | -------------------------------------------- |
| `<leader>qs` / `<leader>ql`                | Restore project / last session               |
| `<leader>qd`                               | Stop saving current session                  |
| `<leader>vh` / `<leader>vk`                | Search help / keymaps                        |
| `<leader>vc` / `<leader>vC`                | Commands / command history                   |
| `<leader>vs`                               | Spell suggestions                            |
| `<leader>?`                                | Buffer-local keymaps                         |
| `<leader>nh` / `<leader>nd`                | Notification history / dismiss notifications |
| `<leader>nl` / `<leader>na` / `<leader>ne` | Noice last / all / errors                    |
| `<leader>id`                               | Toggle Snacks scope dim                      |
| `<leader>u`                                | Undotree                                     |
| `<leader>z`                                | Zen mode                                     |
| `[t` / `]t`                                | Previous / next TODO comment                 |
| `q` in help/qf/etc.                        | Close special buffer                         |

## Debug and Test

| Key                         | Action                          |
| --------------------------- | ------------------------------- |
| `<F5>` / `<F8>`             | Continue                        |
| `<F10>` / `<F11>` / `<F12>` | Step over / into / out          |
| `<leader>b` / `<leader>B`   | Toggle / conditional breakpoint |
| `<leader>Dl` / `<leader>Dt` | Run last / terminate            |
| `<leader>De`                | Eval expression/selection       |
| `<leader>Du`                | Toggle DAP UI                   |
| `<leader>Dr` / `<leader>Dc` | REPL / console UI               |
| `<leader>DT` / `<leader>Dv` | Stack trace / variables UI      |
| `<leader>Dw` / `<leader>Db` | Watches / breakpoints UI        |
| `<leader>tr`                | Run nearest test                |
| `<leader>ts` / `<leader>ta` | Run suite / all tests           |
| `<leader>td`                | Debug nearest test              |
| `<leader>tv`                | Toggle test summary             |
| `<leader>to`                | Open test output                |
| `<leader>tS`                | Stop test run                   |

## Markdown

| Key                           | Action                                |
| ----------------------------- | ------------------------------------- |
| `<CR>` in insert              | Continue or end list item             |
| `<Tab>` / `<S-Tab>` in insert | Demote / promote list item            |
| `o` / `O`                     | Open list item below / above          |
| `<leader>x`                   | Toggle checkbox                       |
| `<C-r>`                       | Recalculate list numbering            |
| `dd` / visual `d`             | Delete and recalculate list numbering |
|  |
