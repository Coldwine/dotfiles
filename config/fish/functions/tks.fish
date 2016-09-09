function tks -d 'Kill a named session'
  tmux kill-session -t $argv
end
