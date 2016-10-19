# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# userlist written by nullie, fucked up by crapple/kreca
if (word(2 $loadinfo()) != [pf]) { load -pf $word(1 $loadinfo()); return; };

subpackage userlist;
@userlistdebug=0;
alias _uecho {if (userlistdebug == 1) { xecho -b Userlist: $*;};};
# whether to issue /usave after every successful operation
addset userlist_save_auto bool;
set userlist_save_auto off;

: {
  # user flags:
  #  a) perform actions such as autoopping and autovoicing automatically
  #  o) op after supplying a password or automatically, if the flag 'a' is set
  #  v) voice, ditto
  #  h) halfop, ditto
  #  c) adds access for ctcp commands, required for manual opping
  #  i) invites the user to a channel. 'c' flag required
  #  k) kickbans the user with the hostmask that matched
  #  r) user will be reopped upon deop
  #
  # target for chflags:
  #
  # network/*:                    global flags for a group
  # */*:                          global flags for all channels on all networks
  # network/#channel:             flags for a channel on one group
  # */#channel:                   flags for a channel on all networks
};

@ userlist_flags = [aovhcikr];
@ userlist_prefixes = [#&!];

alias purge {
  foreach $0 ii {
    _uecho purge $0 . $ii;
    @purge($0.$ii);
  };
  ^assign -$0;
};

alias _urename (old, new, path default "") {
  ^local i;
  foreach userlist[$old].$path i {
    _urename $old $new ${path}.${i};
  };
  @ userlist[$new][$path] = userlist[$old][$path];
  ^assign -userlist[$old][$path];
};

alias urename (old, new) {
  ^local oldkey,newkey,i;
  @ oldkey = encode($tolower($old));
  @ newkey = encode($tolower($new));
  if (oldkey == [] || newkey == []) {
    xecho -b Usage: /rename <old> <new>;
    return;
  };
  if (userlist[$oldkey][name] == []) {
    xecho -b User $old doesn't exist;
    return;
  };
  if (oldkey == newkey) {
    @ userlist[$newkey][name] = new;
    return;
  };
  if (userlist[$newkey][name] != []) {
    xecho -b User $new already exists;
    return;
  };
  _urename $oldkey $newkey;
  foreach userlist[$oldkey] i {
    _urename $oldkey $newkey $i;
  };
  @ userlist[$newkey][name] = new;
  if (getset(userlist_save_auto) == [ON])
    _usave 1;
};

alias deluser (users) {
  ^local user,key;
  if (users == []) {
    xecho -b Usage: /deluser <user> [user2 ...];
    return;
  };
  fe ($users) user {
    @ key = encode($tolower($user));
    if (userlist[$key][name] != []) {
      xecho -b Deleted user $user;
      purge userlist[$key];
      if (getset(userlist_save_auto) == [ON])
        _usave 1;
    } else {
      xecho -b User $user doesn't exist;
    };
  };
};

alias adduser (user, hosts) {
  ^local key,i,hosts2;
  if (user == []) {
    xecho -b Usage: /adduser <user> [host] [host2 ...];
    return;
  };
  @ key = encode($tolower($user));
  if (userlist[$key][name] != []) {
    xecho -b User $user already exists;
    return;
  };
  fe ($tolower($hosts)) i {
    push hosts2 $uhc($i);
  };
  @ userlist[$key][name] = user;
  @ userlist[$key][hosts] = tolower($hosts2);
  xecho -b Added $user to the userlist${ hosts == [] ? [] : [ with hosts: $hosts2]};
  if (getset(userlist_save_auto) == [ON])
    _usave 1;
};

alias addhost (user, hosts) {
  ^local oldhosts,newhosts,i,h,key;
  if (hosts == []) {
    xecho -b Usage: /addhost <user> <host> [host2 ...];
    return;
  };
  @ key = encode($tolower($user));
  if (userlist[$key][name] == []) {
    xecho -b User $user doesn't exist;
    return;
  };
  @ oldhosts = userlist[$key][hosts];
  @ newhosts = oldhosts;
  fe ($tolower($hosts)) i {
    @ h = uhc($i);
    if (findw($h $newhosts) == -1) {
      push newhosts $h;
    };
  };
  xecho -b Hosts for $user: ${newhosts == [] ? [none] : newhosts};
  if (newhosts != oldhosts) {
    @ userlist[$key][hosts] = newhosts;
    if (getset(userlist_save_auto) == [ON])
      _usave 1;
  };
};

alias delhost (user, hosts) {
  ^local oldhosts,newhosts,i,key;
  if (hosts == []) {
    xecho -b Usage: /delhost <user> <host> [host2 ...];
    return;
  };
  @ key = encode($tolower($user));
  if (userlist[$key][name] == []) {
    xecho -b User $user doesn't exist;
    return;
  };
  @ oldhosts = userlist[$key][hosts];
  @ newhosts = oldhosts;
  fe ($tolower($hosts)) i {
    if ((:num = findw($i $newhosts)) != -1) {
      @ newhosts = notw($num $newhosts);
    };
  };
  xecho -b Hosts for $user: ${newhosts == [] ? [none] : newhosts};
  if (newhosts != oldhosts) {
    @ userlist[$key][hosts] = newhosts;
    if (getset(userlist_save_auto) == [ON])
      _usave 1;
  };
};

alias chflags (user, flags, target, void) {
  ^local key,i,group,channel,op,curflags,oldflags,targkey,ind;
  if (flags == [] || target == [/]) {
    xecho -b Usage: /chflags <user> <flags> [[network/]channel];
    return;
  };
  if (left(1 $target) == [/]) {
    @ group = [*];
    @ channel = rest(1 $target);
    if (index($userlist_prefixes $left(1 $channel)) == -1) {
      @ channel #~ [#];
    };
  } elsif (target == []) {
    # no group and channel
    @ group = ((sg == [<default>] || sg == []) ? [*] : sg);
    @ channel = [*];
  } else {
    if (index($userlist_prefixes $left(1 $target)) == 0) {
      # no group, channel begins with a '#'
      ^local sg;
      @ sg = servergroup();
      @ group = (sg == [<default>] ? [*] : sg);
      @ channel = target;
    } else {
      # a group
      if ((:seppos = index(/ $target)) != -1) {
        @ group = left($seppos $target);
        @ channel = rest(${seppos + 1} $target);
        if (channel == []) {
          @ channel = [*];
        } elsif (channel != [*] && index($userlist_prefixes $left(1 $channel)) != 0) {
          @ channel #~ [#];
        };
      } else {
        # no group
        @ group = ((sg == [<default>] || sg == []) ? [*] : sg);
        @ channel = target;
        if (channel != [*]) {
          @ channel #~ [#];
        };
      };
    };
  };
  @ key = encode($tolower($user));
  if (userlist[$key][name] == []) {
    xecho -b User $user doesn't exist;
    return;
  };
  @ op = 1;
  @ targkey = encode($tolower($group/$channel));
  @ curflags = userlist[$key][flags][$targkey];
  @ oldflags = curflags;
  if (flags == [-]) {
    @ curflags = [];
  } else {
    fec ($flags) i {
      if (i == [+]) {
        @ op = 1;
      } elsif (i == [-]) {
        @ op = 0;
      } elsif (index($i $userlist_flags) == -1) {
        xecho -b Invalid flag: $i;
        # returning is recommended, as the user might confuse parameters and
        # insert garbage to the userlist
        return;
      } else {
        @ ind = index($i $curflags) != -1;
        if (op) {
          if (!ind) {
            @ curflags #~ i;
          };
        } else {
          if (ind) {
            @ curflags = strip($i $curflags);
          };
        };
      };
    };
  };
  xecho -b Flags for $user on $group/$channel: ${curflags == [] ? [none] : curflags};
  if (curflags != oldflags) {
    @ userlist[$key][flags][$targkey] = curflags;
    if (getset(userlist_save_auto) == [ON])
      _usave 1;
  };
};

alias chpass (user, newpass) {
  ^local key;
  if (newpass == []) {
    xecho -b Usage: /chpass <user> <new password>;
    return;
  };
  if (strlen($newpass) < 6) {
    xecho -b New password is too short (minimum 6 characters);
    return;
  };
  @ key = encode($tolower($user));
  if (userlist[$key][name] == []) {
    xecho -b User $user doesn't exist;
    return;
  };
  @ userlist[$key][pass] = sha256($newpass);
  xecho -b Password for $user changed;
  if (getset(userlist_save_auto) == [ON])
    _usave 1;
};

alias _usave (quiet) {
  ^local i,fd,ret,name,flags,fail,cnt;
  @ unlink($(savepath)userlist.tmp);
  @ fd = open($(savepath)userlist.tmp W);
  if (fd == -1) {
    xecho -b Unable to open $(savepath)userlist.tmp for writing;
    return;
  };
  @ fail = 0;
  @ cnt = 0;
  foreach userlist i {
    @ name = userlist[$i][name];
    if (index(" " $name) != -1) {
      # bad things could happen
      continue;
    };
    @ ret = write($fd user $name);
    if (ret == -1) {
      @ fail = 1;
      break;
    };
    if (userlist[$i][hosts] != []) {
      @ ret = write($fd hosts $name $userlist[$i][hosts]);
      if (ret == -1) {
        @ fail = 1;
        break;
      };
    };
    foreach userlist[$i][flags] flags {
      @ ret = write($fd flags $name $decode($flags) $userlist[$i][flags][$flags]);
      if (ret == -1) {
        @ fail = 1;
        break;
      };
    };
    if (fail) {
      break;
    };
    if (userlist[$i][pass] != []) {
      @ ret = write($fd pass $name $userlist[$i][pass]);
      if (ret == -1) {
        @ fail = 1;
        break;
      };
    };
    @ cnt++;
  };
  @ close($fd);
  if (fail) {
    @ unlink($(savepath)userlist.tmp);
    xecho $acban Error while writing to $(savepath)userlist.tmp;
  } else {
    @ ret = rename($(savepath)userlist.tmp $(savepath)userlist.conf);
    if (ret) {
      xecho $acban Error while renaming $(savepath)userlist.tmp;
    } elsif (!quiet) {
      xecho $acban Saved $cnt entries in the userlist [mod];
      if (getset(userlist_save_auto) == [ON])
        _usave 1;
    };
  };
};

alias uload {
  ^local fd,line,i,key,cnt,name,cmd,foo,fail,bar;
  @ fd = open($(savepath)userlist.conf R);
  if (fd == -1) {
    return;
  };
  purge userlist;
  @ cnt = 0;
  @ fail = 0;
  while (!eof($fd)) {
    @ line = read($fd);
    if (line == [])
      break;
    @ cnt++;
    @ name = word(1 $line);
    @ key = encode($tolower($name));
    @ cmd = word(0 $line);
    if (key == []) {
      @ fail = 1;
      break;
    };
    switch ($cmd) {
      (user) {
        @ userlist[$key][name] = name;
      };
      (hosts) {
        @ foo = [];
        if (userlist[$key][name] == []) {
          @ fail = 1;
          break;
        };
        fe ($restw(2 $line)) i {
          push foo $uhc($tolower($i));
        };
        @ userlist[$key][hosts] = foo;
      };
      (flags) {
        # XXX naive logic - things break if targkey is invalid
        ^local targkey;
        if (userlist[$key][name] == []) {
          @ fail = 1;
          break;
        };
        @ bar = tolower($word(2 $line));
        @ targkey = encode($bar);
        if (targkey == []) {
          @ fail = 1;
          break;
        };
        @ foo = word(3 $line);
        if (foo == [] || index(/ $bar) < 1 || index(^$userlist_flags $foo) != -1)) {
          @ fail = 1;
          break;
        };
        @ userlist[$key][flags][$targkey] = foo;
      };
      (pass) {
        if (userlist[$key][name] == []) {
          @ fail = 1;
          break;
        };
        @ foo = word(2 $line);
        @ userlist[$key][pass] = foo;
      };
      (*) {
        @ fail = 1;
        break;
      };
    };
  };
  if (fail) {
    xecho $acban Parse error on userlist line $cnt;
    purge userlist;
  } else {
    @ cnt = 0;
    foreach userlist i {
      @ cnt++;
    };
    xecho $acban Loaded userlist with $cnt entries;
  };
  @ close($fd);
};

