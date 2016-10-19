# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};
subpackage help;

## Help strings below.
@ahelp.rn='%Wu%nsage%K:%n /rn will change nick to a random nick of 7 chars';
@ahelp.winhelp='%Wu%nsage%K:%n /winhelp will display help menu for windowing shortcuts.';
@ahelp.unban='%Wu%nsage%K:%n /unban <nick|host> will unban nick or host from current channel';
@ahelp.tig='%Wu%nsage%K:%n /tig will display all current ignores and prompt to delete one.';
@ahelp.theme='%Wu%nsage%K:%n /theme will display all amnesiac themes and you can choose which one you want.';
@ahelp.supt='%Wu%nsage%K:%n /supt will paste client version and uptime to current channel';
@ahelp.staynick='%Wu%nsage%K:%n /staynick will cancel /orignick.';
@ahelp.bkt='%Wu%nsage%K:%n bkt <nick> <reason> - will bankick specified nick then unban them after 5 seconds.';
@ahelp.dldir='%Wu%nsage%K:%n /dldir </path/to/dir> sets download path.';
@ahelp.partall='%Wu%nsage%K:%n /partall will part all current channels.';
@ahelp.not='%Wu%nsage%K:%n /not will unset topic on current channel.';
@ahelp.chops='%Wu%nsage%K:%n /chops will display all ops on current channel.';
@ahelp.nops='%Wu%nsage%K:%n /nops will display all nonops on current channel.';
@ahelp.vocs='%Wu%nsage%K:%n /vocs will display all voiced members on current channel.';
@ahelp.mw='%Wu%nsage%K:%n /mw -hidden|split|kill [num] <will create/kill a window bound to msgs>';
@ahelp.mv='%Wu%nsage%K:%n /mv will mass voice everyone on current channel';
@ahelp.more='%Wu%nsage%K:%n /more <textfile> will display text file to screen.';
@ahelp.lk='%Wu%nsage%K:%n /lk will kick all non oped and voiced lusers from current channel';
@ahelp.links='%Wu%nsage%K:%n /links will give you a server list of all the servers linked to current network';
@ahelp.kickban='%Wu%nsage%K:%n /kickban <nick1>,<nick2> will kick and ban nick(s) from current channel';
@ahelp.kb='%Wu%nsage%K:%n /kb <nick1>,<nick2> will kick and ban nick(s) from current channel.';
@ahelp.invkick='%Wu%nsage%K:%n /invkick <nick> <reason> will set mode +i and kick nick from current channel. Removes +i after 10 secs.';
@ahelp.ik='%Wu%nsage%K:%n /ik <nick> <reason> will set mode +i and kick nick from current channel. Removes +i after 10 secs.';
@ahelp.inv='%Wu%nsage%K:%n /inv <nick> will invite nick to current channel.';
@ahelp.iban='%Wu%nsage%K:%n /iban <nick> will ban nick by ident from current channel';
@ahelp.devoice='%Wu%nsage%K:%n /devoice <nick1 nick2 nick3> devoices nicks from current channel.';
@ahelp.cops='%Wu%nsage%K:%n /cops to list irc operators on current channel.';
@ahelp.cig='%Wu%nsage%K:%n /cig <channel> to ignore public from current or specified channel';
@ahelp.bankick='%Wu%nsage%K:%n /bankick <nick> [nick1,nick2] will ban and kick nick(s) from current channel.';
@ahelp.q='%Wu%nsage%K:%n /q nick querys nick';
@ahelp.bans='%Wu%nsage%K:%n /bans shows current banlist on channel';
@ahelp.wii='%Wu%nsage%K:%n /wii <nick> server side whois for specified nick';
@ahelp.mdeop='%Wu%nsage%K:%n /mdeop <nick1>,<nick2>,<nick3> <...> mass deops current channel minus nicks specified.';
@ahelp.dv='%Wu%nsage%K:%n /dv <nick> devoices nick';
@ahelp.v='%Wu%nsage%K:%n /v <nick> voices nick';
@ahelp.scano='%Wu%nsage%K:%n /scano scans for current ops on channel';
@ahelp.scanv='%Wu%nsage%K:%n /scanv scans for current voiced on channel';
@ahelp.scann='%Wu%nsage%K:%n /scann scans for current non op/voiced on channel';
@ahelp.t='%Wu%nsage%K:%n /t sets topic for current channel';
@ahelp.k='%Wu%nsage%K:%n /k <nick1>,<nick2> <reason> kicks nick(s) with reason';
@ahelp.umode='%Wu%nsage%K:%n /umode <mode> changes user mode ';
@ahelp.m='%Wu%nsage%K:%n /m nick <msg> msgs nick with msg';
@ahelp.j='%Wu%nsage%K:%n /j channel joins channel';
@ahelp.l='%Wu%nsage%K:%n /l leaves current channel';
@ahelp.wi='%Wu%nsage%K:%n /wi <nick> whois nick';
@ahelp.ver='%Wu%nsage%K:%n /ver nick ctcp versions nick';
@ahelp.c='%Wu%nsage%K:%n /c <mode> changes mode on current channel ';
@ahelp.nochat='%Wu%nsage%K:%n /nochat <nick> dcc closes chat with nick';
@ahelp.chat='%Wu%nsage%K:%n /chat <nick> sends dcc chat request to nick';
@ahelp.bk='%Wu%nsage%K:%n /bk <nick1>,<nick2> <reason> bankicks nick(s) for reason';
@ahelp.op='%Wu%nsage%K:%n /op <nick> ops nick on current channel';
@ahelp.voice='%Wu%nsage%K:%n /voice <nick> voices nick on current channel';
@ahelp.deop='%Wu%nsage%K:%n /deop <nick> deops nick on current channel';
@ahelp.mop='%Wu%nsage%K:%n /mop <nick1> <nick2> <nick3> <...> mass ops current channel, skipping specified nicks';
@ahelp.cycle='%Wu%nsage%K:%n /cycle leaves then joins current channel';
@ahelp.mreop='%Wu%nsage%K:%n /mreop mass ops current ops on channel';
@ahelp.readlog='%Wu%nsage%K:%n /readlog reads away log';
@ahelp.wall='%Wu%nsage%K:%n /wall <msg> mass notices current ops on channel';
@ahelp.sv='%Wu%nsage%K:%n /sv shows current client/script version to channel';
@ahelp.away='%Wu%nsage%K:%n /away set yourself away';
@ahelp.back='%Wu%nsage%K:%n /back turns away off.';
@ahelp.format='%Wu%nsage%K:%n /format <letter> <number> changes format letter to #';
@ahelp.config='%Wu%nsage%K:%n /config <letter> <setting> changes config letter to #';
@ahelp.color='%Wu%nsage%K:%n /color <color1> <color2> <color3> <color4> changes color to desired colors';
@ahelp.sbcolor='%Wu%nsage%K:%n /sbcolor <color1> <color2> <color3> <color4>  changes sbar color to desired colors';
@ahelp.v='%Wu%nsage%K:%n /v <nick> voices nick';
@ahelp.saveall = '%Wu%nsage%K:%n /saveall saves all settings';
@ahelp.fsave = '%Wu%nsage%K:%n /fsave saves all format settings';
@ahelp.sbar = '%Wu%nsage%K:%n /sbar <number> changes sbar to desired number';
@ahelp.scan = '%Wu%nsage%K:%n /scan scans current channel for nicks';
@ahelp.wk = '%Wu%nsage%K:%n /wk kills current window';
@ahelp.wlk = '%Wu%nsage%K:%n /wlk leaves channel and kills window';
@ahelp.wn = '%Wu%nsage%K:%n /wn changes to next window';
@ahelp.wp = '%Wu%nsage%K:%n /wp changes to previous window';
@ahelp.wj = '%Wu%nsage%K:%n /wj <channel> opens up new window and joins channel specified';
@ahelp.wc = '%Wu%nsage%K:%n /wc creates new window';
@ahelp.frelm = '%Wu%nsage%K:%n /frelm <fakenick> <channel> <text to fake> fakes recvied msg and pastes it to channel';
@ahelp.freln = '%Wu%nsage%K:%n /freln <fakenick> <channel> <text to fake> fakes recvied notice and pastes it to channel';
@ahelp.csave = '%Wu%nsage%K:%n /csave saves color settings';
@ahelp.format = '%Wu%nsage%K:%n  /format <choice> <num> changes format number to selected format';
@ahelp.sping = '%Wu%nsage%K:%n  /sping <server> pings server and returns lag time to it';
@ahelp.stalker = '%Wu%nsage%K:%n  /stalker does a /common for every channel you are in against the current channel';
@ahelp.ub = '%Wu%nsage%K:%n  /ub <nick> ub by itself will clear all bans on current channel , /ub nick will unban nick from current channel';
@ahelp.dns = '%Wu%nsage%K:%n /dns <nick> domain nameserver request to given nick';
@ahelp.nslookup = '%Wu%nsage%K:%n /nslookup <ip> domain nameserver request to given ip';
@ahelp.orignick = '%Wu%nsage%K:%n /orignick will check the specified nick for the amount of seconds you specify in the config. (default is 3) and change to it when that nick signs off';
@ahelp.fkeys = '%Wu%nsage%K:%n /fkeys shows which fkeys are bound to which and can be changed by /fkey1 <command> /fkey2 <command>... ';
@ahelp.mkn = '%Wu%nsage%K:%n /mkn text will kick all non oped from channel';
@ahelp.mko = '%Wu%nsage%K:%n /mko text will kick all ops from channel';
@ahelp.massk = '%Wu%nsage%K:%n /massk <version string> will kick all users from the channel with specified version string';
@ahelp.bkh = '%Wu%nsage%K%n /bkh nick will ban nick with bantype host from current channel';
@ahelp.bkn = '%Wu%nsage%K%n /bkn nick will ban nick with bantype normal from current channel';
@ahelp.bkb = '%Wu%nsage%K%n /bkb nick will ban nick with bantype better from current channel';
@ahelp.bkd = '%Wu%nsage%K%n /bkd nick will ban nick with bantype domain from current channel';
@ahelp.ban = '%Wu%nsage%K:%n /ban nick will ban nicks userhost from current channel';
@ahelp.fkey = '%Wu%nsage%K:%n /fkey <#1-12> will set function keys to specified command';
@ahelp.fset = '%Wu%nsage%K:%n /fset format_choice will change specified format';
@ahelp.bantype = '%Wu%nsage%K:%n /bantype Usage: /bantype <Normal|Better|Host|Domain|> - When a ban is done on a nick, it uses <bantype>';
@ahelp.banstat = '%Wu%nsage%K:%n /banstat Usage: /banstat will show current bans on channel, who set them and what time they were set';

