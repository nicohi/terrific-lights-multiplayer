#!/bin/bash
tmux new-session -s "terrific-lights" -d
tmux split-window -h
tmux split-window -v
tmux select-pane -L
tmux split-window -v 
for _pane in $(tmux list-panes -F '#P'); do
    tmux send-keys -t ${_pane} "godot MainMenuMulti.tscn" Enter
done
tmux -2 attach-session -d
