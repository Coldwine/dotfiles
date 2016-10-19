# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
        load -pf $word(1 $loadinfo());
        return;
};

subpackage eoper;
load -pf ${loadpath}modules/oper/easykline.m;

osetitem oper ovmode Operview modes:;
osetitem oper ovsize Operview win size:;
osetitem oper skills Show server kills:;
osetitem oper srkline Show remote klines:;
osetitem oper srkbots Show TOR-OPM and spamtrap klines:;
osetitem oper owcopy WO/LO in all windows:;
osetitem oper dateconv Expire tdiff2:;
@ bindctl(sequence ^E set parse_command _spageu);
@ bindctl(sequence ^D set parse_command _spaged);
@ bindctl(sequence ^G set parse_command _glinelast);

## opervision bindkey funcs scrollback/scrollup
alias _spageu {
	@:_cwin=winnum();
	window ref operview;
	parsekey SCROLL_BACKWARD;
	window ref $_cwin;
};

alias _spaged {
	@:_cwin=winnum();
	window ref operview;
	parsekey SCROLL_FORWARD;
	window ref $_cwin;
};

## compat funcs? //hack?
alias _winnames {
	fe ($winrefs()) n1 {
		if (match($0 $winnam($n1))) {
		return $n1;
	}{
		return 0;
		};
	};
};

## dynamic config funcs
alias config.ovsize {
	if ( [$0] == [-r] )
	{
		return $_ovsize;
	} else if ([$0] == [-s]) {
		if (#>1) {
			@ _ovsize = [$1];
		};
		xecho -v $acban operview window size set to "$_ovsize";
	};
};

alias config.ovmode {
	if ( [$0] == [-r] )
	{
		return $_ovmode;
	} else if ([$0] == [-s]) {
		if (#>1) {
			@ _ovmode = [$1];
		};
		xecho -v $acban oper modes set to "$_ovmode";
	};
};

alias config.skills {
	if ( [$0] == [-r] )
	{
		return $skills;
	} else if ([$0] == [-s]) {
		config.matchinput on|off skills '$1' show server kills;
	};
};

alias config.srkline {
	if ( [$0] == [-r] )
	{
		return $srkline;
	} else if ([$0] == [-s]) {
		config.matchinput on|off srkline '$1' show remote klines;
	};
};

alias config.srkbots {
	if ( [$0] == [-r] )
	{
		return $srkbots;
	} else if ([$0] == [-s]) {
		config.matchinput on|off srkbots '$1' show remote klines from bots;
	};
};

alias config.owcopy {
	if ( [$0] == [-r] )
	{
		return $owcopy;
	} else if ([$0] == [-s]) {
		config.matchinput on|off owcopy '$1' copy operwall to all windows;
	};
};

alias config.dateconv {
	if ( [$0] == [-r] )
	{
		return $dateconv;
		
	} else if ([$0] == [-s]) {
		config.matchinput on|off dateconv '$1' convert kline/gline times to remaining time;
	};
};

alias ovsize {
	config.ovsize -s $*;
};

alias ovmode {
	config.ovmode -s $*;
};

alias omode {
	if ([$0]==[on]) {
		umode +sckf;
	};
	if ([$0]==[off]) {
		umode -sckf;
	};
};


alias skills {
	config.skills -s $*;
};

alias srkline {
	config.srkline -s $*;
};

alias srkbots {
	config.srkbots -s $*;
};

alias owcopy {
	config.owcopy -s $*;
};

alias dateconv {
	config.dateconv -s $*;
};

alias _dateconv {
	# $tdiff2(${strptime("%a %b %e %T %Y %Z" Tue Mar  4 10:40:19 2008 EST) - time()})
	if(datedebug =='ON') {
		abecho $0-;
	};
	return $tdiff2(${strptime("%a %b %e %T %Y %Z" $0-) - time()});
};

## amazing gline functions
alias gi {
	^local zz
	if (numitems(glineTargets)<2) { 
		abecho %CGline%n list is empty!;
		return;
	};
	for (@zz=1, zz<numitems(glineTargets), @zz++) {
		aecho $cparse(%K[%C$(zz)%K]%n %W$getitem(glineTargets $zz)%n for $getitem(glineReasons $zz));
	}
	if ([$0] != [-l]) {
		input "[enter which line(s) to gline (ENTER to cancel)]: " {
			fe ($*) xx {
				@ aa = substr ("-" $xx);
				if ( aa !=  -1);
				{
					@start = left($aa $xx);
					@end = rest(${aa+1} $xx);
				}
				{
					@start = xx;
					@end = xx;
				}
				for (@cc=start,cc<=end, @cc++)
				{
                                	/quote gline $getitem(glineTargets $cc) :$lsnip($getitem(glineReasons $cc));
					$delitem(glineTargets $cc);
					$delitem(glineReasons $cc);
				}
			};
		};
	};
};

