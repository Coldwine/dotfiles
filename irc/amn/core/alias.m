# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage alias;

## last modified by crapple 05.16.10 - Cleanups/sort
## various commands.
alias quit {bye $*;};
alias ismask {return ${@pass(!@ $0) ? 1 : 0}};
alias settings {config $*;};
alias date {time $*;};
alias serverchan {return $winchan($serverwin());};

## more/less info from server.
alias ww {whowas $*;};
alias wi {whois $*;};
alias w {whois $*;};
alias who {//who ${ @ ? (*) : T};};
alias links {quote links $*;};
alias wii {if ( ! @ ) {whois $servernick() $servernick()} {whois $0 $0;}};
alias smsg {quote server :$*;};

## cid(+g)
alias accept { quote accept $*;};
alias cid aclist;
alias rmcid { quote accept -$*;};
alias aclist { quote accept * ;};
alias clist aclist;
alias cdel {rmcid $*;};

alias termtitle (msg) {
      //xecho -r $chr(27)]2\;${msg}$chr(7)
};

## to be annoying like xavier.
alias blinky { if (@T)  msg $T $cparse("%F%G$*") ;};

## for xavier with love //zak
alias retard {echo Retard alert, pling pling; parsekey stop_irc; echo Retard alert, pling pling;};

## general user commands
alias umode {^mode $servernick() $*;};
alias m {msg $*;};
alias d {describe $*;};
alias desc {describe $*;};
alias j {/join $channame($0) $1-;};
alias p {if (@) { ping $*; }{ ping $serverchan() }; };
alias k {kick $*;};
alias l {part $*;};
alias host {//userhost $*;};
alias irchost {hostname $*;};
alias unset {set -$*;};
alias unalias {alias -$*;};
alias not {notice $*;};
alias ll {lastlog $*;};
alias lll {lastlog -literal $*;};
alias llw {lastlog -window $*;};
alias llt {lastlog -target $*;};
alias llm {lastlog -mangle ALL $*;};
alias verk {massk $*;};
alias csc {clear;sc;}; 
alias a {ahelp $*;};
alias finger {ctcp $0 finger;};
alias about {more $(loadpath)ans/about.ans;};

## toggable aliases
alias arejoin {set auto_rejoin toggle;};
alias aww {set auto_whowas toggle;};
alias debug {set debug $*;};
alias lls {set lastlog $*;};
alias mon {set old_math_parser on;};
alias moff {set old_math_parser off;};
alias ioff {set -input_prompt;};
alias tog {toggle $*;};
alias ircname {set default_realname $*;};
alias realname {set default_realname $*;};
alias username {set default_username $*;};
alias clock24 {set clock_24hour toggle;};

## dumps and reload script, for scripters and adv users
alias adump {
	//dump all;
	fe ($getarrays()) n1 {@delarray($n1)};
	unload * fe;
	bind -defaults;
	load ~/.epicrc;
};

## CrazyEddie's alias
alias comatch return ${match($*)||rmatch($*)};
## end

alias _center {
	@ number = (word(0 $geom()) - printlen($*)) / 2;
	xecho -v $repeat($trunc(0 $number)  )$*;
};

## long complex aliases below here. this used for anything? //zak
alias cat {
	if (@) {
		@:ansifile = open($0 R T);
		while (!eof($ansifile)) {
			//echo $read($ansifile);
		};
		@close($ansifile);
	};
};
## we use this for anything? //zak
alias evalcat {
	if (@) {
		@:ansifile = open($0 R T);
		while (!eof($ansifile)) {
			eval //echo $read($ansifile);
		};
		@close($ansifile);
	};
};

## ignore functionality
alias ign {ignore $*;};
alias cloak {ignore *!*@* ctcp;};
alias unig tig;
alias rmignore tig;
## end short aliases.

alias tig {
	@igns=numsort($ignorectl(REFNUMS));

	if ( strlen($igns) ) {
		fe ($igns) ignores {
			xecho -b [$ignores] $ignorectl(GET $ignores NICK) $ignorectl(GET $ignores LEVEL);
		};
		input "enter # of which ignore to takeoff: " {
			if ( ( "$0" >= word(0 $igns)) && "$0" <= word(${numwords($igns)-1} $igns)) {
				@ignorectl(DELETE $0);
			}{
				xecho -b number out of range \($word(0 $igns) - $word(${numwords($igns)-1} $igns)\);
				};
			};
		}{
		xecho -b no ignores currently;
	};
};

alias _ighost (uh,void){
	if (match(*!*@* $uh)) {
		return $uh;
	}{
		if (:uhost=getuhost($uh)) {
                        return *!$uhost;
		}{
			return $uh;
		};
       };
};

alias ignore {
	if (#) {
		if (# > 1) {
			//ignore $_ighost($0) $1-;
		}{
			//ignore $_ighost($0) all;
		};
	}{
		xecho -b Ignorance List:;
		@:igns=numsort($ignorectl(REFNUMS));
		if ( strlen($igns) ) {
			fe ($igns) ignores {
				xecho -b [$ignores] $ignorectl(GET $ignores NICK) $ignorectl(GET $ignores LEVEL);
			};
	
		};
	};
};
		
alias cig {
	if (@) {
		^ignore $0 public;
		xecho -b ignoring public from $0, /tig to unignore;
	}{
		^ignore $serverchan() public;
		xecho -b ignoring public from $serverchan() , /tig to unignore;
	};
};

## end ignore functionality

## script echo //does this still needing cleaning??
alias abwecho {xecho -v $acban $cparse($*);};
alias aecho {//echo $cparse($*);};
alias abecho {xecho -b -- $cparse($*);};
alias ce {//echo $cparse("$*");};