alias userlist (patterns) {
  ^local i,j,cnt,group,channel,tg,fl;
  @ cnt = 0;
  foreach userlist i {
    if (patterns == [] || rmatch($userlist[$i][name] $patterns)) {
      @ cnt++;
      xecho -b [$pad(-3 " " $cnt)] Handle $pad(20 " " $userlist[$i][name]) [password: ${userlist[$i][pass] == [] ? [no] : [yes]}];
      xecho -b         Hosts: ${userlist[$i][hosts] == [] ? [none] : unsplit(", " $userlist[$i][hosts])};
      foreach userlist[$i][flags] j {
        # naive logic
        @ tg = decode($j);
        @ fl = userlist[$i][flags][$j];
        @ group   = before(1 / $tg);
        @ channel = after(1 / $tg);
        if (group == [*]) {
          if (channel == [*]) {
            xecho -b         Global: $fl;
          } else {
            xecho -b         Channel $channel: $fl;
          };
        } else {
          if (channel == [*]) {
            xecho -b         Network $group: $fl;
          } else {
            xecho -b         Channel $channel, network $group: $fl;
          };
        };
      };
    };
  };
  if (cnt == 0) {
    xecho -b No users ${patterns == [] ? [in the userlist] : [matching specified criteria]};
  };
};