alias cleargi {
	#for (@zz=1, zz<numitems(glineTargets), @zz++) {
	#	$delitem(glineTargets $zz)
	#	$delitem(glineReasons $cc)
	#}
	$delarray(glineTargets);
	$delarray(glineReasons);
	@ setitem(glineTargets 0 !);
	@ setitem(glineReasons 0 !);
};

alias _glinelast {
	if (numitems(glineTargets)<2) {
		abecho There are no pending %CGLINE%ns;
		return;
	};
	if (getitem(glineTargets numitems(glineTargets))) {
		@gt = getitem(glineTargets ${numitems(glineTargets)-1});
		@gr = getitem(glineReasons ${numitems(glineReasons)-1});
		abecho $cparse(executing %CGLINE%n) on $gt for $gr;
		/quote gline $gt :$lsnip($gr);
		@delitem(glineTargets ${numitems(glineTargets)-1});
		@delitem(glineReasons ${numitems(glineReasons)-1});
	};
};

## end config funcs

## gline funcs for Mikey(Alien88)
#on -server_notice "*requesting gline for*" {
#	@glineTarget=strip([] [$11]);
#	@glineReason=strip([] [$12-]);
#};

#alias gi {
#	input "GLINE $glineTarget for '$glineReason'? (y/n) " {
#		if ( [$0] == [y] ) /quote gline $glineTarget :$glineReason;
#	};
#};

## operview func
alias ov {operview $*};
alias operview (command,number default 0,void){
	@:properties = "name OperView level snotes,opnotes,wallops indent on";
	if (@command) {
		switch ($command) {
			(-hidden) {
				abecho $banner operview is turned on.;
				@new_window_with_properties($number $properties);
				umode +$_ovmode;
				quote flags all -CLICONNECTS -CLIDISCONNECTS -THROTTLES -NICKCHANGES -JUPENAMES -CLICONNV;
			};
			(-split) {
				abecho $banner operview is turned on.;
				@:refnum = windowctl(NEW);
				^window 
					$refnum
					double off 
					fixed on 
					size $_ovsize
					$properties
					status_format "[operview] %> [$servername($winserv(OperView))]";
			
					umode +$_ovmode;
					quote flags all -CLICONNECTS -CLIDISCONNECTS -THROTTLES -NICKCHANGES -JUPENAMES -CLICONNV;
					^window back;
			};
			(-kill) {
				abecho $banner operview is turned off.;
				^window Operview kill;
				^umode -$_ovmode;
				quote flags all -CLICONNECTS -CLIDISCONNECTS -THROTTLES -NICKCHANGES -JUPENAMES -CLICONNV;
			};
		};
	}{
		xecho -v $acban /operview -hidden|split|kill [number] <will create/kill a window bound to OperView>;
	};
};

alias doper {
	umode -o;
};

alias operwall {
	quote operwall :$*;
};

alias adminwall {
	quote adminwall :$*;
};

alias locops {
	quote locops :$*;
};

alias tkline {
	if (![$0]) {
		xecho $acban usage: /tkline <minutes> [nick|hostmask] <reason>;
	}{
		quote kline $0 $1 :$2-;
	};
};

alias kline {
	if (match(*@* $0)) {
		quote kline $0 :$1-;
	}{
		if (getuhost($0)) {
			quote kline $sar(g/*!*//$mask(3 $getuhost($0))) :$1-;
		}{
			abecho $0 no such nick.;
		};
	};
};

alias unkline {
	quote unkline $*;
};

alias kill {
	quote kill $0 :$1-;
};

alias mkill {
	if (![$0]) {
		fe ($remw($servernick() $chanusers($serverchan()))) n1 {
		quote kill $n1 :bye;
		};
	}{
		fe ($remw($servernick() $chanusers($serverchan()))) n1 {
		quote kill $n1 :$*;
		};
	};
};

alias mkline {
	if (![$0]) {
		fe ($remw($servernick() $chanusers($serverchan()))) n1 {
		kline $n1;
		};
    }{
		fe ($remw($servernick() $chanusers($serverchan()))) n1 {
		kline $n1 $*;
		};
	};
};

