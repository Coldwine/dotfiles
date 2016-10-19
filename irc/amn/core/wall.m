# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage wall;

## msg wall(hybrid/ratbox based ircds)
alias wall {
	if (ischanop($servernick() $serverchan())) {
		/msg @$serverchan() $*;
	}{
## Do it the old way
## format of targmax
## NAMES:1,LIST:1,KICK:1,WHOIS:1,PRIVMSG:4,NOTICE:4,ACCEPT:,MONITOR:
		
		@:tgt=serverctl(GET 4 005 TARGMAX);
		@:mxnotice=1;
		fe ($split(, $tgt)) cw {
			if ( word(0 $split(: $cw)) =='NOTICE' && numwords($split(: $cw)) > 1) {
				@mxnotice=word(1 $split(: $cw));
			};
		};
		@:rusers=chops();
		while (#rusers > 0) {
			^quote NOTICE $unsplit(, $leftw($mxnotice $rusers)) :\[ Wall / $serverchan() \] $*;
			@rusers=restw($mxnotice $rusers);
		};
		@_bwallform (@$serverchan() $*);
	};
};

alias _bwallform (chan,text) {
	@:pf=left(1 $chan);
	@chan=after($pf $chan);
	xecho -l publics -t $chan $fparse(format_bwall $pf $chan $text);
};
alias _wallform (nick,chan,text) {
	@:pf=left(1 $chan);
	@chan=after($pf $chan);
	xecho -l publics -t $chan $fparse(format_wall $pf $nick $chan $text);
};

fe (send_notice send_msg) con {
	fec (@+) cc {
		on ^$con "$cc#*" (chan, text) {
			@_bwallform($chan $text);
		};
	};
};

fe (public public_notice public_other) con {
	fec (@+) cc {
		on ^$con "% $cc#*" (nick, chan, text) {
			@_wallform($nick $chan $text);
		};
	};
};