@hwords ="";
foreach ahelp xx {
	push hwords $tolower($xx);
};
@hwords= sort($hwords);
alias ahelp {
	if (!@) {
xecho -v -- ---------------------------------------------------------------------;
	@:_ohcenter=word(0 $geom()) / 2 + 40;
	aecho  | $center($_ohcenter a m n e s i a c   h e l p) $[14]{" "}|;
	@:_ohwidth=word(0 $geom()) / 14;
	@:_htopics ='';
	@:_htopics2 ='';
	fe ($jot(1 $_ohwidth)) n1 {
		push _htopics n$n1;
		push _htopics2 %K[%n$$[10]\{n$n1\}%K];
	};
	push _htopics2 %w|;
	fe ($hwords) $_htopics {
		xecho -v  | $cparse(${**_htopics2});
	};
xecho -v -- ---------------------------------------------------------------------;
	abecho $a.ver usage -> /ahelp <helpword>;
	}{

	if (@) {
	xecho -v -- ---------------------------------------------------------------------;
		if (!match($0 $hwords)) {
			xecho $acban command: $0 not found;
		}{
			//echo $cparse("$(ahelp.$*)");
		};
xecho -v -- ------------------------------------------------------------------;
	};
};
};

## enhanced amnesiac help
alias ehelp {
//echo	-------------------------= Extended Help =----------------------------;

	//echo uhelp     <userlist help>   userlist help menu.             [module];
	//echo awayhelp  <away help>       away module help menu.          [module];
	//echo urlhelp   <urlgrab help>    urlgrab help menu.              [module];
	//echo mmhelp    <multi-matrix help> bwk/ptrap/misc help menu.     [module];
	//echo mjhelp    <mjoin help>      mjoin/ajoin help menu.          [module];
	//echo abhelp    <abot help>       autobot help menu.              [module];
	//echo ohelp     <oper help>       operview/oper help menu         [module];
	//echo rhelp     <relay help>      relay/paste help menu.          [module];
        //echo rsmtphelp <relaysmtp help>  relay msgs via email help.      [module];
	//echo svhelp    <services help>   nserv/cserv/etc.. help menu.    [module];
	//echo loghelp   <elog help >      enhanced irc logger             [module];
	//echo chelp     <config help>     config shortcut help menu.      [core];
input_char "menu paused hit the ANY key to continue";
pause;
	//echo cidhelp   <cid help>        cid/accept (umode +g) help.     [core];
	//echo fhelp     <look/feel help>  amnesiac look/feel help menu.   [core];
	//echo ghelp     <general help>    general client/user cmds help.  [core];
	//echo svhelp    <server help>     server/connection help cmds.    [core];
	//echo mhelp     <module help>     module help menu.               [core];
	//echo winhelp   <window help>     window shortcuts help menu.     [core];
	//echo dcchelp   <dcc help>        dcc usage/binds help menu.      [core];
	//echo exhelp    <exempt modes>    exempt modes cmds help menu.    [core];
	//echo thelp     <trickle help>    the irc swiss army knife menu.  [core];
	//echo bhelp     <bans help>       kick/ban/bantype help menu.     [core];
//echo	----------------------------------------------------------------------;
};

