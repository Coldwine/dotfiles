eval (thefuck --alias | tr '\n' ';')
if status --is-interactive
    eval sh $HOME/.config/base16-shell/scripts/base16-default-dark.sh
end
