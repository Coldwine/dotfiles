function man --description 'colored manpages'
  /usr/bin/man $argv | col -b | /usr/local/share/nvim/runtime/macros/less.sh -R -c 'set filetype=man nomod nolist nonumber norelativenumber laststatus=0 showtabline=0' -
end
