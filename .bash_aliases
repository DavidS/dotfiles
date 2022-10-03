# easy access to the dotfiles repo
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# typing is bad
alias dc=docker-compose

# add sounds to long-running commands
alias notify_fail='aplay /usr/share/games/scorched3d/data/globalmods/apoc/data/wav/explosions/exp.wav >/dev/null 2>&1'
alias notify_success='aplay /usr/share/games/scorched3d/data/globalmods/apoc/data/wav/misc/extralife.wav >/dev/null 2>&1'
function note() {
	$@ && notify_success || notify_fail
}

function say() { echo $@; echo $@ | espeak; echo; }

function clone() { hub clone $1/$2; cd $2; hub remote rename origin upstream; hub fork DavidS; hub remote rename DavidS origin; }

# Thanks, davinci resolve :eyeroll:
function unpack_mov() { ffmpeg -i "$1" -codec:v copy -codec:a pcm_s32le "${1%%.mp4}.mov" && rm "$1" ; }
function repack_mp4() { ffmpeg -i "$1" -codec:v copy -codec:a aac "${1%%.mov}.mp4" && rm "$1" ; }
