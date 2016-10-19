# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
## made by nullie/weirdo
## modified by kreca -06
##
## comment by zak -july 2010, I have no idea why nullie/kreca i see
## parts of it done by kreca as i can see his stonecode, nullies code
## is literally fscking impossible to understand this mess needs to be
## cleaned up, seriously guys. when writing something from scratch, don't
## take shortcuts it took us a number of years to cleanup the horrid mess
## from oblivion and we still get more junk in which ive been trying to
## clean from the last oh i dunno 8 or so commits.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

package reconnect;

## /config connect wrappers/funcs
alias config.auto_reconnect {
	if ( *0 == '-r' ) {
		return $tolower($getset(auto_reconnect));
	} else if (*0 == '-s') {
		@tmpvar=tolower($getset(auto_reconnect));
		config.matchinput on|off tmpvar '$1' Auto-reconnect;
		^set auto_reconnect $tmpvar;
	};
};
alias config.auto_rejoin_connect {
	if ( *0 == '-r' ) {
		return $tolower($getset(auto_rejoin_connect));
	} else if (*0 == '-s') {
		@tmpvar=tolower($getset(auto_rejoin_connect));
		config.matchinput on|off tmpvar '$1' Auto-rejoin connect;
		^set auto_rejoin_connect $tmpvar;
	};
};

alias config.auto_reconnect_delay {
	if ( *0 == '-r' ) {
		return $getset(auto_reconnect_delay);
	} else if (*0 == '-s') {
		if (#>1) {
			^set auto_reconnect_delay $1;
		};
		xecho -v $acban Auto-reconnect delay set to: "$getset(auto_reconnect_delay)";
	};
};

alias config.auto_reconnect_retries {
	if ( *0 == '-r' ) {
		return $getset(auto_reconnect_retries);
	} else if (*0 == '-s') {
		if (#>1) {
			^set auto_reconnect_retries $1;
		};
		xecho -v $acban Auto-reconnect retries set to: "$getset(auto_reconnect_retries)";
	};
};

## wrapper funcs for above
alias aconnect areconnect $*;
alias areconnect {
	config.auto_reconnect -s $*;
};

alias ardelay {
	config.auto_reconnect_delay -s $*;
};

alias aretry {
	config.auto_reconnect_retries -s $*;
};

alias arjoin {
	config.auto_rejoin_connect -s $*;
};

alias _reconn.svkey (ref, void) {
  ^local gr;
  @ gr = servergroup($ref);
  if (gr == '<default>' || !@gr ) {
    return sv $ref;
  };
  return gr $gr;
};

alias _reconn.hook.disconn {
  if (*1 != 'CLOSING' && getset(auto_reconnect) == 'ON') {
    if (serverctl(GET $0 ADDRSLEFT)) {
      return;
    };
    @ :egr = encode($_reconn.svkey($0));
    if ( !@reconn[$egr][lastserver]) {
      xeval -s $0 {
        fe ($tolower($mychannels($0))) i {
          if ((:win = winchan($i)) != -1) {
            push arr[$win] $i $key($i);
          };
        };
      };
      foreach arr i {
        @ windowctl(SET $i TOPLINE 9 $arr[$i]);
        ^assign -arr[$i];
      };
      @ reconn[$egr][retries] = getset(auto_reconnect_retries) - 1;
    } else {
      if (reconn[$egr][retries] > -1) {
        @ reconn[$egr][retries]--;
        if (reconn[$egr][retries] <= 0) {
          _reconn.purge $0;
          xecho -b Number of retries for server $servername($0) exceeded;
          return;
        };
      };
    };
    @ reconn[$egr][lastserver] = [$0];
    xecho -b Reconnecting to $servername($0) in $getset(auto_reconnect_delay) seconds. Type /rmreconnect to cancel.${ reconn[$egr][retries] != -1 ? [ \($reconn[$egr][retries] retries left\).] : [] };
    ^timer -ref _reconn$egr $getset(auto_reconnect_delay) _reconn.server $egr;
  };
};

fe (ERROR EOF) i {
  on #-SERVER_STATUS 27 "% % $i" {
    _reconn.hook.disconn $*;
  };
};

on #-SERVER_STATUS 27 "% % CLOSING" {
  if (*1 != 'EOF' && *1 != 'ERROR') {
    _reconn.purge $0;
  };
};

