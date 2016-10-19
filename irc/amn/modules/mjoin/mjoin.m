# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage mjoin;

@chansfile=word(0 $_modsinfo.mjoin.savefiles);

## some aliases for mjoin
alias chanlist listchan;
alias addjoin {addchan $*;};
alias ajoin {addchan $*;};
alias unajoin {delchan $*;};
alias deljoin {delchan $*;};
alias mjhelp ajhelp;
##end aliases.

alias addchan {
	if (# < 2 || ! isnumber($1)) {
		xecho $acban Usage: /addchan #chan <window#> [key];
	}{
		@setitem(chans 0 !);
		@setitem(chans $numitems(chans) $0 $1 $2);
		xecho $acban.. added $0 to channel list \(window: $1\);
	};
};

alias listchan {
	if (numitems(chans) == 1) {
			xecho $acban no channels current on list;
	}{
xecho -v -- ------------------------------------------------------------------;
		for (@xx=1, xx<numitems(chans), @xx++) {
			xecho -v  | $cparse(%K[%n$xx%K]%n) $getitem(chans $xx);
		};
xecho -v -- ------------------------------------------------------------------;
	};
};

alias delchan {
	if ( ! # ) {
	    	xecho $acban Usage: /delchan item number | #channel;
     	}{
		if (isnumber($0)) {
			@:thenum = [$0];
		}{
			@:thenum = matchitem(chans $0);
			if (thenum < 0) {
				xecho $acban channel $0 not found in the channel list;
				return;
			};
		};
		xecho $acban deleted $getitem(chans $thenum) from the list;
		@delitem(chans $thenum);
	};
};


alias mjoin {
	for (@xx=1, xx<numitems(chans), @xx++) {
		@:cur=getitem(chans $xx);
		@:chan = word(0 $cur);
		@:winno = word(1 $cur);
		@:key = word(2 $cur);
		^wjn $winno $chan $key;
	};
};

alias chansave {
	@rename($(savepath)$chansfile $(savepath)$chansfile~);
	@savemt = open($(savepath)$chansfile W T);
	for (@xx=1, xx<numitems(chans), @xx++) {
		@write($savemt @chans.$xx=[$getitem(chans $xx)]);
	};
	@close($savemt);
	xecho $acban Mjoin channel(s) saved to $(savepath)$chansfile [mod];
};

alias chanload {
	^eval load $(savepath)$chansfile;
	@delarray(chans);
	@ii = 1;
	@setitem(chans 0 !);
	while (chans[$ii]) {
		@setitem(chans $ii $chans[$ii]);
		@ii++;
	};
};

alias ajhelp {
		//echo ----------------------= Mjoin Help =---------------------------;
		//echo addchan /addchan #chan <window#> [key] will add specified channel to mjoin;
		//echo addjoin /addjoin #chan <window#> [key] will add specified channel to mjoin;
		//echo delchan /delchan <num> |#chan will delete channel from mjoin list;
		//echo listchan /listchan will show a list of channels on the mjoin list;
		//echo mjoin  /mjoin will join all channels on mjoin list;
		//echo chansave /chansave will save mjoin list;
		//echo chanload /chanload will load mjoin list from $(savepath)$chansfile;
		//echo                   -= Mjoin Quick Aliases =-;
		//echo listc/listchan ajlist/listchan chanlist/listchan;
		//echo addjoin/addchan ajoin/addchan;
		//echo unajoin/delchan deljoin/delchan rmjoin/delchan unjoin/delchan;
		//echo ---------------------------------------------------------------;
};
