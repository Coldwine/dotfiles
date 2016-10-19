# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage server;

## aliases
alias svrtime {time $S;};
alias disco {disconnect $*;};

## first crack at aliases for multiserver/connection/modifying etc..
alias svlist server;
alias svadd {server -add $*;};
alias svhadd {server -add $0:vhost=$1-;};
alias svdel {server -delete $*;};
alias svnick {server -add $0:6667::$1-;};
alias ssl {server -add $0:$1-:type=irc-ssl;};
alias snext {server +;};
alias sprev {server -;};

## chan/mem/nickserv/services/irritating ircd stuff
alias ms {quote MemoServ $*;};
alias ns {quote NickServ $*;};
alias cs {quote ChanServ $*;};
alias chanserv {cs $*;};
alias nickserv {ns $*;};
alias memoserv {ms $*;};
alias mserv {msg memoserv $*;};
alias nserv {msg nickserv $*;};
alias cserv {msg chanserv $*;};
alias allow {dccallow $*;};
alias dccallow {quote dccallow $*;};

## configuration options/aliases for functions included in the file
alias otime {setorig $*;};
alias jupe {orignick $*;};

alias setorig {
	config.origdelay -s $*;
};

## multiserv stuff.
alias wcs {wser $*;};
alias wns {wser $*;}; 
alias wser (srv) {
	if (srv) {
		^window new server $srv hide swap last;
	} else {
		xecho $acban Usage: /wser <server[:port[:password[:nick]]]>;
	};
};

alias _wser {
	input "Server[:port[:password[:nick]]]: " (srv) {
			if (@srv) {
		^wser $srv;
		};
	};
};

alias _statusmsg {
	@:smsg = serverctl(GET 4 005 TARGMAX);
	if (!@smsg) {
		@smsg='@+';
	};
	return $smsg;
};

alias _maxmodes {
  ^local num;
  @ num = serverctl(get $servernum() 005 MODES);

  if (ceil($num) != num) {
	@num=3;
  };
  if (num < 1) {
	@num=3;
  };
  if (num > 10) {
		@num=10;
	};
	return $num;
};

## Newnick from src/epic5/scripts by BlackJac.
## Copyright (c) 2005 (BlackJac@EFNet)

alias newnick.mangle (nick, void) {
	@ :length = getset(auto_new_nick_length);
	return ${@nick < length ? nick ## getset(auto_new_nick_char) : right(1 $nick) ## mid(0 ${length - 1} $nick)};
};

^on ^new_nickname "*" {
	if (getset(auto_new_nick) == 'on') {
		if ( @(:nicklist = getset(auto_new_nick_list)) ) {
			if (!(:nick = word(${findw($2 $nicklist) + 1} $nicklist))) {
				@ :nick = newnick.mangle($2);
			};
		} else {
			@ :nick = newnick.mangle($2);
		};
		xeval -s $0 nick $nick;
	} else {
		input "Nickname: " {
			nick $0;
		};
	};
};

## motd suppress function from epic scripts written by
## Jeremy Nelson
@ negser = getserial(HOOK - 0);
@ posser = getserial(HOOK + 0);

# The first time we see the MOTD, trigger the "doing motd" flag.
on #^375 $negser * {
	if (!done_motd[$lastserver()]) {
		^assign doing_motd[$lastserver()] 1;
	};
};
# When we see the end of the first MOTD, trigger the "done motd" flag.
on #^376 $posser * {
	if (doing_motd[$lastserver()]) {
		^assign -doing_motd[$lastserver()];
		^assign done_motd[$lastserver()] 1;
	};
};
# When the connection is closed, reset the flag.
on #^server_lost $posser * {
	^assign -done_motd[$lastserver()];
};

# Only suppress the first MOTD from each server connection.
for i in (372 375 376 377) { 
	on ^$i * {
		if (getset(suppress_server_motd) == 'ON' && doing_motd[$lastserver()]) {
			return;
		};
		xecho -b $1-;
	};
};
## hop'y2k+3
## end motd suppression funcs

## orignick functionality
^timer -del 45;
@keepnick=0;

alias orignick {
	if (!@) {
		xecho $acban /orignick <nick> /staynick to cancel;
	}{
		^timer -delete 45;
		@nic="$0";
		@keepnick=1;
		^timer -window -1 -refnum 45 -rep -1 $_ort {
			^getnick $nic
		};
		xecho $acban attempting to jupe $nic /staynick to cancel;
	};
};