## Now we're up and running, all functions below
## are related to the actual functionality of the user list


# XXX strange things happen when patterns overlap
alias _handlebyuh (uh, void) {
  ^local i,h;
  foreach userlist i {
    @ h = userlist[$i][hosts];
    if (h != []) {
      if (rmatch($uh $h)) {
	_uecho _handlebyuh\($uh\) -> $userlist[$i][name];
        return $userlist[$i][name];
      };
    };
  };
  _uecho _handlebyuh \($uh\) -> not found;
  return;
};

alias _matchbyhandle (handle, uh, void) {
  ^local key,i,h;
  @ key = encode($tolower($handle));
  @ h = userlist[$key][hosts];
  if (h != []) {
    if ((:idx = rmatch($uh $h)) > 0) {
      _uecho _matchbyhandle\($handle, $uh \) ->$word(${idx - 1} $userlist[$key][hosts]);
      return $word(${idx - 1} $userlist[$key][hosts]);
    };
  };
  _uecho _matchbyhandle \($handle, $uh \) -> not found;
  return;
};

alias _flagsbyhandle (handle, group, channel, void) {
  ^local flags,i,j,key,chan,global,changlobal,groupglobal;
  @ key = encode($tolower($handle));
  @ chan = encode($tolower($group/$channel));
  @ global = encode($tolower(*/*));
  @ changlobal = encode($tolower(*/$channel));
  @ groupglobal = encode($tolower($group/*));
  fe ($chan $global $changlobal $groupglobal) i {
    fec ($userlist[$key][flags][$i]) j {
      # circumvent naive logic
      if (j == [ ]) {
        continue;
      };
      if (index($j $flags) == -1) {
        @ flags #= j;
      };
    };
  };
  _uecho _flagsbyhandle \($handle, $group, $channel \) -> $flags;
  return $flags;
};

alias _flagsbyuh (uh, group, channel, void) {
  ^local h;
  @ h = _handlebyuh($uh);
  if (h == []) {
    return;
  };
  return $_flagsbyhandle($h $group $channel);
};

on #-server_lost 816 "*" {
  _uecho on server lost $*;
  purge uqueue[$0];
  ^assign -doops[$0];
};

alias _modebyflags (flags, void) {
  if (index(d $flags) != -1) {
    return -o;
  };
  if (index(k $flags) != -1) {
    return +b;
  };
  if (index(a $flags) != -1) {
    if (index(o $flags) != -1) {
      return +o;
    } elsif (index(h $flags) != -1) {
      return +h;
    } elsif (index(v $flags) != -1) {
      return +v;
    };
  };
  return;
};

alias _qadd (sv, channel, mode, void) {
  ^local key;
  _uecho _qadd \( $sv $channel $mode \);
  @ key = encode($tolower($channel));
  if (findw($mode $uqueue[$sv][$key]) == -1) {
     _uecho _qadd found it - $key;
    push uqueue[$sv][$key] $mode;
  };
};

on #-join -816 "*" {
  ^local flags,mode,key,sv;
  @ joinflags = [];
  _uecho on join $*;
  if ([$0] == servernick()) {
    return;
  };
  _douser $0 $2 $1;
};

# must be called in given server's context
alias _should (mode, nick, channel, void) {
  ^local op,char;
  _uecho _should \( $mode, $nick, $channel \);
  if (strlen($mode) != 2) {
    _uecho strlen != 2;
    return 0;
  };
  @ op   = left(1 $mode) == [+] ? 1 : 0;
  @ char = rest(1 $mode);
  if (!onchannel($nick $channel) && mode != [+b]) {
    _uecho $nick ! onchannel;
    return 0;
  };
  switch ($char) {
    (o) {
      _uecho switch o;
      return ${ischanop($nick $channel) != op};
    };
    (v) {
      if (ischanop($nick $channel) || ishalfop($nick $channel) || ischanvoice($nick $channel) == op) {
      _uecho switch v 0;
        return 0;
      };
      _uecho switch v 1;
      return 1;
    };
    (h) {
      if (ischanop($nick $channel) || ishalfop($nick $channel) == op) {
      _uecho switch h 0;
        return 0;
      };
      _uecho switch h 1;
      return 1;
    };
    (b) {
      _uecho switch b;
      return 1;
    };
    (*) {
      _uecho switch *;
      return 0;
    };
  };
};

timer -update -general -ref _ulist -repeat -1 10 _doqueue;

alias _doqueue {
  ^local ref;
  foreach uqueue ref {
    _uecho ref $ref;
    if (ref == [] || !isconnected($ref)) {
      _uecho purge uqueue $ref . $isconnected($ref);
      purge uqueue[$ref];
      return;
    };
    xeval -s "$ref" {
      _doqueue_ref $ref;
    };
  };
  ^assign -ref,chan;
};

alias _doqueue_ref (ref, void) {
  ^local mm;
  _uecho doqueue_ref $ref;
  @ mm = _maxmodes($ref);
  foreach uqueue[$ref] i {
    ^local ch,mode,nick,cnt,modes,nicks;
    _uecho doqueue_ref fe $ref $i;
    @ cnt = 0;
    @ ch = decode($i);
    while ((:str = shift(uqueue[$ref][$i])) != []) {
      @ mode = left(2 $str);
      @ nick = rest(2 $str);
      _uecho doqueue_ref nick: $nick mode: $mode;
      if (nick == [] || strlen($mode) != 2) {
        continue;
      };
      if (_should($mode $nick $ch)) {
        @ cnt++;
        @ modes #= mode;
        push nicks $nick;
      };
      if (cnt >= mm) {
        break;
      };
    };
    if (cnt) {
      //mode $ch $modes $nicks;
      break;
    };
  };
  ^assign -i;
};

alias _trydel (ref, channel, nick, readdnick default "", void) {
  ^local i,n,word,key,mode,nw,toremove,toadd,items;
  @ key = encode($tolower($channel));
  @ items = uqueue[$ref][$key];
  @ nw = numwords($items);
  for i from 0 to ${nw - 1} {
    @ word = word($i $items);
    @ mode = left(2 $word);
    @ n    = rest(2 $word);
    if (n == nick && mode != [+b]) {
      push toremove $word;
      if (readdnick != []) {
        push toadd $mode$readdnick;
      };
    };
  };
  fe ($toremove) i {
    @ items = remw($i $items);
  };
  push items $toadd;
  @ uqueue[$ref][$key] = items;
};

on #-part 816 "*" {
  _uecho on part $*;
  _trydel $servernum() $1 $0;
  if ([$0] == servernick()) {
    @ doops[$servernum()] = remw($1 $doops[$servernum()]);
  };
};

on #-kick 816 "*" {
  _uecho on kick $*;
  _trydel $servernum() $2 $0;
  if ([$0] == servernick()) {
    @ doops[$servernum()] = remw($2 $doops[$servernum()]);
  };
};

on #-channel_signoff 816 "*" {
  _uecho on channel signoff $*;
  _trydel $servernum() $0 $1;
};

on #-channel_nick 816 "*" {
  _uecho on channel nick $*;
  _trydel $servernum() $0 $1 $2;
};

alias _doops_chan (ch, void) {
  ^local key,nick,sv;
  @ sv = servernum();
  fe ($onchannel($ch)) nick {
    if (nick == servernick()) {
      continue;
    };
    ^local mode,fl;
    @ fl = _flagsbyuh($nick!$userhost($nick) $servergroup() $ch);
    @ mode = _modebyflags($fl);
    if (mode != [] && _should($mode $nick $ch)) {
      _qadd $sv $ch $mode$nick;
    };
  };
};

alias doops {
  fe ($myservers(0)) sv {
    xeval -s $sv {
      ^local ch;
      fe ($mychannels()) ch {
        if (ischanop($servernick() $ch)) {
          _doops_chan $ch;
        };
      };
    };
  };
  ^assign -sv;
};

on #-channel_sync 816 "*" {
  _uecho on channel sync $*;
  if (ischanop($servernick() $0)) {
    _doops_chan $0;
  } else {
    push doops[$2] $0;
  };
};

on #-mode_stripped 816 "*" {
  _uecho on mode_stripped $*;
  ^local sn,fl,mo,chr;
  if (!onchannel($servernick() $1)) {
    return;
  };
  @ sn  = servernum();
  @ fl  = _flagsbyuh($3!$userhost($3) $servergroup() $1);
  @ mo  = _modebyflags($fl);
  @ chr = right(1 $mo);
  switch ($2) {
    (+o) {
      if ([$3] == servernick() && findw($1 $doops[$sn]) != -1) {
        @ doops[$sn] = remw($1 $doops[$sn]);
        _doops_chan $1;
      } else {
      };
    };
    (-o) {
      if ([$0] != servernick() && [$3] != servernick() && [$3] != [$0] && ischanop($3 $1) && chr == [o]) {
        _douser $3 $userhost($3) $1 r;
      };
    };
    (-v) {
      if ([$0] != servernick() && [$3] != servernick() && [$3] != [$0] && ischanvoice($3 $1) && chr == [v]) {
        _douser $3 $userhost($3) $1 r;
      };
    };
    (-h) {
      if ([$0] != servernick() && [$3] != servernick() && [$3] != [$0] && ishalfop($3 $1) && chr == [h]) {
        _douser $3 $userhost($3) $1 r;
      };
    };
  };
};

# must be called in the context of given server
alias _douser (nick, uh, channel, needfl default "", void) {
  _uecho douser\( $nick , $uh , $channel, $needfl , void\);
  if (!ischanop($servernick() $channel)) {
    _uecho !ischanop;
    return;
  };
  ^local fl,mo,ha;
  @ ha = _handlebyuh($nick!$uh);
  if (ha != []) {
    @ fl = _flagsbyhandle($ha $servergroup() $channel);
    @ joinflags = [$ha $fl];
    _uecho fl = $fl , joinflags = $joinflags;
    if (fl != [] && (needfl == [] || index($needfl $fl) != -1)) {
      @ mo = _modebyflags($fl);
      _uecho modebyflags = $mo;
      if (mo != []) {
        if (mo == [+b]) {
          @ nick = _matchbyhandle($ha $nick!$uh);
          if (nick == []) {
            return;
          };
        };
        _qadd $servernum() $channel $mo$nick;
      };
    };
  };
};

alias usave {_usave 0};

alias userlevels {
//echo  user flags:;
//echo  a) perform actions such as autoopping and autovoicing automatically;
//echo  o) op after supplying a password or automatically, if the flag 'a' is set;
//echo  v) voice;
//echo  h) halfop;
//echo  c) adds access for ctcp commands, required for manual opping;
//echo  i) invites the user to a channel. 'c' flag required;
//echo  k) kickbans the user with the hostmask that matched;
//echo  r) user will be reopped upon deop;
//echo  target for chflags;
//echo  network/*:		global flags for a group;
//echo  */*:			global flags for all channels on all networks;
//echo  network/#channel:	flags for a channel on one group;
//echo  */#channel:		flags for a channel on all networks;
};

## misc various compat aliases.
alias listuser userlist;
alias usersave _usave;
alias saveuser _usave;
alias listf userlist;
alias chattr {chflags $*;};
alias addf {adduser $*;};
alias delf {deluser $*;};
alias remf {deluser $*;};
alias unuser {deluser $*;};
## end compat.

alias userhelp uhelp;
alias uhelp {
//echo -----------------------= Userlist Help =--------------------------;

//echo userlevels /userlevels will display valid levels for userlist;
//echo userlist /userlist will display users from the userlist.;
//echo adduser  /adduser <user> [host] [host2 ...];
//echo chflags  /chflags <user> <flags> [[network/]channel];
//echo chpass   /chpass user <new password>;
//echo addhost  /addhost <user> <host> [host2 ...]
//echo delhost  /delhost <user> <host> [host2 ...]
//echo listuser /listuser will display users from the userlist.;
//echo deluser  /deluser <user> [user2] will delete the user(s) from userlist.;
//echo addf     /addf same as /adduser;
//echo listf    /listf same as /userlist;
//echo delf     /delf same as /deluser;
//echo remf     /remf same as /deluser;

//echo -------------------------------------------------------------------;
};
