# Neovim Config

Leader is `<Space>`.

## Editing

| Key                 |                            |
| ------------------- | -------------------------- |
| `<Esc>`             | clear search highlight     |
| `J`                 | join lines, keep cursor    |
| `J` / `K` in visual | move selection down / up   |
| `<leader>d`         | delete without yanking     |
| `<leader>p`         | paste over without yanking |
| `<leader>y` / `Y`   | yank to system clipboard   |

Completion (blink, insert): - `<C-j>` / `<C-k>` next/prev, - `<C-h>` toggle docs, - `<C-f>` / `<C-b>` scroll docs

## Surround (nvim-surround)

| Key                 |                         |
| ------------------- | ----------------------- |
| `ys{motion}{char}`  | add surrounding pair    |
| `yss{char}`         | surround current line   |
| `cs{old}{new}`      | change surrounding pair |
| `ds{char}`          | delete surrounding pair |
| `S{char}` in visual | surround selection      |

## Files and search (fzf)

| Key                 |                                |
| ------------------- | ------------------------------ |
| `<leader>ff`        | find files                     |
| `<leader>fp`        | git files                      |
| `<leader>fP`        | projects (Snacks)              |
| `<leader>fb`        | buffers                        |
| `<leader>fr`        | recent files                   |
| `<leader>fz`        | zoxide (recent dirs)           |
| `<leader>fc` / `fC` | config files / grep config     |
| `<leader>fg`        | live grep                      |
| `<leader>fw` / `fW` | grep word / WORD               |
| `<leader>/`         | lines in current buffer        |
| `<leader>fR`        | resume last picker             |
| `[b` / `]b`         | prev / next buffer             |
| `<leader>bd` / `bD` | delete buffer / all buffers    |
| `<leader>cd`        | `lcd` to this file’s directory |
| `-`                 | Oil (parent dir as a buffer)   |
| `<leader>e` / `E`   | Neo-tree float / left          |

In a picker: `<C-d>` / `<C-u>` page preview; `<C-q>` send matches to quickfix.

## LSP

After a language server attaches.

| Key                 |                                                                     |
| ------------------- | ------------------------------------------------------------------- |
| `K`                 | Hover — docs for the symbol under the cursor.                       |
| `<C-s>`             | Signature help — argument list for the function in insert.          |
| `gd` / `gD`         | definition / declaration                                            |
| `gi` / `gr` / `gy`  | implementation / references / type definition                       |
| `<leader>fs` / `fS` | document / workspace **symbols** (flat picker: functions, types, …) |
| `<leader>ca`        | code action                                                         |
| `<leader>rn`        | rename                                                              |
| `<leader>ih`        | toggle inlay hints                                                  |
| `<leader>ch`        | clangd: switch `.c` ↔ `.h`                                          |
| `<leader>cv`        | Python venv                                                         |

## Diagnostics, symbols, quickfix

**Diagnostics** = errors/warnings from LSP + nvim-lint.

**fzf** (`<leader>f…`) = fuzzy-pick one item
**Trouble** (`<leader>x…`) = **panel that stays open** while you fix things.

| Key                 |                                                       |
| ------------------- | ----------------------------------------------------- |
| `[d` / `]d`         | prev / next diagnostic                                |
| `<leader>vd`        | float for the diagnostic on this line                 |
| `<leader>fx` / `fX` | fzf: this file / workspace                            |
| `<leader>xx` / `xX` | Trouble: workspace / this file                        |
| `<leader>cs`        | Trouble **outline** — symbols tree, stays on the side |
| `<leader>cl`        | Trouble LSP tree (defs / refs / impls)                |
| `<leader>ft`        | TODOs (fzf)                                           |
| `<leader>xt`        | TODOs (Trouble panel)                                 |
| `[t` / `]t`         | prev / next TODO in file                              |

**Quickfix** = one **global** list of locations (compiler, grep, or diagnostics you dumped there). `[q` / `]q` walk it. `:cdo` / `:cfdo` run a command on every item / every file.

**Loclist** = same as quickfix but **per window**.

| Key          |                                           |
| ------------ | ----------------------------------------- |
| `<leader>xd` | WARN+ diagnostics → quickfix (for `:cdo`) |
| `<leader>xQ` | Trouble: show the quickfix list           |
| `<leader>xL` | Trouble: show the loclist                 |

## Messages

| Key          |                                                         |
| ------------ | ------------------------------------------------------- |
| `<leader>nh` | **Snacks** — `vim.notify` toasts, history               |
| `<leader>nd` | **Snacks** — dismiss toasts                             |
| `<leader>nl` | **Noice** — last message (`nvim_echo` / `:echo` stream) |
| `<leader>na` | **Noice** — all of those messages (`:Noice`)            |
| `<leader>ne` | **Noice** — errors from that stream                     |

## Git

| Key                        |                                  |
| -------------------------- | -------------------------------- |
| `<leader>gg` / `gf` / `gl` | LazyGit / this repo / log        |
| `[h` / `]h`                | prev / next hunk                 |
| `<leader>hs` / `hr`        | stage / reset hunk (visual too)  |
| `<leader>hS` / `hR`        | stage / reset buffer             |
| `<leader>hp`               | preview hunk                     |
| `<leader>hd` / `hD`        | diff this / diff against `~`     |
| `<leader>hb` / `hB`        | blame line / toggle inline blame |
| `ih`                       | select hunk (operator / visual)  |

`:DiffviewOpen` / `:DiffviewFileHistory` for multi-file diffs.

## Harpoon

| Key                 |                  |
| ------------------- | ---------------- |
| `<leader>ja`        | add current file |
| `<C-e>`             | menu             |
| `<M-1>` … `<M-4>`   | slots 1–4        |
| `<leader>jp` / `jn` | prev / next      |

## Sessions, UI, Vim

| Key                        |                                              |
| -------------------------- | -------------------------------------------- |
| `<leader>qs` / `ql` / `qd` | restore project / last session / stop saving |
| `<leader>vt`               | colorscheme picker (Enter = save default)    |
| `<leader>vh` / `vk`        | help tags / keymaps                          |
| `<leader>vc` / `vC` / `vs` | commands / command history / spell           |
| `<leader>?`                | buffer-local keymaps                         |
| `<leader>id`               | toggle scope dim                             |
| `<leader>u`                | undotree                                     |
| `<leader>z`                | zen mode                                     |

## Debug and test (TODO: Check these work)

| Key                         |                                 |
| --------------------------- | ------------------------------- |
| `<F5>`                      | continue                        |
| `<F10>` / `<F11>` / `<F12>` | step over / into / out          |
| `<leader>b` / `B`           | toggle / conditional breakpoint |
| `<leader>Du`                | toggle DAP UI                   |
| `<leader>tr`                | nearest test                    |
| `<leader>ts` / `ta`         | suite / all tests               |
| `<leader>td`                | debug nearest test              |
| `<leader>tv` / `to`         | summary / output                |
