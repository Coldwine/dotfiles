# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# last modified by skullY 12.13.08 - initial version
# remote - Connect to your epic client using another irc client
# Original implementation 2008 Dec 13, Zach White (skullY@EFnet)
#
# This script lets you connect to your currently running irc client using
# another irc client. 


# Make sure we're using the pf loader
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage remote;

:{
Thoughts on stuff to implement still:

Binding to a specific IP:
	hop says we can do this for now:
		hostname 127.0.0.1;
		@fd=listen(6667 v4);
		hostname -;
	However, that still leaves us with the problem of people who use
	hostname for its intended purpose. Can possibly implement a work-around.

Joining new channels:
	How do we want to handle new channels? A simple /j will join in the
	curently visible window, which may not be what the user wants. Some
	users may not want /wj. What's a sane to allow the user to configure
	this?

Multiple Server:
	Currently the user can only see channels on the server for the window
	with input. How do we enable the user to connect to multiple servers
	when the downstream client thinks it's connected to a single server?
	Possibilities:
		* Server name prefixes.  <umich_skullY:#umich_amnesiac> hi
		* Server name postfixes. <skullY_umich:#amnesiac_umich> hi
		* Server num prefixes.  <0_skullY:#0_amnesiac> hi
		* Server num postfixes. <skullY_0:#amnesiac_0> hi
};

# /config stuff
osetitem remote remotestatus Remote connections on/off:;
alias config.remotestatus (command, status) {
	if (command==[-r]) {
		if ([$_modsinfo.remote.listening]==[0]) {
			return off;
		} else {
			return on;
		};
	} elif (command==[-s]) {
		# Change or toggle the current status (on/off)
		switch ($status) {
			(on) {
				_remoteListener on;
			};
			(off) {
				_remoteListener off;
			};
			(toggle) {
				if (_modsinfo.remote.listening==0) {
					_remoteListener on;
				} {
					_remoteListener off;
				};
			};
		};
		xecho -b remote: Current status is $_modsinfo.remote.statusType[$_modsinfo.remote.listening];
	};
};

osetitem remote remotehostname Hostname:;
alias config.remotehostname (command, hostname) {
	if (command==[-r]) {
		return $_modsinfo.remote.hostname;
	} else if (command==[-l]) {
		@_modsinfo.remote.hostname = "$hostname";
	} else if (command==[-s]) {
		@_modsinfo.remote.hostname = "$hostname";
		xecho -b remote: Current Hostname is $_modsinfo.remote.hostname;
	};
};

osetitem remote remotelistenport Port:;
alias config.remotelistenport (command, port) {
	if (command==[-r]) {
		return $_modsinfo.remote.listenPort;
	} else if (command==[-l]) {
		@_modsinfo.remote.listenPort = "$port";
	} else if (command==[-s]) {
		@_modsinfo.remote.listenPort = "$port";
		xecho -b remote: Current Port is $_modsinfo.remote.listenPort;
	};
};

osetitem remote remotepassword Password:;
alias config.remotepassword (command, password) {
	if (command==[-r]) {
		return $_modsinfo.remote.password;
	} else if (command==[-l]) {
		@_modsinfo.remote.password = "$password";
	} else if (command==[-s]) {
		@_modsinfo.remote.password = "$password";
		xecho -b remote: Current Password is $_modsinfo.remote.password;
	};
};

## Aliases refered to by the config
alias remotehelp (void) {
	more $(loadpath)modules/remote/README;
};

alias remoteload (void) {
	^load $(savepath)remote.save;
};

alias remotesave (void) {
	@rename($(savepath)remote.save $(savepath)remote.save~);
	@fd = open($(savepath)remote.save W);
	@write($fd config.remotehostname -l $_modsinfo.remote.hostname);
	@write($fd config.remotelistenport -l $_modsinfo.remote.listenPort);
	@write($fd config.remotepassword -l $_modsinfo.remote.password);
	@close($fd);
	xecho -b Remote settings saved to $(savepath)remote.save;
};