## General
alias ghelp genhelp;
alias genhelp {
//echo ---------------------= General Usage Help =-------------------------;
//echo ign     /ign [nick|nick!ident@host] [type] will ignore someone;
//echo type: can be 1 or more options of notice,msg,dcc,crap,public,all;
//echo tig     /tig # removes specified ignore.;
//echo cig     /cig <channel> to ignore public from current or specified channel.;
//echo umode   /umode <mode> changes user mode.;
//echo ircname /ircname <text> will change your realname on next connect.;
//echo arejoin /arejoin will toggle auto_rejoin on/off;
//echo aww     /aww will toggle auto_whowas on/off;
//echo topic   /topic <tab> will insert current topic for editing.;
//echo away    /away set yourself away.;
//echo back    /back set yourself back.;
//echo readlog /readlog reads away msgs. [requires away module];
//echo remlog  /remlog erase away msgs.  [requires away module];
input_char "menu paused hit the ANY key to continue ";
pause;
//echo orignick /orignick <nick> will attempt to regain(jupe) specified nick;
//echo every 3 seconds(default) unless you specify time in /config. [orignick module];
//echo staynick /staynick will cancel /orignick [orignick module];
//echo tld     /tld <country-code> will show you the country for that TLD;
//echo notify  /notify <nick> will add specified nick to notify list;
//echo /notify -<nick> will remove specified nick from notify list;
//echo /notify will view online/offline nicks if any.;
//echo ---------------------------------------------------------------------;
};

