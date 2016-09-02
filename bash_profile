# rbenv
eval "$(rbenv init -)"

# Enviroment Variables
  export EDITOR='subl'
  export PATH="$HOME/bin:/usr/local/bin:$PATH"

# ALIASES
  # path
    alias     ..="cd .."
    alias    ...="cd ../.."
    alias   ....="cd ../../.."
    alias  .....="cd ../../../.."
    alias ......="cd ../../../../.."
      # -l  long format
      # -F  / after dirs, * after exe, @ after symlink
      # -G  colorize
      # -g suppress owner
      # -o suppress group
      # -h humanize sizes
      # -q print nongraphic chars as question marks
    alias l="ls -lFGgohq"
    alias rspec="rspec --fail-fast"
    alias add_cln="subl ~/open-dev/cln/cln"

  # git
    alias gsh="  git s"                                                      # git show with my custom options (see gitconfig)
    alias gs="   git status"
    alias gd="   git d"                                                      # git diff with my custom options
    alias go="   git checkout"
    alias gb="   git branch"
    alias ga="   git add"
    alias gcm="  git commit -m"
    alias gp="   git push"
    alias gh="   git hist"
    alias brpb=" git rev-parse --abbrev-ref HEAD | xargs echo -n | pbcopy"

  # docker

    alias dm='docker-machine'
    alias dc='docker-compose'
    alias dl='docker ps -a' # List containers
    alias di='docker images' # List images
    alias dr='docker run -it' # Run a command in a new container
    alias db='docker build' # Build or rebuild services
    alias ds='docker start' # Start one or more stopped containers
    alias da='docker attach' # Attach to a running container
    alias drm='docker rm -f' # Remove one or more containers
    alias drmi='docker rmi -f' # Remove one or more images
    alias qt='/Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh' # Open Docker Terminal

  # homebrew
    alias brew-formulas="open 'https://github.com/mxcl/homebrew/tree/master/Library/Formula'"

  # At some point it might become necessary to rewrite this in C, but for now this will do
    alias chomp="ruby -e 'print \$stdin.read.chomp'"

# PROGRAMS (functions, binaries, aliases that behave like programs)
  # give the fullpaths of files
    function fullpath {
      ruby -e '
        $stdin.each_line { |path| puts File.expand_path path }  if ARGV.empty?
        ARGV.each { |path| puts File.expand_path path }         unless ARGV.empty?
      ' "$@"
    }

  # when you forget to bundle exec, just run `be` it will rerun the command with bundler
  # when you want to run a command with bundler, just prepend this function, ie `be rake spec`
    function be {
      if [ $# -eq 0 ]; then
        local command=bundle\ exec\ "$(history | grep -v '^ *[0-9]* *be$' | tail -1 | sed 's/^[ \t]*[0-9]*[ \t]*//')"
        echo expand to: "$command"
        eval "$command"
      else
        bundle exec "$@"
      fi
    }

  # Give it a # and a dir, it will cd to that dir, then `cd ..` however many times you've indicated with the number
  # The number defaults to 1, the dir, if not provided, defaults to the output of the previous command
  # This lets you find the dir on one line, then run the command on the next
    2dir() {
      last_command="$(history | tail -2 | head -1 | sed 's/^ *[0-9]* *//')"
      count="${1-1}"
      name="${2:-$($last_command)}"
      while [[ $count > 0 ]]
        do
          name="$(dirname "$name")"
          ((count--))
      done
      echo "$name"
      cd "$name"
    }


# PROMPT
  function parse_git_branch {
    branch=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
    if [ "HEAD" = "$branch" ]; then
      echo "(no branch)"
    else
      echo "$branch"
    fi
  }

  function prompt_segment {
    if [[ ! -z "$1" ]]; then
      echo "\[\033[${2:-37};45m\]${1}\[\033[0m\]"
    fi
  }

  function build_mah_prompt {
    # time
    ps1="$(prompt_segment " \@ ")"

    # cwd with coloured current directory
    # path="$(dirname `pwd`)"
    # dir="$(basename `pwd`)"
    # ps1="${ps1} $(prompt_segment " ${path}/")$(prompt_segment "$dir " 34)"

    # cwd
    ps1="${ps1} $(prompt_segment " \w ")"

    # git branch
    git_branch=`parse_git_branch`
    if [[ ! -z "$git_branch" ]]; then ps1="${ps1} $(prompt_segment " $git_branch " 32)"; fi

    # next line
    ps1="${ps1}\n\$ "

    # output
    PS1="$ps1"
  }

  PROMPT_COMMAND="build_mah_prompt;$PROMPT_COMMAND"

  function title {
      echo -ne "\033]0;"$*"\007"
  }

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
