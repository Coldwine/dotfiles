# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# last modified by crapple 9.2.05
# windowing stuff
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage window;

## more complex windowing stuff here.
alias channame (cn , void) {
	if (ischannel($cn))
		return $cn;
	return #$cn;
};

alias wj (cn,...){
	if (@cn) {
		^window new channel "$channame($cn) $*" hide swap last;
	}{
		xecho -v $acban usage: /wj <channel> [key];	
        };
};

alias wjn (n , cn, ...){
	if (@n && @cn) {
		if ( @windowctl(GET $n REFNUM) == 0) {
			^window new hide swap last number $n;
		};
		^window $n channel "$channame($cn) $*" swap last;
	}{
		xecho -v $acban usage: /wj <number> <channel> [key];
        };
};
alias new_window_with_properties (number,properties) {
	@:new_window=1;
	if (number > 0) {
		if (windowctl(GET $number REFNUM) > 0) {
			@new_window=0;
			^window 
				$number
				$properties;
		};
	};
	if (new_window == 1) {
		@:refnum = windowctl(NEW);
		^window 
			$refnum 
			hide 
			swap last 
			$properties
			;
		if (number > 0) {
			^window $refnum number $number;
		};
	};
};
alias mw (command,number default 0,void){
	@:properties = "level msgs,dccs name msgs";
	if (@command) {
		switch ($command) {
			(-hidden) {
				@new_window_with_properties($number $properties);
			};
			(-split) {
				@:refnum = windowctl(NEW);
				^window 
					$refnum
					double off 
					fixed on 
					size 7 
					status_format %>[msgs] 
					$properties;
				^window back;
			};
			(-kill) {
				^window msgs kill;
			};
		};
	}{
		xecho -v $acban /mw -hidden|split|kill [number] <will create/kill a window bound to msgs>;
	};
};

alias winmsg {
	^window new;
	^window level msgs;
	^window size 5;
	^window refnum 1;
};

alias wlc {echo $windowctl(GET 0 CHANNELS);};

alias wq {
        if (#) {
                window new_hide swap last query $0;
        } elsif (Q) {
                query;
                ^window $winnum() kill;
        };
};

alias wlk (void) {
	if (@serverchan())
		part $serverchan();
	wk;
};

# Have F3 go to the oldest window, not the newest window.
alias _WSACT {^window swap $rightw(1 $notifywindows());};

## shortend aliases.
alias wc {^window new hide swap last};
alias msgwin {wc;wsl;window level msgs,notices;window name messages;};
alias wsa _wsact;
alias s {window swap $*;};

## misc.
alias wflush window flush_scrollback;
alias cls clear;
alias clsa clear -ALL;

## for Alien88
alias wnc2 {window new hide swap last split off channel $0 $1 $2;};

## query
alias qw {wq $*;};
alias q {query $*;};

## window shortcuts.
alias wsl window swap last;
alias wka wkh;
alias wkh window kill_all_hidden;
alias wko window kill_others;
alias wsg window grow;
alias wss window shrink;
alias ws window swap;
alias wn window next;
alias wp window previous;
alias wk window killswap;
alias wl window list;

## window toggles/config/options
alias wname {window name $*;};
alias wlog window log toggle;
alias wfile {window logfile $*;};
alias wlevel {window level $*;};
alias wnotify window notify toggle;
alias wnlevel {window notify_level $*;};
alias wskip window skip toggle;
alias windent window indent toggle;
alias indent {set indent $*;};
alias wswap window swappable toggle;
alias wfix window fixed toggle;
alias wlast {window lastlog $*;};

# window toggle simplification.
#
# Copyright (c) 2003 (BlackJac@EFNet)
# This will allow you to toggle between hidden windows 1 through 20 more
# easily. Press Esc+1 to toggle between windows 1 and 11, Esc+2 for win-
# dows 2 and 12, etc., up through Esc+0 for windows 10 and 20.
#
# Simplifications by kreca

alias toggle.window (number, void) {
	if (@number) {
		@number= number ? number : 10;
		@ :wn = winnum() == number ? number+10 : number;
		if (winnum($wn) != -1) {
			^window swap $wn;
		} else {
			if ( wn <= 10 && winnum(${wn+10}) != -1) {
				^window swap ${wn+10};
			} else if (wn > 10 && winnum($number) != -1) {
				^window swap $number;
			};
		};
	};
};

on #-window_create 123 "*" {
	if ( windowdoubles == 'on' ) {
		window $0 double on;
	};
};

#bind meta-0 to meta-9 to toggle.window
fe ($jot(0 9 1)) tt {
	bind ^[$tt parse_command toggle.window $tt;
};

# alias /0 - /60 to swap to that window (/10 is nonexistent by purpose,
# use /0 instead, or /10 via alias)
alias 10 window swap 10;
fe ($jot(1 60 1)) tt {
	@:t2= tt != 10 ? tt : 0;
	alias $t2 ^window swap $tt;
};