## /who in #chan, unformatted...
alias whotrace wholist;
alias chantrace wholist;
alias wholist {
        ^on who -*;
        ^on ^who * {
                xecho $[9]0 $[3]2 $[9]1 $[25]5 $3@$4;
        };
        if (@) {
                who $0;
        }{
                who $C;
        };
        wait;
        ^on who -*;
        ^on ^who * {
                xecho $fparse(format_who $*);
        };
};

alias operspy {
        ^on who -*;
        ^on ^who * {
                xecho $[9]0 $[3]2 $[9]1 $[25]5 $3@$4;
        };

        quote operspy $0-;
        wait;
        ^on who -*;
        ^on ^who * {
                xecho $fparse(format_who $*);
        };
}

alias dwho {//who -dx $*;};

alias gline {
	quote gline $0 :$1-;
};

alias dline {
        quote dline $0 :$1-;
};

alias zline {
	quote zline $0 :$1-;
};

alias unzline {
	quote unzline $*;
};

alias undline {
	quote undline $*;
};

alias watch {
	quote watch $*;
};

alias cjupe {
	quote mode $0 +j;
};

alias ucjupe {
	quote mode $0 -j;
};

alias modlist {
	quote modlist;
};

alias modload {
	quote modload $*;
};

alias modunload {
	quote modunload $*;
};

## Abusive commands (will remain undocumented)
alias ojupe {
	quote jupe $0 :$1-;
};

alias ojoin {
	quote ojoin @$channame($0) $1-;
};

alias okillhost {
	quote killhost $*;
};

alias oclearchan {
	quote clearchan $*;
};

## oper servnotice parses/hooks
#^on ^server_notice "% % % % % % % % % /whois*" {
#	aecho $fparse(format_timestamp_some $($_timess))[$9] on you requested by $4!$5);
#};

^on ^server_notice * {
	aecho $fparse(format_timestamp_some $($_timess))$2-;
};

^on ^server_notice "% % % % LINKS*" {
	aecho $fparse(format_timestamp_some $($_timess))[links $5] requested by $8!$9 $10;
};

^on ^server_notice "% % % % STATS*" {
	aecho $fparse(format_timestamp_some $($_timess))[stats '$5'] requested by $8!$9 $10;
};

^on ^server_notice "% % % % % % % % % (O)*" {
	aecho $fparse(format_timestamp_some $($_timess))$4!$5 is now a $8 $9;
};

^on ^server_notice "% % % % % exiting:*" {
	aecho $fparse(format_timestamp_some $($_timess))Client exiting: $6!$7 $8-;
};

^on ^server_notice "% % % % % connecting:*" {
	aecho $fparse(format_timestamp_some $($_timess))Client connecting: $6!$7 $8-;
};

^on ^server_notice "% % % % % % rehashing*" {
	aecho $fparse(format_timestamp_some $($_timess))$4 is rehashing $7- ;
};

^on ^server_notice "% % % % ADMIN*" {
	aecho $fparse(format_timestamp_some $($_timess))[Admin] requested by $7!$8 $9-;
};

^on ^server_notice "% % % % % SQUIT*" {
	aecho $fparse(format_timestamp_some $($_timess))$4 $5 $6 from $8 $9-;
};

^on ^server_notice "% % % % % was connected*" {
	aecho $fparse(format_timestamp_some $($_timess)) $4 $5 $6 $7 $8 $9 $10-;
};

^on ^server_notice "% % % % Link with*" {
	aecho $fparse(format_timestamp_some $($_timess))Link $5 $6 $7-;
};

^on ^server_notice "% % % % % % already present*" {
	aecho $4$fparse(format_timestamp_some $($_timess))$5 $6 $7 from $9;
};

## test stuff
^on ^server_notice "% % % % % % % whois*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%R$pad(7 " " whois))] $3 \($5\) [$2];
};

^on ^raw_irc "% WALLOPS :LOCOPS -*" {
	aecho $fparse(format_timestamp_some $($_timess))%K\(%glo%K/%W$before(! $0)%K\) %n$4-;
	if (owcopy =='on') {
		fe ($windowctl(REFNUMS)) xx {
			if (windowctl(GET $xx VISIBLE) == 0) {
				xecho -nolog -f -w $xx $fparse(format_timestamp_some $($_timess))$cparse(%K\(%glo%K/%W$before(! $0)%K\)) $4-;
			};
		};
	};
};

