### Setting up vale
1. Install vale with mason `MasonInstall vale` then create a .vale.ini file.

```toml
StylesPath = .
MinAlertLevel = suggestion
Packages = RedHat, alex
[*]
BasedOnStyles = Vale, RedHat, alex
```
2. Sync the mason package with the global configuration.
```sh
~/.local/share/nvim/mason/packages/vale/vale --config=$HOME/.config/vale/.vale.ini sync
```

Source: https://docs.rockylinux.org/books/nvchad/vale_nvchad/#__tabbed_1_2

### Download shellharded

```sh
curl -o shellharden.tar.gz \
https://github.com/anordal/shellharden/releases/latest/download/shellharden-x86_64-unknown-linux-gnu.tar.gz
tar -xzf shellharden.tar.gz -C ~/.local/bin/
```
### Download biomejs

```sh
curl -o biome \
https://github.com/biomejs/biome/releases/latest/download/biome-linux-x64

mv biome ~/.local/bin/
```