## Format
alias fhelp lfhelp;
alias lfhelp {
//echo --------------------= Amnesiac Look/Feel Help =---------------------------;
//echo config  /config will list currently available configuration options;
//echo           /config <letter> <setting> will change the specified option.;
//echo theme   /theme will display available themes and you can choose which;
//echo           one you want with /theme <name>;
//echo format  /format <letter/num> will display available format;
//echo           /format <letter/num> <num> will choose the specified format;
//echo sbcolor /sbcolor <color1> <color2> <color3> <color4> changes sbar colors;
//echo           to desired colors.;
//echo color   /color <color1> <color2> <color3> <color4> changes color to;
//echo           desired colors.;
//echo tsave   /tsave <theme> <description> will create a theme.;
input_char "menu paused hit the ANY key to continue ";
pause;
//echo fset    /fset format_choice will change specified format.;
//echo fkeys   /fkeys shows which fkeys are bound to which and can be changed by;
//echo           by /fkey 1 <command> /fkey 2 <command>;
//echo sbar    /sbar <number> changes sbar to desired number.;
//echo mw      /mw -hidden|split|kill [num] <will create/kill a window bound to msgs>;
//echo extpub  /extpub <on|off> <will turn on/off <@nick> and <+nick> in public.;
//echo indent  /indent will indent on newline as opposed to linewrap.;
//echo ----------------------------------------------------------------------------;
};

## Config
alias chelp {
//echo ---------------------= Amnesiac Config Shortcuts =-----------------------;
//echo cumode    /cumode <mode> will set default usermode on connect.;
//echo stamp     /stamp <on|off> <will enable/disable timestamps>;
//echo modeshow  /modeshow <on|off> <will turn on/off <@nick> and <+nick> in public.;
//echo extpub    /extpub same as /modeshow;
//echo resp      /resp <word> will highlight nick when specified word is said in;
//echo             public;
//echo kops      /kops <on|off> <will kick ops on ban>;
//echo ccheck    /ccheck <on|off> <enable/disable clone checking in channels>;
//echo otime     /otime <num> <set the orignick time in seconds>;
//echo awayt     /awayt <num> <set the auto-away time in minutes>;
//echo tform     /tform will display available timestamp formats and you can;
//echo		   choose which one you want with /tform <num>;
//echo autoget   /autoget will attempt to grab files sent to you automatically.;
input_char "menu paused hit the ANY key to continue ";
pause;
//echo bantype   /bantype <Normal|Better|Host|Domain|> when a ban is done on a nick;
//echo            it uses <bantype>;
//echo aconnect  /aconnect <on|off> auto-reconnect on timeouts;
//echo ardelay   /ardelay <num> delay in seconds before reconnecting;
//echo aretry    /aretry <num>  how many retry attempts before giving up;
//echo arjoin    /arjoin <on|off> auto-rejoin channels on connect;
//echo aww       /aww <toggle auto-whowas on/off>;
//echo clock24   /clock24 <toggle 24hr time on/off>;
//echo lls       /lls <num> will increase/decrease the value of lastlog;
//echo breset    /breset will reset keybindings to default value;
//echo ircname   /ircname <chars> will change your ircname/realname on;
//echo		   next connect, /save to save the settings perm.;
//echo tog       /tog will list various settings that chan be changed;
//echo            via /set value <int/char> depending on the value to adjust;
//echo btab      /btab <on|off> toggle tab /msg on blank line(somewhat like tc);
//echo -------------------------------------------------------------------------;
};

