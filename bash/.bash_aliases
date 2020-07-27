
ii() {
    nohup nautilus -w $1 > /dev/null 2>&1 &
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
