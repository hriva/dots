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