## Caller ID
alias cidhelp {
//echo ------------------------= CID Help =-----------------------;
//echo accept  /accept <nick> will accept msgs from specified nick;
//echo cid     /cid will show nicks accepted for msgs if any;
//echo clist   /clist will show nicks accepted for msgs if any;
//echo cdel    /cdel <nick> will remove specified nick;
//echo rmcid   /rmcid <nick> will remove specified nick;
//echo ------------------------------------------------------------;
};

## Bans
alias bhelp {
//echo ------------------------= Bans Help =-----------------------;
//echo bki   /bki <nick> will ban/kick/ignore specified nick;
//echo kbi   /kbi <nick> will kick/ban/ignore specified nick;
//echo bkt   /bkt <nick> [reason] temp ban nick. /ahelp qk;
//echo bk/kb /bk/kb <nick> [nick1,nick2] [reason] will bankick or kickban nick(s);
//echo unban /unban <nick|host> will unban nick or host from chan;
//echo ub    /ub will clear bans in current chan;
//echo sb    /sb will show bans set in current chan;
//echo bans  /bans will show bans set in current chan;
//echo lban  /lban will ban all hosts ip4/ip6 in current chan;
input_char "menu paused hit the ANY key to continue ";
pause;
//echo ban   /ban <nick|host> will ban nick/host in current chan;
//echo kick  /kick <nick> [nick1,nick2] will kick nick(s) from current chan;
//echo bkh   /bkh <nick> [reason] will bankick nick with bantype host;
//echo bkb   /bkb <nick> [reason] will bankick nick with bantype better;
//echo bkn   /bkn <nick> [reason] will bankick nick with bantype normal;
//echo bkd   /bkd <nick> [reason] will bankick nick with bantype domain;
//echo iban  /iban <nick> [reason] will bankick nick with bantype ident;
//echo bantype /bantype <Normal|Better|Host|Domain> set default bantype;
//echo bantype info: norm:(n!*u@h.d n!*u@d.h), better:(*!*u@*.d *!*u@d.*);
//echo                 host:(*!*@h.d *!*@d.h) domain:(*!*@*.d *!*@d.*);
//echo ------------------------------------------------------------;
};

## Window
alias winhelp {
//echo	--------------------= Windowing Help =-----------------------------;
	
		//echo wc  <window create>   creates new hidden window;
		//echo wj  <window join>     creates new hidden window and joins specified channel;
		//echo wk  <window kill>     kills current window;
		//echo wlk  <window leave kill> kills current window and parts channel;
		//echo wn  <window next>     window next switches to next hidden window;
		//echo wp  <window prev>     switches to previous hidden window;
		//echo mw  <msg window>  -hidden|split|kill [num] <will create/kill a window bound to msgs>;
		//echo wq  <window query>    /wq nick creates a query window with the nick;
		//echo wka  <window kill all_hidden> attempts to kill all hidden windows.;
		//echo wko  <window kill others> attempts to kill other windows on the screen if visible.;
		//echo wsl  <window swap last>  swaps to your last window.;
		input_char "menu paused hit the ANY key to continue ";
		pause;
		//echo wsa  <window swap act> swaps to your activity window(s) from statbar. ie: act(3,4);
		//echo wlc  <window list chan> list channels in current window;
		//echo wl  <window list>     lists windows in use;
		//echo wsg  <window grow>    grows current window ie: /wsg 7;
		//echo wss  <window shrink>  shrinks current window ie: /wss 7;
		//echo 1-60  <swap windows>  swap windows ie: /1 for window 1 /2 for window 2 etc..;
		//echo wlog  <window log>    toggles window logging;
		//echo wflush <window flush> window flush scrollback in current window;
	    	//echo wlevel  <window levels>  changes level of current window;
		//echo msgwin  <msg window>  wsl's then it wc's a window bound to msgs,notices;
		//echo BINDS: ESC: <num> ALT: <num> ^W<func> <-- like unix screen cmds;
		//echo Above info mentions alternative ways to swap windows;
//echo	---------------------------------------------------------------------------;
};
