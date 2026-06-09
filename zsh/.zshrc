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
if [ -d "/nix/var/nix/profiles/default/share/zsh/site-functions" ]; then
    fpath=("/nix/var/nix/profiles/default/share/zsh/site-functions" $fpath)
fi
if [ -d "$HOME/.nix-profile/share/zsh/site-functions" ]; then
    fpath=("$HOME/.nix-profile/share/zsh/site-functions" $fpath)
fi
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
(( $+commands[starship] )) && eval "$(starship init zsh)"

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
(( $+commands[rg] )) \
	&& export RIPGREP_CONFIG_PATH=~/.ripgreprc \
	&& alias grep='rg'
(( $+commands[fd] )) \
	&& alias find='fd'
if (( $+commands[eza] )); then
	alias ls='eza -F'
	alias ll='eza -F -lBghm -snew --time-style=full-iso'
	chpwd() {
		eza -a -F
	}
elif (( $+commands[exa] )); then
	alias ls='exa -F'
	alias ll='exa -F -lBghm -snew --time-style=full-iso'
	chpwd() {
		exa -a -F
	}
fi
(( $+commands[nvim] )) \
	&& alias nv='nvim' \
	&& alias nvc='() { nvim <("$@") }'
(( $+commands[htop] )) \
	&& alias top='htop -d 10'
(( $+commands[duf] )) \
	&& alias df='duf'
(( $+commands[bat] )) \
	&& alias cat='bat'
(( $+commands[prettyping] )) \
	&& alias ping='prettyping'
(( $+commands[dust] )) \
	&& alias du='dust'
(( $+commands[procs] )) \
	&& alias ps='procs'

# shortcuts
(( $+commands[trans] )) \
	&& alias ej='trans en:ja'
(( $+commands[aws] )) \
	&& alias awslocalstack='aws --endpoint-url http://localhost:4566 --profile localstack'
(( $+commands[checksec] )) \
	&& alias chefsec='() { checksec --file="$@" }'

# completion for lima
(( $+commands[limactl] )) \
	&& eval "$(limactl completion zsh)"
# completion for uv
(( $+commands[uv] )) \
	&& eval "$(uv generate-shell-completion zsh)"
# completion for uvx
(( $+commands[uvx] )) \
	&& eval "$(uvx --generate-shell-completion zsh)"

# expect package contains unbuffer
if (( $+commands[unbuffer] )); then
	(( $+commands[less] )) \
		&& alias ubless='() { unbuffer "$@" |& less -SR }'
#		&& compdef ubless='unbuffer'
fi

if (( $+commands[fzf] )); then
	eval "$(fzf --zsh)"

	if (( $+commands[docker] )); then
		function dx() {
			local container

			container=$(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" \
				| fzf --header-lines=1 --prompt="Select Container> " \
				| awk '{print $1}')

			if [[ -n "$container" ]]; then
				echo "Entering ${container}..."

				docker exec "$@" -it "$container" /bin/sh -c '
					if command -v zsh >/dev/null 2>&1; then
						exec zsh
					elif command -v bash >/dev/null 2>&1; then
						exec bash
					else
						exec sh
					fi
				'
			fi
		}
	fi

	if (( $+commands[nix] )); then
		function nd() {
			local base_dir="${HOME}/nix-templates"
			local selected

			local templates=()
			for f in "${base_dir}"/*/flake.nix(N); do
				templates+=("$(basename "$(dirname "$f")")")
			done

			if [[ ${#templates[@]} -eq 0 ]]; then
				echo "Error: No templates found containing flake.nix in ${base_dir}/*" >&2
				return 1
			fi

			selected=$(printf "%s\n" "${templates[@]}" | fzf --prompt="Select Nix Template> ")

			if [[ -n "$selected" ]]; then
				local target_flake="${base_dir}/${selected}"
				echo "Loading nix devShell from ${selected}..."

				nix develop "${target_flake}" -c zsh
			fi
		}
	fi
fi