alias getnick {
	^userhost $nic -cmd {
		if ("$3@$4" == '<UNKNOWN>@<UNKNOWN>') {
			^nick $nic;
		xecho $acban congrads nick juped. /staynick to cancel;
		};
	};
};

alias staynick {
	^assign -nic;
	@keepnick=1;
	^timer -delete 45;
	xecho $acban /orignick request canceled.;
};

## config output
alias config.origdelay {
	if ( *0 == '-r' ) {
		return $_ort;
	} else if (*0 == '-s') {
		if ("$1" > 0 && "$1" <=10) {
			@_ort="$1";
		} else if (# > 1) {
			xecho -v $acban time out of range. Valid numbers are 1-10;
		};
		xecho -v $acban orignick delay set to "$_ort";
	};
};

## orignick hooks.
on #-channel_signoff 42 "*" {
	if (keepnick == 1 && '$1' == nic) {
		^nick $nic;
		xecho $acban congrads nick juped. /staynick to cancel;
	};
};

^on #-nickname 33 "*" {
	if (keepnick == 1 && '$0'== nic) {
		^nick $nic;
		xecho $acban congrads nick juped. /staynick to cancel;
	};
};

## misc needed functionality for server handling
alias getuhost {
	if (userhost($0)=='<UNKNOWN>@<UNKNOWN>') {
		wait for userhost $0 -cmd {
			if (*4 != '<UNKNOWN>')
				return $3@$4;
			return;
		};
	}{
		return $userhost($0);
	};
};

alias bye {
	if (@) {
		//quit $(J)[$info(i)] - $(a.ver) : $*;
	}{
		//quit $(J)[$info(i)] - $(a.ver) : $randread($(loadpath)reasons/quit.reasons);
	};
};

alias ping (target default "$T") {
	//ping $target;
};

alias rn {
	@_rn='a b c d e f g h i j k l m n o p q r s t u v w x y z 1 2 3 4 5';
        fe ($_rn) n1 {
                @setitem(_rn $numitems(_rn) $n1);
        };
	^nick $(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))));
};

alias ver (target default "$T"){
	if (@target)
		//ctcp $target version;
};
## end generic serveraliases

## from psykotyk's orb
## This code does not support multiple servers
alias _relag {
	@ _rlt = time();
	//quote ping $S;
};

^on ^pong * {
	if (*1 == S) {
		if (time()-_rlt > 400) {
			^set status_user1 ??;
		}{ 
			^set status_user1 ${time()-_rlt};
		};
	};
	^assign -_rlt;
	timer -window -1 -refnum 43 15 _relag;
};
_relag;
## end psykotyk's orb.

alias sping (svar default "$S", void) {
	@pstart = time();
	//quote ping $svar :$svar;
	@_pong($svar);
};

alias _pong (svar) {
	^on #-pong 10 "$svar *" {
		xecho -b your lag to $0 is: ${time() - pstart} second(s);
		^on #-pong 10 -"$0 *";
	};
};

## getusers handling
## Last modified by rylan 10.3.06 - RIP buddy
## more cleanup is surely needed. (see obfuscate below)
## see core/fsets.m - lines 109-125 (more preferred as it works) //crapple

alias getusers (chan default "$serverchan()",void) {
	if (!ischannel($chan)) {
		^set status_user2 n/a;
		^set status_user3 n/a;
		^set status_user4 n/a;
		^set status_user7 n/a;
	}{
		^set status_user2 $#chops();
		^set status_user3 $#nochops();
		^set status_user4 $#pattern(*+* $channel());
		^set status_user7 $#pattern(* $channel());
	};
};

## stupid obfuscated hooks (it might break something if removed)
## ^^ will probably make people who look at this comment feel good
## about our scripting pratices.. (i would be pleasantly surprised
## if someone actually notices)

on ^switch_channels * {^getusers;};
on #-switch_windows 43 * {
	xeval -s $winserv($3) ^getusers;
};
on #-channel_sync 23 * {^getusers;};

## grep -aR 353 *
## core/getusers.m:^on #-353 2 * {^getusers}
## core/scan.m:on #^353 1 * {@nicks#=[$3-]}
on #-353 2 * {^getusers;};
## end getusers

## /lusers stuff
## last modified by rylan on 2006 Oct 03 - RIP buddy
## Ok, so how we're doing this is completely broken. I'm going to just redo it
## so it's not all broken. -skullY