on #-SERVER_STATUS 27 "% % ACTIVE" {
  if (getset(auto_rejoin_connect) == 'on') {
    fe ($winrefs()) i {
      if (winserv($i) == *0) {
	fe ($windowctl(GET $i TOPLINE 9)) ch k {
	  window $i channel "$ch $k";
	};
      };
    };
  };
  _reconn.purge $0;
};

on #-SERVER_STATUS 27 "% % DELETE" {
  _reconn.sweep $0;
};

#_reconn.purge
#ref: server reference
#Remove all references to the server and the server group it is in

alias _reconn.clearentry (name, void) {
  ^assign -reconn[$name][timeout];
  ^assign -reconn[$name][retries];
  ^assign -reconn[$name][lastserver];
  ^timer -delete _reconn$name;
};

alias _reconn.purge (ref, void) {
  @ :gr  = _reconn.svkey($ref);
  @ :egr = encode($gr);
  _reconn.clearentry $egr;

  if (word(0 $gr) == 'gr') {
# it is a server, but it suddenly gained a group
    @ :str = encode(sv $ref);
    _reconn.clearentry $str;
  };
  _reconn.clrtoplines $ref;
};

alias _reconn.clrtoplines (ref, void) {
  fe ($winrefs()) i {
    if (ref == -1 || winserv($i) == ref) {
      @ windowctl(SET $i TOPLINE 9 );
    };
  };
};

alias _reconn.sweep (ref, void) {
  ^local str,type,item,gr,svs;
  _reconn.clrtoplines $ref;
  @ str = encode(sv $ref);
  _reconn.clearentry $str;
  foreach reconn i {
    @ str = decode($i);
    @ type = word(0 $str);
    @ item = word(1 $str);
    if (type == 'sv') {
      @ gr = servergroup($item);
# it is a server, but it suddenly gained a group
      if (gr != '<default>' && !@gr) {
        _reconn.clearentry $i;
      };
    } elif (type == 'gr') {
      @ svs = serverctl(GMATCH $item);
# there are no servers || the only server is the one that's being deleted
      if (!@svs || svs == ref) {
        _reconn.clearentry $i;
      };
    };
  };
};

alias _reconn.server (sg,void) {
  ^local win,found,str,type,item,lastsv,next,svs,i;

  @ str = decode($sg);
  @ type = word(0 $str);
  @ item = word(1 $str);
  @ lastsv = reconn[$sg][lastserver];
  @ svs = serverctl(GMATCH $item);
  if (!@lastsv) {
    _reconn.clearentry $sg;
    return;
  };
  if (type == 'gr' && @item && item != '<default>') {
    fe ($svs) i {
      if (isconnected($i)) {
        _reconn.clearentry $sg;
        return -1;
      };
    };
  };
  fe ($winrefs()) win {
    if (winserv($win) == lastsv) {
      PUSH found $win;
    };
  };
  if (@found) {
    if (type == 'gr') {
      @ next = _reconn.nextserv($lastsv $item);
    } else {
      @ next = lastsv;
    };
    if (next != -1 && !isconnected($next)) {
      fe ($found) j {
        window $j SERVER $next;
      };
    } else {
      _reconn.clearentry $sg;
    };
  } else {
    _reconn.clearentry $sg;
  };
};

alias rmreconnect {
  ^local i,st;
  foreach reconn i {
    @ :ref = reconn[$i][lastserver];
    xecho -b Cancelling reconnect to $servername($ref) \(refnum $ref\);
    _reconn.clearentry $i;
    ^timer -delete _reconn$i;
  };
  fe ($serverctl(OMATCH *)) i {
    @ st = serverctl(GET $i STATUS);
    switch ($st) {
      (dns) (connecting) (registering) (syncing) (ssl_connecting) {
        xecho -b Disconnecting from $servername($i) \(refnum $i);
        //^disconnect $i;
      };
    };
  };
};

alias _reconn.nextserv (ref, group, void) {
  if (group == '<default>') {
    return -1;
  };
  @ :servers = serverctl(GMATCH $group);
  @ :num = numwords($servers);
  if (num == 0) {
# shouldn't happen
    return -1;
  };
  @ :found = findw($ref $servers);
  if (found == -1) {
    return $word(0 $servers);
  };
  @ num--;
  if (num == found) {
    return $word(0 $servers);
  } else {
    return $word(${found+1} $servers);
  };
};

_reconn.clrtoplines -1;

#weirdo & kreca'2k6
