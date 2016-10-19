# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage autobot;

@ bsavefile = word(0 $_modsinfo.abot.savefiles);
@ botprompt = "$cparse($(c1)auto)$cparse($(c2)bot)$(hblk):$(cl)";

#some compat aliases..//zak
alias delbot {botdel $*;};
alias botlist listbot;
alias abot listbot;
alias rmbot {botdel $*;};
#end.

alias _pad {
	@ function_return = "$1-$repeat(${[$0] - _printlen($1-)}  )";
};

alias addbot {
	if ( numwords($*) < 4) {
		xecho -v -- ---------------------------------------------------------------;
		xecho -v  | syntax: $Cparse(/addbot %K[%nbotnick%K|%nbotnick%K!%nbotident%K@%nbothost%K]%n password channel opcmd);
		xecho -v -- ---------------------------------------------------------------;
	}{
		@ :input1 = *0;
		if (ismask($input1)) {
			@ bothost = after(! $input1);
			@ botnick = before(! $input1);
		} else {
			if (!getuhost($input1)) { xecho $acban $botprompt $input1 is not on irc! }{
			@ bothost = sar(g/~/\*/$getuhost($input1));
			@ botnick = input1;
		};
	};
	if (bothost&&botnick) {
		@ :pass = encode($1);
		@ :chan = *2;
		@ :botcmd = "$3-";
		@ setitem(bots 0 !);
		@ setitem(bots $numitems(bots) $botnick!$bothost $pass $chan $botcmd);
		xecho $acban $botprompt $Cparse(%nbot added %c$botnick%K!%c$bothost%n pass%K:%c $decode($pass) %nchannel%K:%c $chan%n command%K:%n $botcmd);
		};
	};
};

alias listbot {
	xecho -v -- ---------------------------------------------------------------;
	if (numitems(bots)<2) {
		xecho -v  | the botlist is empty!;
	}{
		xecho -v  | $cparse($(hblk)[$(c2)n$(c1)um$(hblk)] [$(cl)$_pad(3 $(c2)c$(c1)hannel)$(hblk)] [$_pad(32 $(c2)u$(c1)serhost)$(hblk)] [$(c2)o$(c1)p cmd$(hblk)]$(cl));
		xecho -v  | ;
		for (@xx=1, xx<numitems(bots), @xx++) {
			@ :pass = decode($word(1 $getitem(bots $xx)));
			@ :uhost = word(0 $getitem(bots $xx));
			@ :cmd = word(3 $getitem(bots $xx));
			@ :chan = word(2 $getitem(bots $xx));
			xecho -v  | $cparse($(hblk)[$(c1)$[3]xx$(hblk)] [$(c1)$[10]chan$(hblk)] [$(c1)$[40]uhost$(hblk)] [$(c1)$[6]cmd$(hblk)]);
		};

	};
	xecho -v -- ---------------------------------------------------------------;
};

alias botsave {
	@ rename($(savepath)$bsavefile $(savepath)$bsavefile~);
	@ savec = open($(savepath)$bsavefile W T);
	@ write($savec ** autobot config file - saved $strftime($time() %D %T));
	for (@xx=0, xx<numitems(bots), @xx++) {
		@ write($savec @bot.$xx=[$getitem(bots $xx)]);
	};
	@ close($savec);
	xecho $acban abot settings saved to $(savepath)$bsavefile [mod];
};

alias botdel {
	if (@) {
		if (numitems(bots)<= *0) {
			xecho -v -- ---------------------------------------------------------------;
	xecho -v  | no such bot! }{
		xecho -v -- ---------------------------------------------------------------;
	@ delitem(bots $0)
}}{ 		xecho -v -- ---------------------------------------------------------------;
 xecho -v  | usage: /botdel <bot number>
 		xecho -v -- ---------------------------------------------------------------;
	};
};

alias botload {
	^eval load $(savepath)$bsavefile;
	@ delarray(bots);
	@ setitem(bots 0 !);
	@ ii = 1;
	while (bot[$ii]) {
		@ setitem(bots $ii $bot[$ii]);
		@ ii++;
	};
};

^on #-channel_sync 10 "*" (chan, void) {
	@:botmatch="";
	fe ($getmatches(bots *$chan*)) ii {
		@:cbot = getitem(bots $ii);
		@:bname = before(! $word(0 $cbot));
		@:bhost =after(! $word(0 $cbot));
		if (pattern($bname $chops($chan))== bname && match($bhost $userhost($bname))) {

			@botmatch=getitem(bots $ii);
		};
	};
	if (@botmatch) { 
		@:host=after(! $word(0 $botmatch));
		@:nick=before(! $word(0 $botmatch));
		@:cmd=word(3 $botmatch);
		@:pass=decode($word(1 $botmatch));
		if (ischanop($nick $chan)&&match($host $userhost($nick))) { 
			xecho $acban $botprompt msging $nick for ops on $chan;
			msg $nick $cmd $pass;
		};
	};
};


alias abhelp abothelp;
alias abothelp {
//echo -----------------------= Autobot Help =--------------------------;
//echo addbot  /addbot <botnick|botnick!botident@bothost> <password> <channel>;
//echo <cmd> adds bots to the botlist.;
//echo botdel  /botdel <num> delete bot from botlist;
//echo botsave /botsave saves bots to file;
//echo listbot /listbot lists all bots;
//echo delbot  /delbot - same as /botdel;
//echo botlist /botlist - same as /listbot;
//echo abot    /abot - same as /listbot;
//echo rmbot   /rmbot - same as /botdel;
//echo -------------------------------------------------------------------;
};

# crapple/kreca '05-07
# void/clogic '98
