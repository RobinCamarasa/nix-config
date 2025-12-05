# Nix-OS configuration

This is my personal, flake-based NixOS and Home Manager configuration, tailored for multiple systems and focused on reproducibility, modularity, and developer productivity.

## 🗂️ Project Structure

```
.
├── Makefile                        # Helper make commands (e.g., build, apply)
├── flake.nix                       # Nix flake entry point
├── flake.lock                      # Locked dependencies for reproducibility
├── README.md                       # You're here!
├── homes/                          # Home Manager configurations for each host
│   ├── homeThinkpad.nix
│   └── ...
├── modulesHm/                      # Modular Home Manager config
│   ├── bundles/                    # Logical config bundles (grouped features)
│   ├── default.nix                 # Entry point to all HM modules
│   ├── features/                   # Individual feature modules (shell, apps)
│   │   ├── nvim/                   # Neovim config (Nix + Lua plugins)
│   │   └── ...
│   └── homebrewed-features/        # Custom app configs not covered elsewhere
├── systems/                        # System-level NixOS configurations
│   ├── configurationThinkpad.nix
│   ├── ...
│   ├── hardware-configurationThinkpad.nix
│   └── hardware-configurationThinkpad.nix
└── utils/                          # Shared helpers/utilities
```

## ✨ Features

- **Multi-host support**: Easily switch between different setup
- **Flake-powered**: Declarative and reproducible across environments.
- **Modular Home Manager config**: Cleanly separated into bundles and features.
- **Neovim setup**: Managed in Nix with Lua plugin configuration.
- **Development tools**: Includes git, direnv, tmux, starship, and more.
- **Custom scripts**: Shell utilities for Neovim clipboard, tmux session management, etc.

## 🛠️ Usage

> Prerequisites: Nix flakes enabled.

- Create an envrc with the name of the host as for example:
```bash
export NIXHOST="thinkpad"
```

- Test system config:

```bash
make -e test
```

- Build & apply system config:

```bash
make -e rebuild
```

- Clean system:

```bash
make -e clean
```

> Note that some part of the configuration require GPG keys and ssh keys unavailable in this repository for obvious security reasons

## Author

- [Robin Camarasa](https://github.com/RobinCamarasa)

