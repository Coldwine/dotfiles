# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage chanmodes;

## misc op funcs/alias
alias cot {^topic -$serverchan();};
alias untopic cot;
alias t {topic $*;};
alias c {//mode $serverchan() $*;};
alias ik {invkick $*;};
alias ki {invkick $*;};
alias cmode {c $*;};
alias lall partall;
alias lockdown lockchan;
alias lockchan {mode $serverchan() +im;};
alias unlock {mode $serverchan() -im;};
alias inv {invite $*;};

## bans/exempt. (functionality neear the end of the line!)
alias bki {bk $*;ignore $0 msgs;};
alias kbi {kb $*;ignore $0 msgs;};
alias bkt {qk $*;};
alias bk {bankick $*;};
alias kb {bankick $*;};
alias unban {ub $*;}
alias clearbans {ub $*;};
alias banstat bans;
alias sb bans;
alias btype {bantype $*;};
alias etype {exempttype $*;};
alias i invs;
alias e exs; 
alias exempt exs;
alias invites invs;
alias tpi tinv;
alias tpe texp;
alias pinv ui; 
alias pexp ue; 
alias exhelp exempthelp;

## ban aliases.
alias fuckem lban;
alias lban {
	//mode $serverchan() +bbb *!*@0.0.0.0/1 *!*@128.0.0.0/1 *!*@0000::/1 $0 $0 $0 $0;
};

## chan info.
alias scano {sco $*;};
alias scanv {scv $*;};
alias scann {scn $*;};
alias n {^names $serverchan();};

## misc abstract funcs/aliases
alias epart emopart;
alias emopart {
	part $serverchan() $randread($(loadpath)reasons/emopart.reasons);
};

alias partall {
	part $sar(g/ /,/$mychannels());
};

## oper /who in #chan <-- am i the only one who thinks this is ugly? //zak
alias cops {
	^on who -*;
	^on ^who * {
		@:ck=left(2 $2);  
		if ( ck =='G*' || ck == 'H*') {
			xecho $[9]0 $[9]1 $[20]5 $3@$4;
		};
	};
	if (@) {
		who $0;
	}{
		who $serverchan();
	};
	wait;
	^on who -*;
	^on ^who * {
		xecho $fparse(format_who $*);
	};
};

alias unkey {
        if (match(*k* $chanmode())) {
                //mode $serverchan() -k;
        } else {
                xecho -b No key on channel $serverchan();
        };
};

alias kick {
	if (ischannel($0) ) {
		@:target=*0;
		@:people=*1;
		@:reason="$2-";
	} {
		@:target=C;
		@:people=*0;
		@:reason="$1-";
	};
	
	if (!numwords($reason)) {
		@:reason=randread($(loadpath)reasons/kick.reasons);
	};

	fe ($split(, $people)) cur {
		//kick $target $cur $reason;
	};
};

alias _massmode (chan,mode,users) {
	@:maxModes=_maxmodes();
	@:modePrefix=left(1 $mode);
	@:mode=rest(1 $mode);
	if (!@s) {
		return;
	};
	if (substr(* $users) != -1 ) {
		@:tmp = users;
		@users = "";
		fe ( $tmp ) curUser {
		      @push(users $pattern($curUser $chanusers($chan)));
		};
	};
	@:cs="";
	@:cm="";
	@:countHelper = jot(1 $strlen($mode));
	fe ( $users ) curUser {
		fe ($countHelper) dummy {
			^push cs $curUser;
		};
		@cm= "$(cm)$mode";
	};

	while (@cm) {
		@:var = b64encode($chan $(modePrefix)$left($maxModes $cm) $leftw($maxModes $cs));
		^queue massmode \{
			//quote mode \$b64decode\($var\)\;
		\};
		@cs = restw($maxModes $cs);
		@cm = rest($maxModes $cm);

	};
	^queue -do massmode;
};
alias 4op {
	@_massmode($serverchan() +oooo $*);
};

alias 4v {
	@_massmode($serverchan() +vvvv $*);
};

alias invkick {
	if (@) {
		//mode $serverchan() +i;
		kick $*;
		timer 10 mode $serverchan() -i;
	};
};

## basic chanop funcs /op /voice /deop /devoice
alias op {
	if (!@) {
		xecho -b Usage: /op <nickname|#channel> <nickname>;
	}{
		if (match(*#* $*)) {
			@_massmode($0 +o $1-);
		}{
			@_massmode($serverchan() +o $*);
		};
	};
};

alias v {voice $*;};
alias voice {
	if (!@) {
		xecho -b Usage: /voice <nickname|#channel> <nickname>;
	}{
		if (match(*#* $*)) {
			@_massmode($0 +v $1-);
		}{
			@_massmode($serverchan() +v $*);
		};
	};
};

alias dv {devoice $*;};
alias devoice {
	if (!@) {
		xecho -b Usage: /devoice <nickname|#channel> <nickname>;
	}{
		if (match(*#* $*)) {
			@_massmode($0 -v $1-);
		}{
			@_massmode($serverchan() -v $*);
		};
	};
};

alias mdv (chan default "$C", void) {
        @_massmode($serverchan() -v $remw($servernick() $onchannel($chan)));
};

alias dop {deop $*;};
alias deop {
	if (!@) {
		xecho -b Usage: /deop <nickname|#channel> <nickname>;
	}{
		if (match(*#* $*)) {
			@_massmode($0 -o $1-);
		}{
			@_massmode($serverchan() -o $*);
		};
	};
};

## mass chan modes /mv /mdv /mop /mdeop /mreop
alias mv {
	@_massmode($serverchan() +v $nochops());
};

alias mreop {
	@_massmode($serverchan() +o $chops());
};

alias allop { mop $*; };
alias mop (skippers) {
	if (@skippers) {
                xecho -b mass oping $serverchan() skipping $skippers;
		@_massmode($serverchan() +o $remws($skippers / $nochops()));
	}{
		@_massmode($serverchan() +o $nochops());
	};
};

alias alldeop { mdeop $*; };
alias mdop { mdeop $*; };
alias mdeop (keepers) {
	if (@keepers) {
		xecho -b mass deoping $serverchan() minus $keepers;
		@_massmode($serverchan() -o $remw($servernick() $remws($keepers / $chops())));
	}{
		xecho -b mass deoping $serverchan();
		@_massmode($serverchan() -o $remw($servernick() $chops()));
	};
};

# input allowed:
# /invite nick [#chan1 #chan2 #chan3]
# /invite [#chan] nick1 nick2 nick3
alias invite  {
	@:haschan=0;
	fe ($* ) cc {
		if (ischannel($cc)) {
			@:haschan=1;
		};

	};
	if (!@||(haschan==0&&!ischannel($serverchan()))) {
		xecho -b Usage: INVITE [#channel] nick1 nick2 nick3 ...;
		xecho -b Usage: INVITE nick #chan1 #chan2 #chan3 ...;
		return;
	};
# /invite [#chan] nick1 nick2 nick3
	if (ischannel($0)) {
		fe ($1-) nn {
			quote invite $nn $0;
		};
	} else if (haschan==0) {
		fe ($*) nn {
			quote invite $nn $serverchan();
		};
	} {
# /invite nick [#chan1 #chan2 #chan3]
		fe ($1-) cc {
			quote invite $0 $cc;
		};
	};
};

alias part {
         if (@) {
                 switch ($0) {
                         (#*) (&*) (0) (-*) (!*) (+*) {
                                 //part $*;
                         };
                         (*) {
                                 //part $serverchan() $*;
                         };
                 };
         }{
                 //part $serverchan();
         };
};

## cycle chan
alias cycle {
	@:chan=ischannel($0)?(*0):C;
	@:key=key($chan);
	if (ischannel($chan)) {
		xecho -b cycling on channel $chan\, one moment...;
		^quote part $chan;wait;join $chan $key;
	};
};

## emo cycle, randreads from emopart.reason
alias ecycle {
        @:chan=ischannel($0)?(*0):C;
        @:key=key($chan);
        xecho -b emo cycling on channel $chan\, one moment...;
        ^emopart $chan;wait;join $chan $key;
};

alias waitop {
	timer $srand($time())$rand(10) {
		if (! [$ischanop($0 $1)]) { 
			mode $1 +o $0 };
		};
	};

## mass kick modes. /lk /mkn /mko /mkn
alias lk {
	if (@) {
		fe ($nochops()) n1 {
			if (!ischanvoice($n1)) {
				k $n1 $*;
				};
		  	};
	}{
		fe ($nochops()) n1 {
			if (!ischanvoice($n1)) {
			k $n1 mass kick;
			};
		};
	};
};

alias mko {
	if (@) {
		fe ($remw($servernick() $chops())) n1 {
			k $n1 $*;
		};
	}{
		fe ($remw($servernick() $chops())) n1 {
			k $n1 mass kick;
	       	};
	};
};

alias mkn {
	if (@) {
		fe ($remw($servernick() $nochops())) n1 {
			k $n1 $*;
		};
	}{
		fe ($remw($servernick() $nochops())) n1 {
			k $n1 mass kick;
		};
	};
};

alias massk {
	if (!@) {
		xecho -b usage: /massk <version string>;
	}{
		@kvar=*0;
		xecho -b kicking all users with $kvar in version reply.;
		^ver $serverchan();
		^on ^ctcp_reply "% % VERSION *" {
			if (ischanop($0 $serverchan())==0 || kickops == 'on') {
				if (match(*$kvar* $2-)) {
					k $0 $kvar is leet!@#$%^&*;
				};
			};
			^timer 50 ^on ^ctcp_reply -"% % VERSION *";
		};
	};
};

# generic helper functions dealing with channel modes
alias genterm (name dwords 1,mode,lrpl_list,lrpl_eoflist) {
	@gmode=mode;
	@rpl_list=lrpl_list;
	@rpl_eoflist=lrpl_eoflist;
	^stack push on $rpl_list;
	^stack push on $rpl_eoflist;
	^on ^$rpl_list * {
		@setitem(term.$1 $numitems(term.$1) $2-);
	};
	^on ^$rpl_eoflist * {
		^stack pop on $rpl_list;
		^stack pop on $rpl_eoflist;
		if (numitems(term.$2)) {
			@chan=*2;
			for (@:xx=0,xx<numitems(term.$chan),@xx++) {
				@:ban=getitem(term.$chan $xx);
				//echo $(hblk)[$(cl)${xx+1}$(hblk)]$(cl) $word(0 $ban) set by $(hwht)$before(! $word(1 $ban)) $(cl)$tdiff(${time()-word(2 $ban)}) ago;
			};
			input "which $name(s) do you want to remove? " {
				fe ($*) xx {
		        		@:aa = substr("-" $xx);
					if ( aa != -1 ){
						@:start = left($aa $xx);
						@:end = rest(${aa+1} $xx );
					}{
						@start = xx;
						@end = xx;
					};
					for (@cc=start,cc<=end, @cc++){
						if (cc>0 && cc<=numitems(term.$chan)) {
							mode $chan -$gmode $word(0 $getitem(term.$chan ${cc-1}));
						};
					};
		            	};
				@delarray(term.$chan);
				@chan='';
			};
		};
	};
	^mode $serverchan() $mode;

};

alias gentall (lmode,lrpl_list,lrpl_eoflist) {
	@mode=lmode;
	@rpl_list=lrpl_list;
	@rpl_eoflist=lrpl_eoflist;
	^stack push on $rpl_list;
	^stack push on $rpl_eoflist;
	^on ^$rpl_list * {
		@setitem(ubans $numitems(ubans) $2);
		if (numitems(ubans)==4) {
			for (@:xx=0,xx<4,@:xx+=4) {
				//mode $serverchan() -$(mode)$(mode)$(mode)$(mode) $getitem(ubans $xx) $getitem(ubans ${xx+1}) $getitem(ubans ${xx+2}) $getitem(ubans ${xx+3});
			};
			@delarray(ubans);
		};
	};
	^on ^$rpl_eoflist * {
		^stack pop on $rpl_list;
		^stack pop on $rpl_eoflist;

		if (:num=numitems(ubans)) {
			//mode $serverchan() -$repeat($num $mode) $getitem(ubans 0) ${num>1?getitem(ubans 1):''} ${num>2?getitem(ubans 2):''};
		};
		@delarray(ubans);
	};
	//mode $serverchan() $mode;
};

alias genub (lmode,lrpl_list,lrpl_eoflist,...){
	@mode=lmode;
	@rpl_list=lrpl_list;
	@rpl_eoflist=lrpl_eoflist;
	if (!@) {
		@gentall($mode $rpl_list $rpl_eoflist);
	}{
		if (match(*!*@* $0)) {
			//mode $serverchan() -$mode $0;
		}{
			@nick = *0;
			^stack push on $rpl_list;
			^stack push on $rpl_eoflist;
			^on ^$rpl_list * {
				@setitem(ubans $numitems(ubans) $2);
			};
			^on ^$rpl_eoflist * {
				^stack pop on $rpl_list;
				^stack pop on $rpl_eoflist;
				^userhost $nick -cmd {
					if (rmatchitem(ubans $0!$3@$4) != -2) {
						mode $serverchan() -$mode $getitem(ubans $rmatchitem(ubans $0!$3@$4));
					}
					@delarray(ubans);
				}
			};
			//mode $serverchan() $mode;
		};
	};
};
alias gens (mode, chan default "$serverchan()"){
	^mode $chan $mode;
};
alias tban { @genterm("ban" b 367 368);};
alias texp { @genterm ("ban exempt" e 348 349);};
alias tinv { @genterm("invite exempt" I 346 347);};
alias takeall {@gentall (b 367 368);};
alias itall {@gentall (I 346 347);};
alias etall {@gentall (e 348 349);};
alias ub {@genub (b 367 368${@* ?" $*" : ''});};
alias ui {@genub (I 346 347${@* ?" $*" : ''});};
alias ue {@genub (e 348 349${@* ?" $*" : ''});};
alias bans {@gens (b${@* ?" $*" : ''});};
alias invs {@gens (I${@* ?" $*" : ''});};
alias exs {@gens (e${@* ?" $*" : ''});};

fe (346 348 367) cc {
	@:str="";
	if (cc == 367) {
		@str='ban';
	} else if (cc ==346) {
		@str='invite exempt';
	}{
		@str='ban exempt';
	}
	^on ^${cc+1} * {
		if ( *1 == 1 ) {
			xecho -b $$1 $str on $$2;
		}{
			xecho -b $$1 $(str)s on $$2;
		};
	};
	^on ^$cc * {
		//echo  [$1] [$2] [$3]  [$midw(1 3 $stime($4))];
	};
};


### Exempt functionality ###

## generic mode +I alias
alias _uhimode (et,chan, ...) {
	if ("$3@$4"!='<UNKNOWN>@<UNKNOWN>') {
		//mode $chan +I $mask($et $0!$3@$4);
	};
};
alias _imode (et,nick ,void) {
	fe ($split(, $nick)) cn {
		if (userhost($cn) == '<UNKNOWN>@<UNKNOWN>') {
			userhost $cn -cmd  \{ @ _uhimode\($et $serverchan() $$*\)\};
		}{
			//mode $serverchan() +I $mask($et $cn!$userhost($cn));
		};
	};
};

## Different iexempt aliases starting here
alias iexempt (nick,void){
	if (!@nick) {
		xecho -b Usage: /iexempt nick;
	}{
		fe ($split(, $nick)) cn {
			if (match(*!*@* $cn)) {
				//mode $serverchan() +I $cn;
			}{
				@_imode($_et $cn);
			};
		};
	};
};

# Generic iexempt alias. Used below
alias _iexp (aliasname,et,nick){
	if (!@et || !@nick) {
		xecho -b Usage: /$aliasname nick1,nick2;
		return;
	};
		@_imode($et $nick);
		/iexempt $nick;
	};
};

alias invexempt (nick) {
	@_iexp(invexempt $_iexp $nick);
};


## basically this allows you to specify the inv exempt type you want to
## use on the fly without needing to set /exempttype instead now we have
## /ieh(host) /ieb(better) /ied(domain) /iiexp(ident) followed by nick.
## Numbers used below is $mask(...) types
alias ieh (nick){@_iexp(ieh 2 $nick);};
alias ieb (nick){@_iexp(ieb 3 $nick);};
alias ied (nick){@_iexp(ied 4 $nick);};
alias iiexp (nick){@_iexp(iiexp 10 $nick);};


## generic mode +e alias.
alias _uhemode (et,chan, ...) {
	if ("$3@$4"!='<UNKNOWN>@<UNKNOWN>') {
		//mode $chan +e $mask($et $0!$3@$4);
	};
};
alias _emode (et,nick ,void) {
	fe ($split(, $nick)) cn {
		if (userhost($cn) == '<UNKNOWN>@<UNKNOWN>') {
			userhost $cn -cmd  \{ @ _uhemode\($et $serverchan() $$*\)\};
		}{
			//mode $serverchan() +e $mask($et $cn!$userhost($cn));
		};
	};
};

## ban exempt stuff here.
alias bexempt (nick,void){
	if (!@nick) {
		xecho -b Usage: /bexempt nick;
	}{
		fe ($split(, $nick)) cn {
			if (match(*!*@* $cn)) {
				//mode $serverchan() +e $cn;
			}{
				@_emode($_et $cn);
			};
		};
	};
};

# Generic iexempt alias. Used below
alias _bexp (aliasname,et,nick){
	if (!@bt || !@nick) {
		xecho -b Usage: /$aliasname nick1,nick2;
		return;
	};
		@_emode($et $nick);
		/bexempt $nick;
	};
};

alias banexempt (nick) {
	@_bexp(banexempt $_bexp $nick);
};


## basically this allows you to specify the ban exempt type you want to
## use on the fly without needing to set /exempttype instead now we have
## /beh(host) /beb(better) /bed(domain) /biexp(ident) followed by nick.
## Numbers used below is $mask(...) types
alias beh (nick){@_bexp(beh 2 $nick);};
alias beb (nick){@_bexp(beb 3 $nick);};
alias bed (nick){@_bexp(bed 4 $nick);};
alias biexp (nick){@_bexp(biexp 10 $nick);};

## end exempt functions

## ban functionality

## generic mode +b alias. Used all over the place
alias _uhbmode (bt,chan, ...) {
	if ("$3@$4"!='<UNKNOWN>@<UNKNOWN>') {
		//mode $chan +b $mask($bt $0!$3@$4);
	};
};
alias _bmode (bt,nick ,void) {
	fe ($split(, $nick)) cn {
		if (userhost($cn) == '<UNKNOWN>@<UNKNOWN>') {
			userhost $cn -cmd  \{ @ _uhbmode\($bt $serverchan() $$*\)\};
		}{
			//mode $serverchan() +b $mask($bt $cn!$userhost($cn));
		};
	};
};

## Different ban aliases starting here
alias ban (nick,void){
	if (!@nick) {
		xecho -b Usage: /ban nick;
	}{
		fe ($split(, $nick)) cn {
			if (match(*!*@* $cn)) {
				//mode $serverchan() +b $cn;
			}{
				@_bmode($_bt $cn);
			};
		};
	};
};

# Generic bk alias. Used below
alias _bk (aliasname,bt,nick, reason){
	if (!@bt || !@nick) {
		xecho -b Usage: /$aliasname nick1,nick2 [reason];
		return;
	};
	@_bmode($bt $nick);
	if (@reason) {
		kick $nick $reason;
	}{
		kick $nick;
	};
};

alias bankick (nick, reason) {
	@_bk(bankick $_bt $nick $reason);
};

## basically this allows you to specify the bantype you want to
## use on the fly without needing to set /bantype instead now we have
## /bkh(host) /bkb(better) /bkn(normal) /bkd(domain) followed by nick.
## Numbers used below is $mask(...) types
alias bkh (nick, reason){@_bk(bkh 2 $nick $reason);};
alias bkb (nick, reason){@_bk(bkb 3 $nick $reason);};
alias bkn (nick, reason){@_bk(bkn 6 $nick $reason);};
alias bkd (nick, reason){@_bk(bkd 4 $nick $reason);};
## iban alias. (i stands for ident)
alias iban (nick, reason){@_bk(iban 10 $nick $reason);};

## end bankick type on the fly.
alias kickban (nick,reason){
	if (!@nick) {
		xecho -b Usage: /kickban nick1,nick2 [reason];
        }{
		if ( @reason) {
			kick $serverchan() $nick $reason;
		}{
			kick $serverchan() $nick;
                };
		@_bmode($_bt $nick);
	};

};

# temp bk
alias qk (nick,reason) {
	if (!@nick) {
		xecho $acban Usage: /qk <nick> <reason> - will bankick specified nick then unban them after 5 seconds.;
	}{
		if (@reason) {
			@bankick($nick $reason);
		}{
			@bankick($nick);
		};
		^timer 5 \{ub $nick\};
	};
};

## end kicks.

## config

alias kops {
	config.kickops -s $*;
};

alias config.kickops {
	if ( *0 == '-r' ) {
		return $kickops;
	} else if (*0 == '-s') {
		config.matchinput on|off kickops '$1' kick ops on ban;
	};
};

alias bantype {
	config.bantype -s $*;
};

## bantype config. [Norm/Better/Host/Domain]
alias config.bantype {
	if ( *0 == '-r' ) {
		return $bt_;
	} else if (*0 == '-s') {
		if (# == 1) {
			xecho -v $acban bantype set to $bt_;
			xecho -v $acban /bantype <Normal|Better|Host|Domain>;
		}{
			switch ($1) {
			(normal){@bt_='normal';@_bt=6;xecho -v $acban bantype set to normal (n!*u@h.d n!*u@d.h);}
			(better) {@bt_='better';@_bt=3;xecho -v $acban bantype set to better (*!*u@*.d *!*u@d.*);}
			(host) {@bt_='host';@_bt=2;xecho -v $acban bantype set to host (*!*@h.d *!*@d.h);}
			(domain) {@bt_='domain';@_bt=4;xecho -v $acban bantype set to domain (*!*@*.d *!*@d.*);}
			() {xecho -v $acban invalid choice <Normal|Better|Host|Domain>;}
			};
		};
	};
};

alias exempttype {
	config.exempttype -s $*;
};

## exempttype config. [Norm/Better/Host/Domain]
alias config.exempttype {
	if ( *0 == '-r' ) {
		return $et_;
	} else if (*0 == '-s') {
		if (# == 1) {
			xecho -v $acban exempt type set to $et_;
			xecho -v $acban /exempttype <Normal|Better|Host|Domain>;
		}{
			switch ($1) {
			(normal){@et_='normal';@_et=6;xecho -v $acban exempt type set to normal (n!*u@h.d n!*u@d.h);}
			(better) {@et_='better';@_et=3;xecho -v $acban exempt type set to better (*!*u@*.d *!*u@d.*);}
			(host) {@et_='host';@_et=2;xecho -v $acban exempt type set to host (*!*@h.d *!*@d.h);}
			(domain) {@et_='domain';@_et=4;xecho -v $acban exempt type set to domain (*!*@*.d *!*@d.*);}
			() {xecho -v $acban invalid choice <Normal|Better|Host|Domain>;}
			};
		};
	};
};

osetitem protect kickops Kick ops:;
osetitem protect bantype Ban Type:;
osetitem protect exempttype Exempt Type:;

alias exempthelp {
//echo -----------------= Exempt Modes Help =----------------------------;
//echo tpi /tpi invite exempt menu -I ie: /tpi 3-6 removes;
//echo       invite exempts 3 4 5 and 6 shown in the menu.;
//echo tpe /tpe ban exempt menu +e ie: /tpe 4 to remove one exempt.;
//echo ui  /ui clears the invite exempts in current chan -IIII.;
//echo ue  /ue clears the ban exempts in current chan -eeee.;
//echo i   /i shows the invite exempts in current chan if any.;
//echo e   /e shows the ban exempts in current chan if any.;
//echo iexempt /iexempt <nick|nick1,nick2> adds invite exempt in current chan;
//echo ieh /ieh <nick|nick1,nick2> adds invite exempt of host on the fly;
//echo ieb /ieb <nick|nick1,nick2> adds invite exempt of better on the fly;
//echo ied /ied <nick|nick1,nick2> adds invite exempt of domain on the fly;
//echo iiexp /iiexp <nick|nick1,nick2> adds invite exempt of ident on the fly;
//echo beh /beh <nick|nick1,nick2> adds ban exempt of host on the fly;
//echo beb /beb <nick|nick1,nick2> adds ban exempt of better on the fly;
//echo bed /bed <nick|nick1,nick2> adds ban exempt of domain on the fly;
//echo biexp /biexp <nick|nick1,nick2> adds ban exempt of ident on the fly;
//echo etype /etype <Normal|Better|Host|Domain> set default exempt type;
//echo                      -----= Other Aliases =----;
//echo /pinv [/ui], /pexp [/ue], /tinv [/tpi], /texp [/tpe];
//echo ---------------------------------------------------------------------;
};
