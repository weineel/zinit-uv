# zinit-uv

**Note: zinit and zplugin are different names of the same thing**

An empty repository to aid zplugin's hooks-hacks. You can fork it to have a private copy of it :)

Example uses:

When what's needed is an atclone'' hook to e.g. install a software (plus atpull'' hook to update it):

```
# The invocation uses https://github.com/zdharma-continuum/null repo as a placeholder
# for the atclone'' and atpull'' hooks
# run-atpull：Even if this repository has not been updated, atpull will still be executed during `zinit update weineel/zinit-uv`.
# atpull"%atclone" :If the same command is used for installation and updating.

# install uv
zinit as"program" pick"uv" \
  atclone"curl -LsSf https://astral.sh/uv/install.sh | sh" \
  atpull"curl -LsSf https://astral.sh/uv/install.sh | sh" \
  run-atpull \
  for weineel/zinit-uv
source $HOME/.local/bin/env
# Added a zsh plugin that automatically executes source .venv/bin/activate when switching to a folder that has a .venv directory
# Create a virtual environment using the `mkvenv` command
# https://github.com/weineel/zinit-uv/blob/master/zsh-zinit-uv.plugin.zsh
# Rely on uv and direnv

# auto switch venv(WIP to support uv)
# zinit wait lucid for MichaelAquilina/zsh-autoswitch-virtualenv
```