^on ^raw_irc "% WALLOPS*" {
	aecho $fparse(format_timestamp_some $($_timess))%K\(%Row%K/%W$before(! $0)%K\) %n$after(: $2-);
	if (owcopy =='on') {
		fe ($windowctl(REFNUMS)) xx {
			if (windowctl(GET $xx VISIBLE) == 0) {
				xecho -nolog -f -w $xx $fparse(format_timestamp_some $($_timess))$cparse(%K\(%Row%K/%W$before(! $0)%K\)) $after(: $2-);
			};
		};
	};
};

^on ^server_notice "*Received GLINE*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%C$pad(7 " " gline)%n] %K[%n$after(\( $6)%K]%n) $10 from $before(! $12)@$14-;

	if (finditem(glineTargets $strip([] [$10])) <= -1) {
		quote testmask $strip([] [$10]);
		@ setitem(glineTargets 0 !);
		@ setitem(glineReasons 0 !);
		@ setitem(glineTargets $numitems(glineTargets) $strip([] [$10]));
		@ setitem(glineReasons $numitems(glineReasons) $strip([] [$after(: $14-])));
	};
};

^on ^server_notice "Notice -- *added*JUPE*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%G$pad(7 " " jupe))] $4-;
};

^on ^server_notice "*Remote KLINE for*ignored*" {
	if (srkline =='ON') {
		aecho $fparse(format_timestamp_some $($_timess))[$cparse(%y$pad(7 " " rkline))] $4-;
	};
};

^on ^server_notice "*Denying remote KLINE from*" {
	if (srkline =='ON') {
		aecho $fparse(format_timestamp_some $($_timess))[$cparse(%y$pad(7 " " rkline))] DENIED $12 from $before(! $8)@$10;
	};
};

^on ^server_notice "*being introduced by*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%B$pad(7 " " network)%n]) $before([ $5) $after(] $5-);
};

^on ^server_notice "*Notice -- OPERSPY*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%Koperspy%n]) $5-;
};

^on ^server_notice "*has split from*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%B$pad(7 " " network)%n]) $4-;
};

^on ^server_notice "*End-of-Burst acknowledged*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%B$pad(7 " " network)%n]) $4-;
};

^on ^server_notice "*Added GLINE for*" {
    if (dateconv =='ON') {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%C$pad(7 " " gline)%n]) GLINE added for $7 expiring in  $_dateconv($10-);
    } else {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%C$pad(7 " " gline)%n]) GLINE added for $7-;
    };
	^local nn;
	@ nn = finditem(glineTargets $strip([] [$7]));
	$delitem(glineTargets $nn);
	$delitem(glineReasons $nn);
};

^on ^server_notice "*juped channel*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%G$pad(11 " " c%W/%Gjupe))] $cparse(%K[%n$14%K]%n) $5 $6;
};

^on ^server_notice "*KILL message*" {
	if (skills =='off' && count(. $10) > 0) { # do nothing
	} else {
		aecho $fparse(format_timestamp_some $($_timess))[$cparse(%p$pad(7 " " kill))] $before(. $8) from $10 $13-;
	};
};

^on ^server_notice "*Nick change*" {
	aecho $fparse(format_timestamp_some $($_timess))[$pad(9 " " nick)] $7 -> $9 $10;
};

^on ^server_notice "*juped nickname*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%g$pad(11 " " n%W/%gjupe))] $13 $5 $14-;
};

^on ^server_notice "*Kill line active*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%Y$pad(7 " " kline))] $8- has been klined.;
};

^on ^server_notice "*added KLINE for*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%Y$pad(7 " " kline))] $4 -> $8-;
};

^on ^server_notice "*added KLINE for*expiring at*" {
    if (dateconv =='ON') {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%Y$pad(7 " " kline))] $4 -> $8 expires in $_dateconv($11 $12 $13 $14 $15 $before(: $16)): $17-;
    } else {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%Y$pad(7 " " kline))] $4 -> $8-;
    };
};

^on ^server_notice "*Received remote KLINE*" {
	if (srkline =='ON') {
		aecho $fparse(format_timestamp_some $($_timess))[$cparse(%y$pad(7 " " rkline))] $before(! $8)@$10 -> $12-;
	};
};

^on ^server_notice "*Remote KLINE added*" {
	if (srkline =='ON') {
		aecho $fparse(format_timestamp_some $($_timess))[$cparse(%y$pad(7 " " rkline))] $8-;
	};
};

