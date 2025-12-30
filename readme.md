# zinit-volta

**Note: zinit and zplugin are different names of the same thing**

An empty repository to aid zplugin's hooks-hacks. You can fork it to have a private copy of it :)

Example uses:

When what's needed is an atclone'' hook to e.g. install a software (plus atpull'' hook to update it):

```
# The invocation uses https://github.com/zdharma-continuum/null repo as a placeholder
# for the atclone'' and atpull'' hooks
# run-atpull：Even if this repository has not been updated, atpull will still be executed during `zinit update weineel/zinit-volta`.
# atpull"%atclone" :If the same command is used for installation and updating.

# completion 文件（比如 _volta）只有放在 atclone 中生成才会被安装，更新后需要手动重新安装 `zinit creinstall weineel/zinit-volta`
# !!! turbo 模式，可能会导致 starship 获取版本号等信息失败。
export VOLTA_HOME="$HOME/.volta" && export PATH="$VOLTA_HOME/bin:$PATH"
zinit as"program" pick"volta" \
  atclone"curl https://get.volta.sh | bash && volta completions zsh > _volta" \
  atpull"curl https://get.volta.sh | bash -s -- --skip-setup && volta completions zsh > _volta" \
  run-atpull \
  for weineel/zinit-volta
```
