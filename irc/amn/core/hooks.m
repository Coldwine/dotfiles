# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage hooks;

## exit hook
on #-exit 000 "*" {
	xecho -v -b Signon time  :    $stime($F);
        xecho -v -b Signoff time :    $stime($time());
        xecho -v -b Total uptime :    $tdiff(${time() - F});
        xecho -v -b signoff: $N \($*\);
};

## catch the "user is away" message and only display it once. 
## Thanks to fudd for this idea and inspiration from his script
## Note that this does not affect the output of /whois since the hook
## is pushed / popped //kreca
on ^301 "*"
{
	@:itemno = finditem(away_users $0);
	if (itemno < 0)
	{
		xecho $fparse(format_whois_away $1-);
		@:itemno=numitems(away_users);
		@setitem(away_users $itemno $0);
	} else if (time() - getitem(away_users_ts $itemno) > 260) {
		xecho $fparse(format_whois_away $1-);
	};
	@setitem(away_users_ts $itemno $time());
};

## edit topic stuff from the epic scripts.. used for /topic_input
## by kreca.
alias edit_topic
{
        ^local thetopic;
        ^stack push on 333;
        ^stack push on 332;
        ^stack push on 331;
        ^on ^333 * #;
        ^on ^332 * {
                bless;
                @ thetopic = "$2-";
        };
        ^on ^331 * #;
        ^topic;
        ^wait;
        ^parsekey erase_line;
        ^xtype -literal /topic $thetopic;
        stack pop on 331;
        stack pop on 332;
        stack pop on 333;
};
## end edit topic

## uptime hooks.
on #-msg 22 * {@lrm=[$1-];@lrmn=[$0]};
on #-send_msg 22 * {@lsm=[$1-];@lsmn=[$0]};
on #-notice 22 * {@lrn=[$1-];@lrnn=[$0]};
on #-send_notice 22 * {@lsn=[$1-];@lsnn=[$0]};

alias uptime {
	//echo --------------------------= Amnesiac Uptime =-------------------;
	//echo $uname(%s %r) \($uname(%m)\);
	//echo Client Version: ircII $J \($V\) [$info(i)] "$info(r)";
	//echo Client Running Since $stime($F);
	//echo Client Uptime: $tdiff2(${time() - F}) - PID: $pid(), PPID: $ppid();
	//echo $info(c);
	//echo Compile-time options: $info(o);
	//echo Amnesiac release/cvs id: $a.rel [cvs \($a.commitid\)];
	//echo Amnesiac release date: $a.date;
	//echo Amnesiac snap date: $a.snap;
	//echo Last Recv Message: \($lrmn\) $lrm;
	//echo Last Recv Notice: \($lrnn\) $lrn;
	//echo Last Sent Msg: $lsm;
	//echo Last Sent Notice: $lsn;
	//echo Last Channel invited to: $I;
	//echo Current server version: ${R};
	//echo Current Servername: ${S};
	//echo -----------------------------------------------------------------;
};
## end uptime functionality

## notify/signon cosmetics
^on ^notify_signon * {
	xecho -v $G SignOn by $0!$sar(g/@/@/$1-) on $strftime(%x at %X);
};

^on ^notify_signoff * {
	xecho -v $G SignOff by $0 on $strftime(%x at %X);
};
## end notify/signon cosmetics

## aliases/hooks for script version
alias svf (void) {
	if (@T)
		msg $T $fparse(format_version_reply);
};

alias sv (void) {
	if (@T)
	        msg $T ircII $J \($V\) [$info(i)] $a.ver/$a.rel\
		\($a.snap\) [cvs \($a.commitid\)];
};

alias supt (void) {
	if (@T)
		msg $T ircII $(J) \($V\) [$info(i)] client uptime: $tdiff2(${time() - F});
};

## version hook
^on ^ctcp_request "% % VERSION *" {
	^quote notice $0 :VERSION $fparse(format_version_reply) ${client_information} ;
};
## end version functionality

## set umode on connect
on #-connect 50 * {
	if (!_pubnick) {
		@_pubnick=N;
	};
	_relag;
	^timer 1 ^mode $servernick() +$getumode;
	_updatesbar;
        ^set quit_message $(J)[$info(i)] - $(a.ver) : $randread($(loadpath)reasons/quit.reasons);
};

## Deal with modes when they're not set
^on ^324 "% % +" {
	xecho -b Mode for channel $1 is not set;
};

## Silence common IRC/Epic annoyances

#/End of MOTD
^on ^376 * #;

## disable you've got mail!.
^on ^mail * #;

## disable annoying ctcp's.
^on ^ctcp_request "% % FINGER*";
^on ^ctcp_request "% % CLIENTINFO*";
^on ^ctcp_request "% % SOUND*";
^on ^ctcp_request "% % ECHO*";
^on ^ctcp_request "% % MP3*";