^on ^server_notice "*Added KLINE % to*" {
	aecho $fparse(format_timestamp_some $($_timess))[$cparse(%Y$pad(7 " " kline))] $4 added to config file;
};

## end test

^on ^wallop '% % LOCOPS *' {
        aecho $fparse(format_timestamp_some $($_timess))%WWALLOP $0%n LOCOPS - $4-;
};

^on ^wallop '% % ADMINWALL *' {
        aecho $fparse(format_timestamp_some $($_timess))%WWALLOP $0%n ADMINWALL - $4-;
};

^on ^wallop '% % OPERWALL *' {
        aecho $fparse(format_timestamp_some $($_timess))%WWALLOP $0%n OPERWALL - $4-;
};

## elite format to determine diffs on kills in opervision
^on ^server_notice "* removed * ?-Line *" {
	switch ($8) {
		(K-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%b$8%n] $4 $5 $6 $7 %b$8%n $9 %R$10%n);
		}
		(G-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%g$8%n] $4 $5 $6 $7 %g$8%n $9 %R$10%n);
		}
		(D-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%c$8%n] $4 $5 $6 $7 %c$8%n $9 %R$10%n);
		}
		(X-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%p$8%n] $4 $5 $6 $7 %p$8%n $9 %R$10%n);
		}
		(*) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%y$8%n] $4 $5 $6 $7 %y$8%n $9 %R$10%n);
		};
	};
};

^on ^server_notice "* added ?-Line for *" {
	switch ($6) {
		(K-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%b$6%n] $4 $5 %b$6%n $7 %R$8%n %m$9-%n);
		}
		(G-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%g$6%n] $4 $5 %g$6%n $7 %R$8%n %m$9-%n);
		}
		(D-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%c$6%n] $4 $5 %c$6%n $7 %R$8%n %m$9-%n);
		}
		(X-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%p$6%n] $4 $5 %p$6%n $7 %R$8%n %m$9-%n);
		}
		(*) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%y$6%n] $4 $5 %y$6%n $7 %R$8%n %m$9-%n);
		};
	};
};

^on ^server_notice "* added temporary * ?-Line for *" {
	switch ($9) {
		(K-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%b$9%n] $4 $5 $6 %b$7 $8 $9%n $10 %R$11%n %m$12-%n);
		}
		(D-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%c$9%n] $4 $5 $6 %c$7 $8 $9%n $10 %R$11%n %m$12-%n);
		}
		(X-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%p$9%n] $4 $5 $6 %p$7 $8 $9%n $10 %R$11%n %m$12-%n);
		}
		(*) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([$y$9%n] $4 $5 $6 $y$7 $8 $9%n $10 %R$11%n %m$12-%n);
		};
	};
};

^on ^server_notice "* ?LINE active for *" {
	switch ($4) {
		(DLINE) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%c$4%n] $5 $6 %R$7%n $8-);
		}
		(KLINE) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%b$4%n] $5 $6 %R$7%n $8-);
		}
		(*) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%y$4%n] $5 $6 %R$7%n $8-);
		};
	};
};
## End elite kill formatting.

## cosmetic/silencing hooks for activated server numerics
^on ^382 * {
	aecho $1-;
};

^on ^365 * {
	aecho $1 $2 of links list.;
};

^on ^243 * {
	aecho $1-;
};

^on ^219 * #;

## oper help menu
alias eohelp {
//echo -----------------------= Oper Help =--------------------------;

//echo /tkline <minutes> [nick|ident@host] <reason> will temp kline for;
//echo specified minutes.;
//echo /unkline <ident@host> will remove kline from server list.;
//echo /operwall <text> will send a operwall with specified text to the server.;
//echo /ov -hidden|split|kill [number] <will create/kill a window bound to OperView>;
//echo /mkline <reason> will mass kline current channel for specified reason;
//echo /mkill <reason> will mass kill current channel;
//echo /locops <text> will send a msg to all operators on current server;
//echo /kline <nick|ident@host> will set a kline for nick or specified ident@host;
//echo /modlist view ircd modules.;
//echo /modload <text> loads specified ircd module.;
//echo /modunload <text> unloads specified ircd module.;
//echo /dline <ip> reason.  will set a dline with reason. (ratbox);
//echo /undline <ip> will remove a dline. (ratbox);
//echo binds ^E scroll_backward in ovwin ^D scroll_forward in ovwin;
//echo binds ^G glinelast;
//echo -------------------------------------------------------------------;
};