# /lusers server server is completely retarded. Fix it.
alias lusers {
	if (@) {
		//lusers $0 $0;
	}{
		//lusers;
	};
};

# Fucking loose-ass ircii protocol can bite me.
alias _getnum {
	@_number = *0;
	fe ($1-) _word {
		if (isnumber($_word)) {
			if (_number < 1) {
				@function_return = _word;
				break;
			}{
				@_number--;
			};
		};
	};
};

on ^251 * {
	@lusers.gvisible = *3;
	@lusers.ginvisible = *6;
	@lusers.servernum = *9;
};

on ^252 * {
	@lusers.gopers = *1;
};

on ^253 * {
	@lusers.unknown = *1;
};

on ^254 * {
	@lusers.channels = *1;
};

on ^255 * {
	@lusers.lusers = *3;
	@lusers.lservers = *6;
};

on ^265 * {
	@lusers.lusers = _getnum(0 $strip(, $1-));
	@lusers.lusersmax = _getnum(1 $strip(, $1-));
};

on ^266 * {
	@lusers.gusers = _getnum(0 $strip(, $1-));
	@lusers.gusersmax = _getnum(1 $strip(, $1-));
};

on ^250 * {
	@lusers.lconnectionmax = *4;
	@lusers.lconnectionstotal = strip(\( $7);
	xecho -b Statistics for $0:;
	if (lusers.unknown) {
		xecho -b Unknown:       $lusers.unknown unknown connection(s);
	};
	xecho -b Global Users:  ${lusers.gusers}, $lusers.gusersmax max \($lusers.ginvisible invisible, $lusers.gopers opers\);
	xecho -b Local Users:   ${lusers.lusers}, $lusers.lusersmax max \($trunc(5 ${100 * (lusers.lusers / lusers.gusers)})%\);
	xecho -b Servers:       ${lusers.servernum} \(${lusers.gusers / lusers.servernum} avg users per server\);
	xecho -b Channels:      ${lusers.channels} \(${lusers.gusers / lusers.channels} avg users per channel\);
	xecho -b Connect Count: $lusers.lconnectionmax max \($lusers.lusersmax clients\) \($lusers.lconnectionstotal received\);
	^assign -lusers;
};

## end /lusers

## basic server notice hooks (snotices)
^on ^server_notice "% % % connect to*" {
	abecho $fparse(format_timestamp_some $($_timess))$2-;
};

^on ^server_notice "% % Processing connection*" {
	abecho $fparse(format_timestamp_some $($_timess))$2-;
};

^on ^server_notice "% % Looking up your hostname*" {
	abecho $fparse(format_timestamp_some $($_timess))$2-;
};
 
^on ^server_notice "% % Checking Ident*" {
	abecho $fparse(format_timestamp_some $($_timess))$2-;
};
 
^on ^server_notice "% % Found your hostname*" {
	abecho $fparse(format_timestamp_some $($_timess))$2-;
};
 
^on ^server_notice "% % Got ident response*" {
	abecho $fparse(format_timestamp_some $($_timess))$2-;
};
  
^on ^server_notice "% % No Ident response*" {
	abecho $fparse(format_timestamp_some $($_timess))$2-;
};

^on ^server_notice "% % Spoofing your*" {
	abecho $fparse(format_timestamp_some $($_timess))$2-;
};

^on ^server_notice "% % You are exempt*" {
	abecho $fparse(format_timestamp_some $($_timess))$2-;
};

^on ^server_notice "% % Your host is*" {
	abecho $2-;
};
## end server connect cosmetics

alias svhelp servhelp;
alias servhelp {
        if (!@) {    

//echo ---------------------= Server Usage Help =-------------------------;
//echo svlist    /svlist views currently available servers/info.;
//echo svadd      /svadd <server> add specified server to the server list;
//echo svhadd     /svhadd <server> <vhost> add specified serv w/specified vhost;
//echo svnick     /svnick <server> <nick> add specified serv/nick to the serv list;
//echo ssl       /ssl <server>[port] add specified server as type ssl to the server list;
//echo snext     /snext To switch to the next server in your list;
//echo sprev     /sprev To switch to the previous server in your list;
//echo wser      /wser /wser <server[:port[:password[:nick]]]> multiserver cmd;
//echo wser      /wser To create a new window with a specified server.;
//echo ---------------------------------------------------------------------;
        };
};
