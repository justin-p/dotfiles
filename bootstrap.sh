#!/bin/bash

shopt -s nullglob
shopt -s dotglob

if [[ "$0" != "/proc"* ]]; then
	cd $(dirname "$0")
fi

source bootstrap-scripts/functions.sh

############ arguments

# defaults
verbose='false'
force='false'
install=''

############ SSH

if ! [ -f "$HOME/.ssh/id_rsa" ]; then
	log "Creating a SSH key"
	ssh-keygen -t rsa -N ""
fi

############ Busybox

if has_level $LEVEL_BASIC; then
	# Busybox tools have trouble displaying colors, which breaks things
	# like git diff or grep

	if [ "$(realpath `which less`)" == "/bin/busybox" ]; then
		install_ignore_exec less
	fi

	if [ "$(realpath `which grep`)" == "/bin/busybox" ]; then
		install_ignore_exec grep
	fi

fi

############ mintty

if has_level $LEVEL_MINIMAL && is_os "msys"; then
	log "Cannot install anything on mintty; setting up profile and exiting. "
	stow bash
	stow mintty
	stow git --no-folding
	exit 0
fi

############ OS configuration

if $(hash termux-info 2>/dev/null); then # termux
	PKGCMD="apt install"
	PKGARGS="-y"
elif $(hash apt-get 2>/dev/null); then # ubuntu
	PKGCMD="sudo apt-get install"
	PKGARGS="-y"
elif $(hash apk 2>/dev/null); then # alpine
	PKGCMD="sudo apk add"
	PKGARGS="--update"
elif is_os "cygwin"; then # cygwin
	PKGCMD="apt-cyg install"
	PKGARGS=""
else
	PKGCMD=""
	PKGARGS=""
fi

log "os: $OSTYPE"
if [ "$PKGCMD" = "" ]; then
	log "no package manager detected. no package will be installed. "
	exit 1
else
	log "install command: $PKGCMD {package} $PKGARGS"
fi

############ sanity check

if is_os "linux-gnu"; then
	# Avoid root
	if [ "$EUID" -eq 0 ] && ! is_force; then
		echo "Do not run as root, to avoid folders being owned by root. Use -f to force." 2>&1
		exit 2
	fi

	# Wait for dpkg to complete pending tasks
	if pgrep -x dpkg > /dev/null; then
		echo "Please wait for dpkg to finish" 2>&1
		exit 2
	fi
fi

if is_os "cygwin" && ! is_installed "curl"; then
	echo "Please install curl using setup.exe" 2>&1
	exit 3
fi

log "checks: ok"

############ prepare

if is_os "cygwin" && ! is_installed "apt-cyg"; then
	echo "Installing apt-cyg"
	curl https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > ~/apt-cyg
	install ~/apt-cyg /bin
	rm ~/apt-cyg
fi

if is_os "linux-android linux-gnu" && has_level $LEVEL_BASIC; then
	install clang
	install make
fi

install stow
install curl

############ bash

if has_level $LEVEL_MINIMAL; then
	stow bash
	if is_os "cygwin"; then
		stow bash-cygwin --no-folding
	elif is_os "linux-android"; then
		stow bash-termux --no-folding
		stow termux --no-folding
	fi
fi

############ git

if has_level $LEVEL_MINIMAL; then
	stow git --no-folding
	install git
fi

############ python

if has_level $LEVEL_FULL; then
	install python
fi

############ vim

if has_level $LEVEL_MINIMAL; then
	stow vim --no-folding
	install vim-python vim
fi

if has_level $LEVEL_BASIC && [ ! -d ~/.vim/bundle/vimproc.vim ]; then
	log "Installing vim plugins"
	vim -c "PlugInstall vimproc.vim" -c "qa!"
	vim -c "silent VimProcInstall" -c "qa!"
	vim -c "PlugInstall" -c "qa!"
fi

############ silversearcher-ag

if has_level $LEVEL_BASIC; then
	if ! is_installed ag && is_os "linux-alpine"; then
		sudo apk --update add automake autoconf make g++ pcre-dev xz-dev
		if [ $(git clone https://github.com/ggreer/the_silver_searcher.git ~/the_silver_searcher) ]; then
			pushd ~/the_silver_searcher && 
			./build.sh && ln -s ~/the_silver_searcher/ag ~/bin/ag
			popd
		fi
	else
		install silversearcher-ag ag
	fi
fi

############ fzf

if has_level $LEVEL_BASIC; then
	if ! is_installed fzf; then
		if is_os "linux-android"; then
			install fzf
		elif is_os "linux-gnu" || is_os "linux-alpine"; then
			log "Installing fzf"
			git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
			~/.fzf/install
		fi
	else
		log "fzf already installed"
	fi
fi

############ neovim

if has_level $LEVEL_FULL; then
	stow neovim --no-folding
	if ! is_installed nvim; then
		if is_os "linux-gnu"; then
			sudo add-apt-repository ppa:neovim-ppa/stable
			sudo apt-get update
			sudo apt-get install neovim -y
		elif is_os "linux-android"; then
			packages install python-dev -y
			pip3 install neovim
			packages install neovim -y
		else
			install neovim nvim
		fi
	fi
fi

############ tmux

if has_level $LEVEL_FULL; then
	stow tmux --no-folding
	install tmux
fi

############ mosh

if has_level $LEVEL_EXPERIMENTAL; then
	install mosh
fi

############ fish

if has_level $LEVEL_BASIC; then
	stow fish --no-folding
	if ! is_installed fish; then
		if is_os "linux-gnu"; then
			sudo apt-add-repository ppa:fish-shell/release-2 -y
			sudo apt-get update
			sudo apt-get install fish -y
		else
			if is_os "linux-alpine"; then
				install ncurses tput
			fi
			install fish
		fi
	fi

	if is_os "linux-gnu"; then
		current_shell=$(getent passwd $LOGNAME | cut -d: -f7)
		if [ ! $current_shell = "/usr/bin/fish" ]; then
			echo "Your current shell is $current_shell. To use fish, run chsh -s /usr/bin/fish"
		fi
	fi

	if has_level $LEVEL_BASIC && [ ! -e ~/.config/fish/functions/fisher.fish ]; then
		log "Installing fisher"
		curl git.io/fisher -L > ~/.config/fish/functions/fisher.fish
		fish -c 'source ~/.config/fish/functions/fisher.fish; fisher up' > /dev/null 2>&1
		log "fisher already installed"
	fi
fi

############ lastpass-cli

if has_level $LEVEL_FULL && ! is_installed lpass; then
	git clone git@github.com:lastpass/lastpass-cli.git ~/.lastpass-cli
	pushd ~/.lastpass-cli
	make && sudo make install
	popd
fi

############ hack font

if has_level $LEVEL_FULL && is_os "linux-gnu"; then
	$PKGCMD fonts-hack-ttf $PKGARGS
fi

############ nodejs

if has_level $LEVEL_FULL && ! is_installed node; then
	if is_os "linux-gnu"; then
		curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
	fi
	install nodejs node
fi

############ go

if has_level $LEVEL_EXPERIMENTAL; then
	install golang go
fi

############ jq

if has_level $LEVEL_BASIC && ! is_installed jq; then
	install jq
fi

############ other

if [[ "$install" != "" ]]; then
	log "Installing extra packages $install"
	install $install
fi
