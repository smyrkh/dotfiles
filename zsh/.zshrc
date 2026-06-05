# path
# (N-/)
# 	N: empty string instead of errors if not exists
# 	-: follow symlink
# 	/: directory
path+=(
	${HOME}/bin(N-/)
	${HOME}/.local/bin(N-/)
	${HOME}/.composer/vendor/bin(N-/)
	${CARGO_HOME}/bin(N-/)
	${GOPATH}/bin(N-/)
	${VOLTA_HOME}/bin(N-/)
	${JAVA_HOME}/bin(N-/)
	/opt/homebrew/bin(N-/)
	/usr/local/bin(N-/)
	/usr/local/sbin(N-/)
	/usr/bin/vendor_perl(N-/)
	/usr/bin(N-/)
	/usr/sbin(N-/)
	/bin(N-/)
	/sbin(N-/)
	.
)
# you can move following by $(cd) in anywhere
cdpath=(
)

# enable color
autoload -Uz colors
colors

# set emacs keybind(default behavior of shell)
bindkey -e

# bindkey -v # vim keybind
# auto complete
autoload -Uz compinit; compinit -i

# completion style
zstyle ':completion:*:default' menu select=1

# use the same path for sudo
zstyle ':completion:*:sudo:*' command-path $path

# enable completion for alias
setopt complete_aliases

# specify <Tab> bihind
unsetopt auto_menu
# completion for hidden file
setopt globdots

# command history setting
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000

# unique history
setopt hist_ignore_all_dups
# share history
setopt share_history
# unique history's setting (fifo)
setopt hist_save_nodups
# history space deletion
setopt hist_reduce_blanks

# history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# auto pushd (can be viewed on cd -<Tab>)
setopt auto_pushd
# unique pushd
setopt pushd_ignore_dups

# specify word delimiter (useful in <C-w>)
autoload -U select-word-style
select-word-style bash

# disable beep
setopt no_beep

# move to parent directory on <C-y>
function cd-up {
	zle push-line && LBUFFER='builtin cd ..' && zle accept-line
}
zle -N cd-up
bindkey '^y' cd-up

# disable <C-d> (disable logout shortcut)
setopt ignoreeof

# custom prompt
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
setopt PROMPT_SUBST
zstyle ':vcs_info:*' formats '%m [%b]'
zstyle ':vcs_info:*' actionformats '%m [%b|%a]'
# right prompt
local colorPwd='{white}'
local colorVcs='{white}'
local colorHost='{white}'
local colorRc='{white}'
local colorTime='{white}'
case $(uname) in
	Linux)
		colorPwd='{yellow}'
		colorVcs='{cyan}'
		colorHost='{green}'
		colorRc='{blue}'
		;;
	Darwin)
		colorPwd='{red}'
		colorVcs='{magenta}'
		colorHost='{cyan}'
		colorRc='{yellow}'
		;;
esac
precmd () {
	# pwd
	local left="%F${colorPwd}[%d]%f"

	# vcs
	vcs_info
	# local right="%F${colorVcs}${vcs_info_msg_0_}%f"
	# <return code> + vcs + current time
	# local right="%F${colorRc}<%?>%f %F${colorVcs}${vcs_info_msg_0_}%f %F${colorTime}%D{%b %d}, %*%f"
	# <return code> + vcs
	local right="%F${colorRc}<%?>%f %F${colorVcs}${vcs_info_msg_0_}%f"

	# caluculate space length
	local invisible='%([BSUbfksu]|([FK]|){*})'
	local leftwidth=${#${(S%%)left//$~invisible/}}
	local rightwidth=${#${(S%%)right//$~invisible/}}
	local padwidth=$(($COLUMNS - ($leftwidth + $rightwidth) % $COLUMNS))
	print -P $left${(r:$padwidth:: :)}$right
}
_vcs_precmd () { vcs_info }
add-zsh-hook precmd _vcs_precmd
# left prompt
# user@hostname
PROMPT="%F${colorHost}%n@%M %#%f "
# <return code> + current time
# RPROMPT="%F${colorRc}<%?>%f %F${colorTime}%D{%b %d}, %*%f"

zstyle ':vcs_info:git+set-message:*' hooks git-config-user
function +vi-git-config-user(){
	hook_com[misc]+=$(git config user.email)
}

# update prompt current time
# comment out: for wezterm copy mode
# TMOUT=1
# TRAPALRM() {
#   zle reset-prompt
# }

# compile .zshrc for loading
if [ ! -f ~/.zshrc.zwc ] || [ ~/.dotfiles/.zshrc -nt ~/.zshrc.zwc ]; then
	zcompile ~/.zshrc
fi

# load private zshrc setting
[ -f ${HOME}/.zshrc_local ] && . ${HOME}/.zshrc_local

# aliases
alias cp='cp -i'
alias mv='mv -i'
# alias mkdir='mkdir -p'
alias cdp='cd -P'

# use improve commands if exists
type rg &> /dev/null \
	&& export RIPGREP_CONFIG_PATH=~/.ripgreprc \
	&& alias grep='rg'
# type fdfind &> /dev/null \
# 	&& alias fd='fdfind' \
# 	&& alias find='fdfind'
type fd &> /dev/null \
	&& alias find='fd'
if type eza &> /dev/null; then
	alias ls='eza -F' \
	&& alias ll='eza -F -lBghm -snew --time-style=full-iso' \
	&& chpwd() { eza -a -F }
else
	type exa &> /dev/null \
		&& alias ls='exa -F' \
		&& alias ll='exa -F -lBghm -snew --time-style=full-iso' \
		&& chpwd() { exa -a -F }
fi
type nvim &> /dev/null \
	&& alias nv='nvim' \
	&& alias nvc='() { nvim <("$@") }'
type htop &> /dev/null \
	&& alias top='htop -d 10'
# type dfc &> /dev/null \
# 	&& alias df='dfc'
type duf &> /dev/null \
	&& alias df='duf'
type bat &> /dev/null \
	&& alias cat='bat'
type prettyping &> /dev/null \
	&& alias ping='prettyping'
# type ncdu &> /dev/null \
# 	&& alias du='ncdu --color dark -rr'
type dust &> /dev/null \
	&& alias du='dust'
# type httpie &> /dev/null \
# 	&& alias curl='httpie'
type procs &> /dev/null \
	&& alias ps='procs'

# shortcuts
type trans &> /dev/null \
	&& alias ej='trans en:ja'
type aws &> /dev/null \
	&& alias awslocalstack='aws --endpoint-url http://localhost:4566 --profile localstack'
# expect package contains unbuffer
type unbuffer &> /dev/null \
	&& type less &> /dev/null \
	&& alias ubless='() { unbuffer "$@" |& less -SR }'
#	&& compdef ubless='unbuffer'
type checksec &> /dev/null \
	&& alias chefsec='() { checksec --file="$@" }'

# completion for lima
type limactl &> /dev/null \
	&& eval "$(limactl completion zsh)"
# completion for uv
type uv &> /dev/null \
	&& eval "$(uv generate-shell-completion zsh)"
# completion for uvx
type uvx &> /dev/null \
	&& eval "$(uvx --generate-shell-completion zsh)"
type docker &> /dev/null \
	&& alias dx='() { docker exec -it "$@" $(docker ps | peco | awk "{print \$1}") zsh }'

