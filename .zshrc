# Load Powerlevel10k instant prompt if available (speeds up shell startup)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Set theme to Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable colors
autoload -U colors && colors

# Use custom tmux config
alias tmux='tmux -f ~/.config/nvim/.tmux.conf'

# Add ~/bin to PATH
export PATH="$HOME/bin:$PATH"

# Add Go installation to PATH
export PATH=$PATH:/usr/local/go/bin

# Disable venv prompt override
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Set terminal name
export TERMINAL=kitty

# Default FZF command (use fd/fdfind, ignore .git)
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --exclude .git'

# Add /usr/local/bin to PATH
export PATH="$PATH:/usr/local/bin"

# Add Node.js to PATH
export PATH="$PATH:/usr/local/node-v22.15.0-linux-x64/bin"

# Enable plugins
plugins=(git zsh-autosuggestions)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load Powerlevel10k config if it exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Update & upgrade alias
alias updt='sudo apt update && sudo apt full-upgrade -y'

# Add ~/bin again (redundant, already added above)
export PATH="$HOME/bin:$PATH"

# Add Go bin directory (for installed Go tools)
export PATH="$HOME/go/bin:$PATH"