## Control aliases
alias _remoteListener (command) {
	if (command == [on]) {
		@remoteListenPort = listen($_modsinfo.remote.listenPort);
		if (isnumber($remoteListenPort)) {
			@_modsinfo.remote.listening = 1;
			^on #^dcc_raw 10 "% % N $_modsinfo.remote.listenPort" {
				if ((_onWhitelist($1)) && (_modsinfo.remote.connected != 1)) {
					_remoteClientHandler $0 $1 $3;
				} {
					dcc close raw $0;
				};
			};
		} {
			@_modsinfo.remote.listening = 0;
			_recho error binding to $_modsinfo.remote.listenPort;
		};
	} {
		_cleanup Shutting down...;
		^dcc close raw_listen $_modsinfo.remote.listenPort;
		@_modsinfo.remote.listening = 0;
	};
};

alias _remoteClientHandler (remoteFD, remoteIP, remotePort) {
	@_modsinfo.remote.authenticated = 0;
	@_modsinfo.remote.channels = "";
	@_modsinfo.remote.connected = 1;
	@_modsinfo.remote.clientFD = "$remoteFD";
	@_modsinfo.remote.clientIP = "$remoteIP";
	@_modsinfo.remote.clientPort = "$remotePort";
	@_modsinfo.remote.registered = 0;
	_recho $_modsinfo.remote.clientIP has connected to your client on FD $_modsinfo.remote.clientFD;
	^on #^dcc_raw 11 "$_modsinfo.remote.clientFD % $_modsinfo.remote.listenPort C" {
		_recho Connection closed to $1.;
		#FIXME: Add all the ons with a hook of 42
		for hook from 11 to 22 {
			^on #dcc_raw $hook -;
		};
	};
	^on #^dcc_raw 12 "$_modsinfo.remote.clientFD % D USER *" {
		@_modsinfo.remote.username = "$4";
		@_modsinfo.remote.realname = "$7-";
		_recho $1 claims to be $4@$5 \($7-\);
	};
	^on #^dcc_raw 13 "$_modsinfo.remote.clientFD % D PASS *" {
		if (_modsinfo.remote.password == [$4]) {
			@_modsinfo.remote.authenticated = 1;
		} {
			_cleanup Invalid password;
			_recho $1 sent incorrect password;
		};
	};
	^on #^dcc_raw 14 "$_modsinfo.remote.clientFD % D NICK *" {
		_recho $1 wants to be $4;
		if (! _modsinfo.remote.registered) {
			if (_modsinfo.remote.authenticated != 1) {
				_cleanup password required;
				_recho $1 didn't authenticate.
			} {
				_rsend :$_modsinfo.remote.hostname 001 $servernick() :Welcome to IRC!;
				_rsend :$_modsinfo.remote.hostname 002 $servernick() :Your host is $_modsinfo.remote.hostname running ircII $J \($V\) [$info(i)] $a.ver/$a.rel \($a.snap\);
				_rsend :$_modsinfo.remote.hostname 003 $servernick() :This server was created $stime($F);
				_rsend :$_modsinfo.remote.hostname 004 $servernick() $_modsinfo.remote.hostname ircII $J+$V+$info(i)+$a.ver+$a.rel+$a.snap iwos ovimnpstklbe";
			};
		} {
			nick $4;
		};
	};
	^on #^dcc_raw 15 "$_modsinfo.remote.clientFD % D PING *" {
		_rsend PONG $_modsinfo.remote.hostname $servernick();
	};
	^on #^dcc_raw 16 "$_modsinfo.remote.clientFD % D MODE *" {
		# FIXME: Implement
		_recho $1 wants to set $3-;
	};
	^on #^dcc_raw 17 "$_modsinfo.remote.clientFD % D PRIVMSG *" {
		if (left(1 $4)==[#]) {
			if (_inchan($4)) { msg $4 $after(: $5-); };
			_recho $4> $after(: $5-);
		} {
			msg $4 $after(: $5-);
			_recho *$4*> $after(: $5-);
		};
	};
	^on #^dcc_raw 18 "$_modsinfo.remote.clientFD % D JOIN *" {
		_recho $1 wants to $3-;
		@_modsinfo.remote.channels = "$4 $_modsinfo.remote.channels";
		if (findw($4" $currchans()) != -1) {
			_rsend :$servernick()!$_modsinfo.remote.username@$_modsinfo.remote.clientIP JOIN :$4;
			_rsend :$_modsinfo.remote.hostname MODE $4 +$chanmode($4);
			names $4;
		} {
			_rsend :$_modsinfo.remote.hostname 403 $servernick() $4 :Not currently in $4;
		};
	};
	^on #^dcc_raw 19 "$_modsinfo.remote.clientFD % D PART *" {
		_recho $1 wants to $3-;
		@_modsinfo.remote.channels = "$remw($4 $_modsinfo.remote.channels)";
		_rsend :$servernick() PART $4 :$5;
	};
	^on #^dcc_raw 20 "$_modsinfo.remote.clientFD % D WHO *" {
		#FIXME: Implement
		_recho $1 wants to $4-;
	};
	^on #^dcc_raw 21 "$_modsinfo.remote.clientFD % D INVITE *" {
		#FIXME: Implement
		_recho $1 wants to $4-;
	};
	^on #^dcc_raw 22 "$_modsinfo.remote.clientFD % D QUIT *" {
		_recho $1 has quit: $4-;
		_rsend $servernick() QUIT :$4-;
		_cleanup $4-;
	};
	^on #^dcc_raw 23 "$_modsinfo.remote.clientFD % D WHOIS *" {
		_recho $1 is trying to whois $4;
		whois $4;
		#FIXME: Add hooks for the various whois numerics
	};
	^on #^dcc_raw 24 "$_modsinfo.remote.clientFD % D NOTICE *" {
		if (left(1 $4)==[#]) {
			if (_inchan($4)) { notice $4 $after(: $5-); };
			_recho -$4> $after(: $5-);
		} {
			notice $4 $after(: $5-);
			_recho -$4> $after(: $5-);
		};
	};
	^on #^dcc_raw 24 "$_modsinfo.remote.clientFD % D LIST *" {
		fe ($currchans()) server chan {
			@chan = "$chop(1 $chan)";
			_rsend :$_modsinfo.remote.hostname 322 $servernick() $chan $numonchannel($chan) :;
		};
	};
	^on #-action 40 * (source, dest, text) {
		if (left(1 $dest)==[#]) {
			if (_inchan($dest)) {
				_rsend :$source!$userhost($nick) PRIVMSG $dest :$chr(1)ACTION $text$chr(1);
			};
		} {
			_rsend :$source!$userhost($nick) PRIVMSG $dest :$chr(1)ACTION $text$chr(1);
		};
	};
	^on #-invite 41 * (nick, channel) {
		_rsend $source!$userhost($nick) INVITE $servernick() $channel;
	};
	^on #-join 42 * (nick, channel, userhost, void) {
		if (_inchan($channel)) {
			_rsend :$nick!$userhost JOIN :$channel;
		};
	};
	^on #-kick 43 * (target, source, channel, reason) {
		if (_inchan($channel)) {
			_rsend :$source!userhost KICK $channel $target :$reason;
		};
	};
	^on #-kill 44 * (server, target, source, serverpath, reason) {
		# FIXME: Should only send nicks that are in joined channels
		# FIXME: How to say that the upstream server has killed you?
		if (servernick != target) {
			_rsend :$source!userhost KILL $target :$reason;
		};
	};
	^on #-mode 45 * (nick, target, modes) {
		if ((left(1 $target)==[#]) && (_inchan($target))) {
			_rsend :$nick!$userhost() MODE $target $modes;
		};
	};
	^on #-msg 46 * (nick, msg) {
		_rsend :$nick!$userhost() PRIVMSG $servernick() :$msg;
	};
	^on #-msg_group 47 * (nick, target, msg) {
		_rsend :$nick!userhost() PRIVMSG $target :$msg;
	};
	# Response to the names command
	^on #-353 48 * (source, chantype, channel, nicks) {
		if (_inchan($target)) {
			_rsend :$_modsinfo.remote.hostname 353 $servernick() $chantype $channel :$nicks;
		};
	};
	# End of names
	^on #-366 49 * (source, channel, void) {
		if (_inchan($target)) {
			_rsend :$_modsinfo.remote.hostname 366 $servernick() $channel :End of /NAMES list.;
		};
	};
	^on #-nickname 50 * (oldnick, newnick) {
		if (_inchan($target)) {
			_rsend :$oldnick!$userhost() NICK $newnick;
		};
	};
	^on #-notice 51 * (source, msg) {
		_rsend :$source!$userhost() NOTICE $servernick() :$msg;
	};
	^on #-part 52 * (source, channel, userhost, reason) {
		if (_inchan($channel)) {
			_rsend :$source!$userhost PART $channel :$reason;
		};
	};
	^on #-public 53 * (source, channel, msg) {
		if (_inchan($channel)) {
			_rsend :$source!$userhost() PRIVMSG $channel :$msg;
		};
	};
	^on #-public_notice 54 * (source, channel, msg) {
		if (_inchan($channel)) {
			_rsend :$source!$userhost() NOTICE $channel :$msg;
		};
	};
	^on #-public_other 55 * (source, channel, msg) {
		if (_inchan($channel)) {
			_rsend :$source!$userhost() PRIVMSG $channel :$msg;
		};
	};
	^on #-signoff 56 * (source, reason) {
		if (_inchan($channel)) {
			_rsend :$source!userhost QUIT :$reason;
		};
	};
	^on #-topic 57 * (source, channel, topic) {
		if (_inchan($channel)) {
			_rsend :$source!$userhost() TOPIC $channel :$topic;
		};
	};
	^on #-wallop 58 * (source, type, msg) {
		if (type == [*]) {
			_rsend :$source!$userhost() WALLOPS :$msg;
		} {
			_rsend :$source WALLOPS :$msg;
		};
	};
	^on #-who 59 * (channel, nick, words 2, userhost words 2, server, ircname) {
		if (_inchan($channel)) {
			_rsend :$_modsinfo.remote.hostname 352 $channel $userhost $server $nick :$ircname;
		};
	};
};

