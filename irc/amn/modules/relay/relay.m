# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# last modified by crapple 05.12.10 - pf conversion/cleaning house

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage relay;

osetitem relay rsendbuf Outbound Buffer:;
osetitem relay rfrombuf Inbound Buffer:;

# output_rewrite for relay(paste)
^set output_rewrite $_paste($1-)$1-;

# common relay funcs relw relm relsm reln relsn reld reldm
alias lpaste msg $T $line(${[$0]?[$0]:1});
alias lp lpaste;
alias paste {relw $*;};
alias reldsm {reldm $*;};

# var
@relayw='on';

# flushing pasto.
alias rflush {@delarray(_foo); @delarray(rnot); @delarray(rmesg); @delarray(smesg); \ 
@delarray(smsg); @delarray(snot); @delarray(rdmesg); @delarray(rdsmsg);};

# /config opts
alias config.rfrombuf {
	if (*0 == '-r') {
		return $rfrombuf;
	} else if (*0 == '-s') {
		if (#>1) {
			@ rfrombuf = *1;
		};
		//echo $acban Relay: Inbound buffer set to "$rfrombuf";
	};
};

alias config.rsendbuf {
	if (*0 == '-r') {
		return $rsendbuf;
	} else if (*0 == '-s') {
		if (#>1) {
			@ rsendbuf = *1;
		};
		//echo $acban Relay: Outbound buffer set to "$rsendbuf";
	};
};

alias inbuf {
	config.rfrombuf -s $*;
};

alias outbuf {
	config.rsendbuf -s $*;
};

## more complex/confusion jargon here for pasto funcs /relm /relw /relsm etc.
## ^^ a lot cleared up during bordom, should be much more readable now
## //crapple(zak)

alias _paste {
	if (relayw == 'on') {
		if (numitems(_foo) >= winsize()) {
			@delitem(_foo 0);
		};
		@setitem(_foo $numitems(_foo) $*);
	};
};

alias relw {
	^local xx;
	@relayw='off';
		for (@xx=0, xx<numitems(_foo), @xx++) {
			//echo [$xx] $getitem(_foo $xx);
		};
			input "[enter which line(s) to paste ENTER to cancel]: " {
			fe ($*) xx {
			@ aa = substr("-" $xx);
       			if ( aa != -1 ) {
				@start = left($aa $xx);
			       	@end = rest(${aa+1} $xx);
			}{
				@start = xx
				@end = xx
			};
					for (@cc=start,cc<=end, @cc++)
			{
				msg $T $getitem(_foo $cc);
			};
		};
		@relayw='on';
	};
};

on #-msg 33 * if (relayw == 'on') {
	if (numitems(rmesg) >=$(rfrombuf)) {
	@delitem(rmesg 0);
	};
	@setitem(rmesg $numitems(rmesg) $fparse(format_msg $0 $userhost() $1-));
};

alias relm {
	^local yy;
	@relayw='off';
	for (@yy=0, yy<numitems(rmesg), @yy++) {
		//echo [$(yy)] $getitem(rmesg $yy);
	};
	if (*0 != '-l') {
		input "[enter which line(s) to paste msg ENTER to cancel ]: " {
			fe ($*) xx {
				@ aa = substr("-" $xx);
				if ( aa != -1 ) {
					@start = left($aa $xx);
				       	@end = rest(${aa+1} $xx);
				}{
					@start = xx
					@end = xx
				};
						for (@cc=start,cc<=end, @cc++)
				{
					msg $T $getitem(rmesg $cc);
				};
			};
		};
	};
	@relayw='on';
};

on #-notice 33 * if (relayw == 'on') {
	if (numitems(rnot) >=$(rfrombuf)) {
		@delitem(rnot 0);
	};
	@setitem(rnot $numitems(rnot) $fparse(format_notice $0 $userhost() $1-));
};

alias reln {
	^local yy;
	@relayw='off';
	for (@yy=0, yy<numitems(rnot), @yy++) {
		//echo [$(yy)] $getitem(rnot $yy);
	};
	if (*0 != '-l') {
		input "[enter which line(s) to paste notice ENTER to cancel]: " {
			fe ($*) xx {
				@ aa = substr("-" $xx);
				if ( aa != -1 ) {
					@start = left($aa $xx);
				       	@end = rest(${aa+1} $xx);
				}{
					@start = xx
					@end = xx
				};
						for (@cc=start,cc<=end, @cc++)
				{
					msg $T $getitem(rnot $cc);
				};
			};

		};
	};
	@relayw='on';
};

^on #-send_msg 33 * if (relayw == 'on') {
	if (numitems(smsg) >=$(rsendbuf)) {
	@delitem(smsg 0);
	};
	@setitem(smsg $numitems(smsg) $fparse(format_send_msg $0 $1-));
};

alias relsm {
	^local zz;
	@relayw='off';
	for (@zz=0, zz<numitems(smsg), @zz++) {
		//echo [$(zz)] $getitem(smsg $zz);
	};
	if (*0 != '-l') {
		input "[enter which line(s) to paste smsg ENTER to cancel]: " {
			fe ($*) xx {
				@ aa = substr("-" $xx);
				if ( aa != -1 )	{
					@start = left($aa $xx);
				       	@end = rest(${aa+1} $xx);
				}{
					@start = xx
					@end = xx
				};
						for (@cc=start,cc<=end, @cc++)
				{
			     		msg $T $getitem(smsg $cc);
				};
			};
		};
	};
	@relayw='on';
};

