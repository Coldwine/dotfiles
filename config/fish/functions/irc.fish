function irc
  set -x IRC_SERVERS_FILE ~/.irc/ircII.servers
  set -x IRCNICK Coldwine
  set -x IRCNAME anonymou5e
  set -x TERM screen-256color
  /usr/local/bin/epic5 $argv
end
