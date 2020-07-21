# distribute

Distribute my settings and management scripts throughout my servers.

## Prepare bin/distribute.sh

### ${HOME}

Set up list of files to be distributed into ${HOME}, sample:

```bash
DOTFILES="${SOURCE}/.bash_aliases ${SOURCE}/.profile ${SOURCE}/.screenrc"
```

More to be added if you wish.

### ${HOME}/bin

Set up list of management scripts to be distributed into ${HOME}/bin, sample:

```bash
BINFILES="${SOURCE}/bin/colors.sh ${SOURCE}/bin/highlight.sh"
```

More to be added if you wish.

### My servers

Set up space-delimited list of my servers:

```bash
DESTINATIONS=""
```

### Executable

Make sure the file has rights to be executed.

```bash
chmod +x ./bin/distribute.sh
```

## Public/Private keys

Script includes generation of public/private key pair and distribute public key as well.

## Run

From command line:

```bash
./bin/distribute.sh
```

## Author

Toomas Mölder

## Contribute

Through pull requests or issues. Thank you!