^on #-send_notice 33 * if (relayw == 'on') {
	if (numitems(snot) >=$(rsendbuf)) {
		@delitem(snot 0);
	};
	@setitem(snot $numitems(snot) $fparse(format_send_notice $0 $1-));
};

alias relsn {
	^local zz;
	@relayw='off';
	for (@zz=0, zz<numitems(snot), @zz++) {
		//echo [$(zz)] $getitem(snot $zz);
	};
	if (*0 != '-l') {
		input "[enter which line(s) to paste snotice ENTER to cancel]: " {
			fe ($*) xx {
				@ aa = substr("-" $xx);
				if ( aa != -1 ) {
					@start = left($aa $xx);
				       	@end = rest(${aa+1} $xx);
				}{
					@start = xx
					@end = xx
				};
						for (@cc=start,cc<=end, @cc++)
				{
					msg $T $getitem(snot $cc);
				};
			};
		};
	};
	@relayw='on';
};

on #-dcc_chat 33 * if (relayw == 'on') {
	if (numitems(rdmesg) >=$(rfrombuf)) {
		@delitem(rdmesg 0);
	};
	@setitem(rdmesg $numitems(rdmesg) $fparse(format_dcc_chat $0 $1-));
};

alias reld {
	^local yy;
	@relayw='off';
	for (@yy=0, yy<numitems(rdmesg), @yy++)	{
		//echo [$(yy)] $getitem(rdmesg $yy);
	};
	if (*0 != '-l') {
		input "[enter which line(s) to paste msg ENTER to cancel ]: " {
			fe ($*) xx {
				@ aa = substr("-" $xx);
				if ( aa != -1 )
				{
					@start = left($aa $xx);
			       		@end = rest(${aa+1} $xx);
				}{
					@start = xx
					@end = xx
				};
						for (@cc=start,cc<=end, @cc++)
				{
					msg $T $getitem(rdmesg $cc);
				};
			};
		};
	};
	@relayw='on';
};

^on #-send_dcc_chat 33 * if (relayw == 'on') {
	if (numitems(rdsmsg) >=$(rsendbuf)) {
		@delitem(rdsmsg 0);
	};
	@setitem(rdsmsg $numitems(rdsmsg) $fparse(format_send_dcc_chat $0 $1-));
};

alias reldm {
	^local zz;
	@relayw='off';
	for (@zz=0, zz<numitems(rdsmsg), @zz++) {
		//echo [$(zz)] $getitem(rdsmsg $zz);
	};
	if (*0 != '-l') {
		input "[enter which line(s) to paste smsg ENTER to cancel]: " {
			fe ($*) xx {
				@ aa = substr("-" $xx);
				if ( aa != -1 )	{
					@start = left($aa $xx);
				       	@end = rest(${aa+1} $xx);
				}{
					@start = xx
					@end = xx
				};
						for (@cc=start,cc<=end, @cc++)
				{
		     			msg $T $getitem(rdsmsg $cc);
				};
			};
		};
	};
	@relayw='on';
};

## end relay functions

## fake relay funct

alias frelm {
	if ('$2') {
		@ffrom='$0';
		@fto='$1';
		@fmsg='$2-';
			^userhost $0 -direct -cmd if ([$4]!=[<UNKNOWN>]) {
				msg $T $fparse(format_msg $0 $3@$4)$fmsg;
			}{
				//echo $0 isn't on IRC right now.;
	   		};
		}{
	//echo usage : /frelm [fake nick] [nick/channel to send to] [fake msg]};
};

alias freln {
	if ('$2') {
		@ffrom='$0';
		@fto='$1';
		@fnot='$2-';
			^userhost $0 -direct -cmd if ([$4]!=[<UNKNOWN>]) {
				msg $T $fparse(format_notice $0 $3@$4 )$fnot;
			}{
				//echo $0 isn't on IRC right now.;
			};
	}{
	//echo usage: /freln [fake nick] [nick/channel to send to] [fake notice]};
};

## end fake relay.

alias rhelp {
//echo -----------------------= Relay Help =--------------------------;

//echo lpaste /lpaste will paste to current window last line recieved.;
//echo rflush /rflush will flush buffer for all;
//echo relm   /relm then <number(s)> to paste msg lines in buffer.;
//echo relsm  /relsm then <number(s)> to paste sent msg lines in buffer.;
//echo reln   /reln then <number(s)> to paste notice lines in buffer.;
//echo relsn  /relsn then <number(s)> to paste sent notice lines in buffer.;
//echo reld   /reld then <number(s)> to paste dcc lines in buffer.;
//echo reldm  /reldm then <number(s)> to paste sent dcc lines in buffer.;
//echo paste  /paste then <number> to paste line in buffer.;
//echo relw   /relw then <number> to paste line in buffer.;
//echo;
//echo Note: use -l switch to avoid input prompt, ie: /relm -l;

//echo -------------------------------------------------------------------;
};
