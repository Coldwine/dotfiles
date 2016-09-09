# name: eclm
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o 97dedf)
  set -l yellow (set_color -o ffde99)
  set -l red (set_color -o e17799)
  set -l blue (set_color -o baddfc)
  set -l green (set_color -o 98bb99)
  set -l normal (set_color e9e9e9)

  if test $last_status = 0
      set status_indicator "$green> "
  else
      set status_indicator "$red> "
  end
  set -l cwd $cyan(basename (prompt_pwd))

  if [ (_git_branch_name) ]

    if test (_git_branch_name) = 'master'
      set -l git_branch (_git_branch_name)
      set git_info "$normal ($red$git_branch$normal)"
    else
      set -l git_branch (_git_branch_name)
      set git_info "$normal ($blue$git_branch$normal)"
    end

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end

  echo -n -s $status_indicator $cwd $git_info $normal ' '
end
