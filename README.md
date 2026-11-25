# dotfiles

Joey's configuration for an Arch Linux desktop running Hyprland (Lua config) and the
BlueRune shell, plus the shell, editor and terminal setup that goes with it. One
command, `./dot`, copies the files between this repository and a machine.

This repository is public. `dot backup` scans everything for secrets before it is
copied in, and refuses anything that looks like a credential.

## What's in here

| Path | What it holds |
| --- | --- |
| `dotfiles.list` | The list of files and folders that are backed up, grouped |
| `home/` | Those files, laid out as they sit under `~` |
| `system/` | A snapshot of the system: installed packages, enabled services, a few `/etc` files |
| `dot`, `lib/` | The tool |
| `tests/` | Sandboxed tests for the tool |
| `backup.sh`, `deploy.sh` | Old names, kept as shortcuts for `./dot backup` and `./dot deploy` |

The groups in `dotfiles.list` are `shell`, `editor`, `terminal`, `desktop` (Hyprland and
friends), `bluerune`, `theming`, `apps` and `system`. Run `./dot list` to see every entry.

## Set up a new machine

You need `git` and `bash`. `rsync` is needed only for `dot backup`, `status` and `diff`.

1. Clone the repository:

   ```bash
   mkdir -p ~/Projects && cd ~/Projects
   git clone https://github.com/jyapayne/dotfiles
   cd dotfiles
   ```

   If you use BlueRune, clone it to `~/Projects/bluerune` first (or set `BLUERUNE_DIR`);
   the deploy offers to run its installer from there.

2. Preview the deploy. This only shows what would change:

   ```bash
   ./dot deploy
   ```

   It asks which groups you want (press Enter for all), lists each file as new (`+`) or
   different from what you have (`~`), and then asks `Write these N files? [y/N]`.
   Files that exist only on your machine are never touched.

3. Answer `y` to write the files. Every file that gets replaced is first saved to
   `~/.local/state/dotfiles/backups/<timestamp>/`.

4. Answer the optional steps that follow. Each defaults to no. The first three come up
   when the `system` group is part of the deploy:

   - **Packages**: installs the packages in `system/packages/native.txt` with
     `sudo pacman -S --needed`, and those in `foreign.txt` with `yay` (or `paru`).
     Packages that no repository has are skipped and listed.
   - **Services**: enables the units in `system/units/` that exist and aren't enabled yet
     (system ones with `sudo systemctl enable`, user ones with `systemctl --user enable`).
   - **/etc files**: copies `system/etc/` back with `sudo`, after showing which files
     differ. The old versions go into the same backup.
   - **BlueRune**: runs
     `~/Projects/bluerune/scripts/install-bluerune.sh --profile ~/Projects/bluerune/dist/profiles/joey`
     if the checkout exists.

If something looks wrong afterwards, undo the deploy:

```bash
./dot revert
```

It lists the deploys it can undo and asks before reverting the latest one (or name one:
`./dot revert 20261124-181500`). It restores every replaced file byte for byte, removes
the files the deploy created (unless you have edited them since), and removes folders it
created if they are empty.

### Without questions

```bash
./dot deploy --all --yes                 # write every group's files, skip the optional steps
./dot deploy --groups "shell editor" --yes
./dot deploy --everything --yes          # all groups and every optional step
./dot deploy --link --yes                # symlink into this repo instead of copying
```

With `--link`, edits under `~` change the repository directly, and moving the repository
breaks the links. Copying is the default.

## Keep the repository up to date

On the machine whose setup you want to save:

```bash
./dot status      # what differs, by group; writes nothing
./dot diff        # the changed lines (or: ./dot diff ~/.config/hypr)
./dot backup      # copy into the repo, scan for secrets, offer to commit
```

`dot backup` mirrors each entry: files deleted under `~` are deleted from the repository
copy too. It then prints the added (`+`), changed (`~`) and removed (`-`) files by group,
offers to commit with a generated message, and asks before pushing (or pass `--push`).
`--dry-run` shows the same report without writing anything, and `--no-commit` leaves the
changes staged.

To back up something new:

```bash
./dot add ~/.config/yazi --group apps
./dot add ~/.config/foo --exclude 'cache/' --exclude '*.log'
```

`dot add` checks the path for secrets first and refuses sensitive locations.

## dotfiles.list

```text
[global]
!*.swp !*~ !*.bak              # patterns left out of every entry

[terminal]
.config/kitty  !kitty.conf.bak # a folder under ~, minus one file
.tmux.conf                     # a single file

[bluerune]
.config/hypr/bluerune.lua      # inside .config/hypr, but owned by this group

[system]
@snapshot                      # package and service lists
/etc/sddm.conf                 # absolute paths are /etc files, restored with sudo
```

- Paths are relative to `~` and can't contain spaces.
- `!pattern` excludes use rsync rules: `name` matches at any depth, `/name` only at the top
  of the entry, and a trailing `/` matches folders only.
- `nolinks` leaves symlinks out of a folder (used for `~/.config/systemd`, whose
  `*.wants/` links point at system units).
- An entry inside another entry belongs to its own group. Deploying `desktop` without
  `bluerune` leaves BlueRune's files out.

The `[global]` section of this repository's list also skips `*-backup-*`,
`*.pre-bluerune`, `*.old`, `*.new` and `*.bak` files. Files over 2 MB are always skipped
and reported (`DOT_MAX_SIZE=10m ./dot backup` raises the limit).

## Secrets

Nothing in these locations is ever copied, whatever `dotfiles.list` says: `~/.ssh`,
`~/.gnupg`, cloud CLI folders (`.aws`, `.azure`, `.kube`, `.docker`), `~/.config/gh`,
password managers, browser and chat-app profiles, keyrings, and `/etc/shadow`, `sudoers`
and similar. Files named like keys, tokens, histories or databases (`*.pem`, `*_token*`,
`.env*`, `*history*`, `*.sqlite`…) are skipped too. The full lists are at the top of
[`lib/scan.sh`](lib/scan.sh).

Every file is then scanned. If `gitleaks` or `trufflehog` is installed it runs as well;
the built-in rules look for private keys, AWS, GitHub, GitLab, Slack, OpenAI, Anthropic,
OpenRouter, Google, Stripe, Hugging Face and npm tokens, JWTs, bearer tokens, URLs with
passwords, `password=`/`token=`/`api_key=` assignments and long random-looking strings.

A file with a finding is not copied, and the repository keeps its previous version. The
report masks the secret:

```text
==> Scanning for secrets (built-in rules)
  ✗ ~/.zshrc
        line 112   ai-api-key         export OPEN…"sk-o…"  [106b7c2a6963]
```

Move the secret out of the file (for example into `~/.secrets`, sourced from your shell
config and not listed in `dotfiles.list`), or exclude the file. If a finding is a false
alarm, add its fingerprint (the hex in brackets) to `.secrets-allow`, one per line.

`dot backup` exits with status 3 when it refused a file, so scripts can notice.

## Tests

```bash
bash tests/dot_tests.sh
```

The tests build a fake home folder, a fake `/etc` and a copy of this repository under
`/tmp`, put stubs for `sudo`, `pacman`, `yay`, `systemctl` and `git push` first in `PATH`,
and run each command under `env -i`. They never touch your real home folder.