## Convienence aliases
alias remote (cmd) { config remote a $cmd; };

alias _cleanup (reason default "peep") {
	_rsend ERROR :Closing Link: $servernick() ($reason);
	^dcc close raw $_modsinfo.remote.clientFD;
	@_modsinfo.remote.authenticated = 0;
	@_modsinfo.remote.channels = "";
	@_modsinfo.remote.connected = 0;
	@_modsinfo.remote.clientFD = "";
	@_modsinfo.remote.clientIP = "";
	@_modsinfo.remote.clientPort = "";
	@_modsinfo.remote.registered = 0;
};
# Has the user joined a target channel?
alias _inchan (channel) {
	if (findw($channel $_modsinfo.remote.channels) != -1) {
		return 1;
	};
	return 0;
};

# Check the user against the whitelist
alias _onWhitelist (ip) {
	_recho Checking whitelist for $ip;
	return 1;
};

# Display important status messages to the local user
alias _recho (message) { xecho -b -l remote remote: $message; };

# Send lines to the client
alias _rsend {
	#if ([$1] != [PONG]) { _recho SEND: $*; };
	msg =$_modsinfo.remote.clientFD $*$chr(13);
};

## Setup some stuff
@levelctl(ADD remote);

## For debug
^on ^dcc_raw * { 
	if ([$3] != [ping]) { 
		#_recho RAW: $*;
	};
};
