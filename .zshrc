if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
autoload -U colors && colors
alias tmux='tmux -f ~/.config/nvim/.tmux.conf'
export PATH="$HOME/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export VIRTUAL_ENV_DISABLE_PROMPT=1
export TERMINAL=kitty
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --exclude .git'
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/node-v22.15.0-linux-x64/bin"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias updt='sudo apt update && sudo apt full-upgrade -y'
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

