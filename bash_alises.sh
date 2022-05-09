alias gds="git diff --stat=100,80"
alias gd="git difftool -y -t gvimdiff"
alias gdsc="git diff --cached --stat=100,80"
alias gdc="git difftool --cached -y -t gvimdiff"
alias gpull="git pull --rebase"

alias finds="rm cscope.files; find . -regextype posix-extended -regex '.*[.](c|cpp|h|hpp)' >cscope.files"
alias cs="finds; rm cscope.*out ; time cscope -R -b -q -k"

alias nosleep="sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias letsleep="sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target"
