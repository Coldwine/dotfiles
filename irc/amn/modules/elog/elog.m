# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage elog;

## create logging directory if nonexistent
@ mkdir(~/.amn/logs);
@ chmod(~/.amn/logs 0700);

## compile sets
addset log_msgs bool;
addset log_dcc bool;
addset log_public bool;
addset log_crap bool;
set log_msgs on;
set log_dcc on;
set log_public on;
set log_crap off;

## set log menu config interface
osetitem log elog_msgs log msgs:;
osetitem log elog_dcc log dcc chat:;
osetitem log elog_public log publics:;
osetitem log elog_crap log craps:;

## config function
alias config.elog_msgs {
	if ( *0 == '-r' ) {
		return $tolower($getset(log_msgs));
	} else if (*0 == '-s') {
		@tmpvar=tolower($getset(log_msgs));
		config.matchinput on|off tmpvar '$1' log msgs;
		^set log_msgs $tmpvar;
	};
};

alias config.elog_dcc {
	if ( *0 == '-r' ) {
		return $tolower($getset(log_dcc));
	} else if (*0 == '-s') {
		@tmpvar=tolower($getset(log_dcc));
		config.matchinput on|off tmpvar '$1' log dcc chat;
		^set log_dcc $tmpvar;
	};
};

alias config.elog_public {
	if ( *0 == '-r' ) {
		return $tolower($getset(log_public));
	} else if (*0 == '-s') {
		@tmpvar=tolower($getset(log_public));
		config.matchinput on|off tmpvar '$1' log publics;
		^set log_public $tmpvar;
	};
};

alias config.elog_crap {
	if ( *0 == '-r' ) {
		return $tolower($getset(log_crap));
	} else if (*0 == '-s') {
		@tmpvar=tolower($getset(log_crap));
		config.matchinput on|off tmpvar '$1' log craps;
		^set log_crap $tmpvar;
	};
};

## wrappers for above
alias elogm {
	config.elog_msgs -s $*;
};

alias elogd {
	config.elog_dcc -s $*;
};

alias elogp {
	config.elog_public -s $*;
};

alias elogc
	config.elog_crap -s $*;
};

## set logging variable
alias _dontlog (what, void) {
	switch ($what) {
	(msg) {
		return ${getset(log_msgs) == [off]};
	};
	(dcc) {
		return ${getset(log_dcc) == [off]};
	};
	(public) {
		return ${getset(log_public) == [off]};
	};
	(crap) {
		return ${getset(log_crap) == [off]};
		};
	};
	return 1;
};

alias _log {
	@ :name = tr(#./*?<>$$!&#_________#$tolower($0));
	@ :sn   = tr(#./*?<>$$!&#_________#$tolower($servername()));
	@ :fd = open(~/.amn/logs/log.${sn}.$name W);
			if (fd == -1) {
		return;
	};
	@ write($fd $strftime(%Z %x [%I:%M:%S]) $1-);
	@ close($fd);
};

## message log hooks
on #-msg 888 "*" {
	if (_dontlog(msg)) { return; };
	_log $0 [$0!$userhost()] $1-;
};

on #-encrypted_privmsg 888 "*" {
	if (_dontlog(msg)) { return; };
	_log $0 *e* [$0!$userhost()] $1-;
};
  
on #-send_msg 888 "*" {
	if (_dontlog(msg)) { return; };
	_log $0 [msg\($0\)] $1-;
};

on #-msg_group 888 "*" {
	if (_dontlog(msg)) { return; };
	_log $0 [$0!$userhost()] $2-;
};

on #-send_notice 888 "*" {
	if (_dontlog(msg)) { return; };
	_log $0 [notice\($0\)] $1-;
};

on #-notice 888 "*" {
	if (_dontlog(msg)) { return; };
	_log $0 -$0!$userhost()- $1-;
};
  
on #-encrypted_notice 888 "*" {
	^local ic;
	@ ic = ischannel($1);
	if (_dontlog(${ ic ? [public] : [msg] })) { return; };
	_log ${ ic ? [$1] : [$0] } *e* -$0!$userhost()- $2-;
};                                                    

## dcc log hooks
on #-dcc_chat 888 "*" {
	if (_dontlog(dcc)) { return; };
	_log $0 [dcc=\($0\)] $1-;
};

on #-send_dcc_chat 888 "*" {
	if (_dontlog(dcc)) { return; };
	_log $0 [dcc=>\($0\)] $1-;
};


## public log hooks
on #-public 888 "*" {
	if (_dontlog(public)) { return; };
		_log $1 <$0> $2-;
	};
};

on #-public_other 888 "*" {
	if (_dontlog(public)) { return; };
		_log $1 <$0> $2-;
	};
};

on #-public_msg 888 "*" {
	if (_dontlog(public)) { return; };
		_log $1 <$0> $2-;
	};
};

on #-send_public 888 "*" {
	if (_dontlog(public)) { return; };
		_log $0 > $1-;
};

on #-topic 888 "*" {
	if (_dontlog(public)) { return; };
	if (strlen($2-)) {
		_log $1 >> $0 changed the topic of $1 to: $2-;
	} else {
		_log $1 >> $0 unset the topic of $1;
	};
};

## public/msg action log hooks
on #-action 888 "*" {
	if ([$1] == servernick()) {
	if (_dontlog(msg)) { return; };
		_log $0 * [$0!$userhost()] $2-;
	} else {
		if (_dontlog(public)) { return; };
		_log $1 * $0 $2-;
	};
};

on #-send_action 888 "*" {
	if (ischannel($0)) {
	if (_dontlog(public)) { return; };
		_log $0 * $servernick() $1-;
	} else {
		if (_dontlog(msg)) { return; };
		_log $0 [action\($0\)] $1-;
	};
};

## crap log hooks
on #-channel_signoff 888 "*" {
	if (_dontlog(crap)) { return; };
	_log $0 quit/$0 $1 \($userhost()\) \($2-\);
};

on #-invite 888 "*" {
	if (_dontlog(crap)) { return; };
	_log $0 $0 \($userhost()\) invites you to $1;
};

on #-channel_nick 888 "*" {
	if (_dontlog(crap)) { return; };
	_log $0 nick/$0 $1 -> $2 \($userhost()\);
};

on #-join 888 "*" {
	if (_dontlog(crap)) { return; };
	_log $1 join/$1 $0 \($2\);
};

on #-kick 888 "*" {
	if (_dontlog(crap)) { return; };
	_log $2 kick/$2 $0 by $1 \($userhost()\) \($3-\);
};

on #-part 888 "*" {
	if (_dontlog(crap)) { return; };
	_log $1 part/$1 $0 \($2\) \($3-\);
};

on #-mode 888 "*" {
	if (_dontlog(crap)) { return; };
	_log $1 mode/$1 [$2-] by $0 \($userhost()\);
};


alias loghelp eloghelp;
alias eloghelp {
//echo -----------------------= Enhanced Logging Help =--------------------------;
//echo elogm	/elogm [on|off] toggle msg logging to multiple files;
//echo elogd	/elogd [on|off] toggle dcc logging to multiple files;
//echo elogp	/elogp [on|off] toggle public logging to multiple files;
//echo elogc	/elogc [on|off] toggle craps logging to multiple files;
//echo
//echo	NOTE: crap: logs join, parts, kicks, signoffs, nick/mode changes;
//echo  Logs are saved in ~/.amn/logs per default at this time.;
//echo -------------------------------------------------------------------;
};
