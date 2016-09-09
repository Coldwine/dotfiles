function General -d 'Create Session'
  tmux has-session -t General
  if test $status != 0
    cd ~/
    tmux detach
    tmux new-session -s General -n Editor -d
    tmux send-keys -t General:1.1 'nvim' C-m
    tmux new-window -n Servers -t General
    tmux split-window -v -t General:2
    tmux send-keys -t General:2.1 'ranger' C-m
    tmux send-keys -t :2.2 'npm outdated -g' C-m
    tmux split-window -h -t General:2.2
    tmux new-window -n Scratchpad -t General
    tmux send-keys -t General:3.1 'brew update' C-m
  end
  tmux attach -t General
end
