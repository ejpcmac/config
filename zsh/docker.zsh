##################
# Docker Aliases #
##################

# Manual start for the Docker deamon
alias dos='sudo $(which dockerd)'

# Delete the VM image on macOS
alias doclean='rm ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2'

# General aliases
alias doi='docker info'
alias doa='docker attach'
alias dor='docker run'

# Docker image management
alias doil='docker image ls'
alias doir='docker image rm'
alias doip='docker image prune'
alias doib='docker image build'
alias doilo='docker image load'
alias dois='docker image save'

# Docker container management
alias docl='docker container ls'
alias docla='docker container ls --all'
alias docr='docker container rm'
alias docp='docker container prune'
