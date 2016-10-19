# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage scan;

^on ^names * {};

## fixups
alias pad.nick {
	if (left(1 $*) != '@' && left(1 $*) != '+') {
		return $[10]*;
	};
	return $[10]*;
};

alias fix.scan2 {
	return $msar(g/@/@/+/+/$pad.nick($0));
};

# Quite usless alias eh, unfortunatley some scans in sc/ depends on this
# which means all user save files
alias fix.scan3 {
	return $0;
};

alias printnames (printstats,lchan,lnick) {
	@:lnick=sar(g/?//$sar(g/.//$lnick));
	if (@lchan && printstats != 2) {
		@:xevars = "-w $winchan($lchan)";
	}{
		@:xevars = '-v';
	};
	@:scan1 = pattern(*@* $lnick);
	push scan1 $pattern(*+* $filter(*@* $lnick));
	push scan1 $filter(*+* $filter(*@* $lnick));
	@:nicks.ops = pattern(*@* $lnick);
	@:nicks.voc = pattern(*+* $lnick);
	@:nicks.non = filter(*+* $filter(*@* $lnick));
 	@:finfo = "$#nicks.ops $#nicks.non $#nicks.voc $lchan";
	if (@printstats && @format_scan_users) {
		xecho $xevars -- $fparse(format_scan_users $finfo);
	};
	if (@format_scan_header) {
		xecho $xevars -- $fparse(format_scan_header $finfo);
	};
	if (format_scan_width > 1) {
		@_swidth=word(0 $geom()) / format_scan_width;
	}{
		@_swidth=#nicks.ops + #nicks.non + #nicks.voc;
	};
	: {/*
	   This piece of code is a real bitch
	   took me a long time to figure out what it does do
	   first for each builds up two variables looking like this
	   @_nlist=[_nlist.1 _nlist.2 _nlist.3 ...] up to $_swidth
	   @_nlist2=[$fparse(form... $_nlist.1) $fparse(form... $_nlist.2) ...]
	
	   then it does a fe ($channel_nick_list) _nlist.1 _nlist.2 ... {
		xecho $_nlist.1 $_nlist.2 $_nlist.3 ... <--- _nlist2 simplified
	   }
	   
	   this is the most obscure lines of code I've ever seen,
	   hence the explanation. Someone has been smoking crack!
	   (It's a beautiful way to do it though ;) )
	   //Kreca
	*/};
	@:_nlist='';
	@:_nlist2='';
	fe ($jot(1 $_swidth)) n1 {
		push _nlist _nlist.$n1;
		push _nlist2 \$fparse\(format_scan_nicks \$_nlist\.$n1);
	};
	fe ($scan1) $_nlist {
		if (format_scan_nicks_border) {
			xecho $xevars -- $fparse(format_scan_nicks_border) ${**_nlist2};
		}{
			xecho $xevars -- ${**_nlist2};
		};
	};
	if (format_scan_footer) {
		xecho $xevars -- $fparse(format_scan_footer $finfo);
	};
};

### propz to robohak for clueing me into using the 366 numeric for nick list
on #^353 1 * {@nicks#="$3-";};
on ^366 "*" {
	printnames 1 $1 $nicks;
	assign -nicks;
};

alias scan (chan default "$serverchan()" , void){
	printnames 1 $chan $channel($chan);
};

alias sco (chan default "$serverchan()",void){
	^xecho -w $winchan($lchan) -- $fparse(format_scan_users_op $#channel($chan) $chan);
	printnames 0 $chan $pattern(*@* $channel($chan));
};

alias scn (chan default "$serverchan()",void) {
	@:lscan = pattern(*..* $channel($chan));
	push lscan $pattern(*.+* $channel($chan));
	push lscan $pattern(.\\?* $channel($chan));
	xecho -w $winchan($lchan) -- $fparse(format_scan_users_non $#nochops($chan) $chan);
	printnames 0 $chan $lscan;
};

alias scv (chan default "$serverchan()",void) {
	xecho -w $winchan($lchan) -- $fparse(format_scan_users_voc $#pattern(*.+* $channel($chan)) $chan);
	printnames 0 $chan  $pattern(*.+* $channel($chan));
};

alias sc {
        if (@) {
                names $*;
        }{
                scan;
        };
};

## users.m merged here, which is more appropriate
## last modified by rylan on 11.05.06 - RIP buddy. //zak

alias chop { chops $*; };
alias chops {
	if (!@) {
		@:chan = "$1" ? "$1" : "$serverchan()";
		fe ($chops($chan)) _foi {
			xecho -v$fparse(format_chops $_foi $chan);
		};
	}{
		if ('$0'=~'*!*@*') {
		@:chan = "$1" ? "$1" : "$serverchan()";
		fe ($chops($chan)) _n1 {
		if (match($0 $_n1!$userhost($_n1))) {
			xecho -v$fparse(format_chops $_n1 $chan);
		};};
	};};
};

alias nop { nops $*; };
alias nops {
	@:chan = "$1" ? "$1" : "$serverchan()";
	fe ($nochops($chan)) _foi {
	if (!@) {
		xecho -v$fparse(format_user_non $_foi $chan);
		};
			
	if ('$0'=~'*!*@*' && match($0 $_foi!$userhost($_foi))) {
		xecho -v$fparse(format_user_non $_foi $chan);
		};
	};
};

alias vocs {
	@:chan = "$1" ? "$1" : "$serverchan()";
	fe ($nochops($chan)) _foi {
	if (!@) {
		if (ischanvoice($_foi $serverchan())) {
		xecho -v$fparse(format_user_vocs $_foi $chan);
		};
	};
	if ('$0'=~'*!*@*' && match($0 $_foi!$userhost($_foi))) {
		if (ischanvoice($_foi $chan) && !ischanop($_foi $chan)) {
		xecho -v$fparse(format_user_vocs $_foi $chan);
		};
	};};
};

## common alias done by adam. some slience by crapple
alias common {
	if (*0 =='-q') {
		^local _quiet 1;
		^local _channel1 $1;
		if ([$2]) {
			^local _channel2 $2;
		}{
			^local _channel2 $serverchan();
		};
	}{
		^local _channel1 $0;
		if ([$1]) {
			^local _channel2 $1;
		}{
			^local _channel2 $serverchan();
		};
	};
	if (_channel1) {
		^local common_users $common($chanusers($_channel1) / $chanusers($_channel2));
		unless ((_quiet) && (common_users == N)) {
			xecho -v -b Common users on $_channel1 and $_channel2 \($numwords($common_users)\);
			printnames 0 0 $common_users;
		};
	}{
		xecho -b Usage: /common [-q] <channel1> [channel2];
		xecho -b Shows you the common users between channel1 and channel2, or channel1 and your current channel.;
		xecho -b If -q is passed, only output if there is more than one match.;
	};
};

# props to crapple for the name. -skullY
alias stalker {
	fe ($mychannels()) _channel {
		if (_channel != serverchan()) {
			common -q $_channel;
		};
	};
};
