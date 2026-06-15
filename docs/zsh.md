# Zsh

Primary shell: antidote plugin bundle, fzf/fzf-tab theming, PATH setup, Node/Rust/Bun/fnm.

## Install (stow)

```bash
cd ~/.dotfiles
stow zsh
stow spaceship fzf    # recommended companions
```

Pair with `cosmic-term` for matching fzf colors — see [cosmic-term.md](cosmic-term.md).

## Main files

| File | Purpose |
|------|---------|
| `~/.zshrc` | Shell init, PATH, fzf theme, tool env |
| `~/.zsh_plugins` | antidote plugin list |
| `~/.zsh_alias` | Custom aliases and wrappers |

## First login

`~/.zshrc` may auto-clone on first run:

- [antidote](https://github.com/mattmc3/antidote) → `~/.antidote`
- [fzf](https://github.com/junegunn/fzf) → `~/.fzf`
- [tmux TPM](https://github.com/tmux-plugins/tpm) → `~/.tmux/plugins/tpm`

## Gotchas

- Some paths are user-specific (`/home/justin-p/...`).
- `better-commits` and `zoxide` wrappers are disabled under `CURSOR_AGENT` / `CURSOR_TRACE`.
