# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

## functions/aliases/partial sets/from scripts/builtins

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};
subpackage compat;

## NOTE: alot of functions/aliases/etc. in compat.m are from scripts/builtins
## which was written by BlackJac, tho we try to use only what we really need
## parts have also been merged/rewritten to fit in with Amnesiac.
## Add his copyright here, to lessen the bloat in compat.m
## Copyright (c) 2005 (BlackJac@EFNet)

alias addset (name, type, args) {
	if (@name && type) {
		@ symbolctl(create $name);
		@ symbolctl(set $name 1 builtin_variable type $type);
		if (args) {
			@ symbolctl(set $name 1 builtin_variable script $args);
		};
	};	
};

alias delset (name, void) {
	if (@name) {
		@ symbolctl(delete $name builtin_variable);
		@ symbolctl(check $name);
	};
};

## Functions
alias decode (...) {
	return $xform(-ENC $*);
};

alias encode (...) {
	return $xform(+ENC $*);
};

alias b64decode (...) {
	return $xform(-B64 $*);
};

alias b64encode (...) {
	return $xform(+B64 $*);
};

alias sha256 (...) {
	return $xform(+SHA256 $*);
};

alias urldecode (...) {
	return $xform(-URL $*);
};

alias urlencode (...) {
	return $xform(+URL $*);
};

alias igmask (pattern, void) {
	return $ignorectl(pattern $pattern);
};

alias igtype (pattern, void) {
	fe ($ignorectl(get $ignorectl(refnum $pattern) levels)) ii {
		push function_return ${ii =~ '+*' ? "$rest(1 $ii)" : sar(#/##$sar(#^#DONT-#$ii))};
	};
};

alias rigmask (pattern, void) {
	return $ignorectl(rpattern $pattern);
};

alias rigtype (...) {
	return $ignorectl(with_type $*);
};

alias sedcrypt (encode, who, ...) {
	if (!(:val = encryptparm(who))) {
		return;
	};
	@ :key = word(1 $val);
	if (encode == 1) {
		return $xform(+SED $key $who $*);
	} else if (encode == 0) {
		return $xform(-SED $key $who $*);
	};
	return;
};

## Server/win handling compatability.
alias servergroup (refnum default "$serverctl(from_server)", void) {
	if (:group = serverctl(get $refnum group)) {
		return $group;
	};
	return <default>;
};

alias servername (refnum default "$serverctl(from_server)", void) {
	if (:name = serverctl(get $refnum itsname)) {
		return $name;
	};
	return <none>;
};

alias servernick (refnum default "$serverctl(from_server)", void) {
	return $serverctl(get $refnum nickname);
};

alias servernum (refnum default "$serverctl(from_server)", void) {
	if ((:num = serverctl(refnum $refnum)) >= -1) {
		return $num;
	};
	return -1;
};

alias serverourname (refnum default "$serverctl(from_server)", void) {
	if (:ourname = serverctl(get $refnum name)) {
		return $ourname;
	};
	return <none>;
};

alias servertype (refnum default "$serverctl(from_server)", void) {
	return $serverctl(get $refnum protocol);
};

alias servports (refnum default "$serverctl(from_server)", void) {
	return $serverctl(get $refnum port) $serverctl(get $refnum localport);
};

alias winlevel (winnum default 0, void) {
	return $windowctl(get $windowctl(refnum $winnum) window_level);
};

alias winnicklist (winnum default 0, void) {
	return $windowctl(get $windowctl(refnum $winnum) nicklist);
};

alias winnum (winnum default 0, void) {
	if (:num = windowctl(get $windowctl(refnum $winnum) refnum)) {
		return $num;
	};
	return -1;
};

alias winrefs (void) {
	return $windowctl(refnums);
};

alias winserv (winnum default 0, void) {
	if ((:serv = windowctl(get $windowctl(refnum $winnum) server)) >= -2) {
		return $serv;
	};
	return -1;
};

alias myservers (arg, void) {
	fe ($serverctl(omatch *)) mm {
		if (serverctl(get $mm connected)) {
			push :servers $mm;
		};
	};
	fe ($servers) nn {
		push function_return ${@arg ? nn : servername($nn)};
	};
		
};

alias notifywindows (void) {
	fe ($windowctl(refnums)) nn {
		if (windowctl(get $nn notified)) {
			push function_return $nn;
		};
	};
};

alias lastserver (void) {
	return $serverctl(last_server);
};

alias winsize (winnum default 0, void) {
	return $windowctl(get $windowctl(refnum $winnum) display_size);
};

alias winstatsize (winnum default 0, void) {
	if ((:statsize = windowctl(get $windowctl(refnum $winnum) double)) > -1) {
		return ${statsize + 1};
	};
	return -1;
};

alias winvisible (winnum default 0, void) {
	if ((:visible = windowctl(get $windowctl(refnum $winnum) visible)) >= -1) {
		return $visible;
	};
	return -1;
};

## auto-whowas
alias whowas (nick, number default "$num_of_whowas", void) {
	//whowas $nick $number;                             
};

## Auto_Rejoin
^on #-kick 1 '$$servernick() *' {
	if (getset(auto_rejoin) == 'on') {
		if (:delay = getset(auto_rejoin_delay)) {
			timer -w $winnum() $delay join $2;
		} else {
			defer join $2;
		};
	};
};

## BEEP_ON_MSG
^on #-action 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(action $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-ctcp 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(ctcp $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-msg 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(msgs $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-notice 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(notices $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-oper_notice 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(opnotes $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-server_notice 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(snotes $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-wallop 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(wallops $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-who 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(crap $getset(beep_on_msg)) > -1) {
		beep;
	};
};
