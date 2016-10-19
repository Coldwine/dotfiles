# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# nickserv/chanserv/operserv etc.. module.
# FIXME: convert to pf-loader

subpackage services

#both way aliases chanserv/nickserv.

alias ident {if ([$0]=~[*#*]) {
                ^quote chanserv identify $0-
        } {     ^quote nickserv identify $0- }}
alias access {if ([$0]=~[*#*]) {
                if ([$1]) {     ^quote chanserv access $0-
                } {             ^quote chanserv access $0 LIST }
        } {     if ([$0]) {     ^quote nickserv access $0-
                } {             ^quote nickserv access LIST }}}
alias getpass {if ([$0]=~[*#*]) {
                ^quote chanserv getpass $0-
        } {     ^quote nickserv getpass $0- }}
alias drop {if ([$0]=~[*#*]) {
                ^quote chanserv deop $0-
        } {     ^quote nickserv deop $0- }}
alias forbid {if ([$0]=~[*#*]) {
                ^quote chanserv forbid $0-
        } {     ^quote nickserv forbid $0- }}
alias akill {if ([$1]) {        ^quote operserv akill $0-
                } {             ^quote operserv akill $0 LIST }}

#operserv crap/misc/opers
alias ojupe {^quote operserv jupe $0-}

alias akrem {
        if ((index(! $0) == -1) || (![$0])) {
        abecho Usage: /akrem n!u@h
        return}
        ^quote OperServ autokill -$0}
alias os {
        if (!O) {
        abecho you are not an irc operator.
        return}
        quote OperServ $*}

#nickserver shit.
alias ghost {^quote nickserv ghost $0-}
alias recover {ns recover $0 $1}
alias release {ns release $0 $1}
alias identify {ns identify $0 $1}
alias ninfo {ns info $*}

#some info shit.
alias why {cs why $serverchan() $*}
alias cinfo {cs info $*}
alias count {cs count $*}

#channel shit.
alias cinvite {cs invite $0 $1}
alias cunban {cs unban $0 $1}
alias csop {cs op $serverchan() $*}
alias cmkick {cs mkick $serverchan() $*}
alias cdeop {cs deop $serverchan() $*}
alias cmdeop {cs mdeop $serverchan() $*}
alias omkick {cs mkick $0 $1}
alias omdeop {cs mdeop $0 $1}
alias odeop {cs deop $0 $1}
 
alias fop if (![$0]) {^quote chanserv op $serverchan() $servernick()} {^quote chanserv op $0 $servernick()}

#person must be in channel for most of these to work.
#else use the longer command line of anything starting with o IE: oaop 
#to add an aop o meaning obsolete/old way it used to be done.
alias slist {cs sop $serverchan() list}
alias alist {cs aop $serverchan() list}
alias addl {cs aop $serverchan() add $0}
alias adds {cs sop $serverchan() add $0}
alias dell {cs aop $serverchan() del $0}
alias dels {cs sop $serverchan() del $0}
alias oaop {cs aop $0 $1 $2-}
alias osop {cs sop $0 $1 $2-}
alias akick {cs akick $serverchan() add $0}
alias akdel {cs akick $serverchan() del $0}
alias oakick {if ([$1]) {        ^quote chanserv akick $0-
                } {             ^quote chanserv akick $0 LIST }}


alias svhelp {
aecho  ----------------------------= Services Help =------------------------------
	
	
		aecho  ms  <memoserv>  send a command to memoserv 
		aecho  ns  <nickserv>  send a command to nickserv
		aecho  cs  <chanserv>  send a command to chanserv
		aecho  ident <identify>  identify to nickserv/chanserv IE: /ident yourpass for nickserv
		aecho  access <access>  /access will show your access hosts /access add/del host/# to remove/add hosts
		aecho  getpass <get's password>  oper command to get pass of channel/nick
		aecho  forbid  <forbid chan>  oper command to block/close chan.
		aecho  akill  <autokill>  oper command to add autokills.
		aecho  ojupe  <operserv jupe>  oper command to jupe.	
		aecho  akrem  <rem autokill>  oper command to remove autokills. 
		aecho  os <operserv>  send a command to operserv must be an oper.
		aecho  allow <allow dcc>  allow nick, so nick can send you a file
		aecho  release <release nick>  to release a nick from enforcer.
		aecho  recover <recover nick> ???? 
		aecho  ghost <ghost nick>  kills a ghosted client
		input_char "menu paused, hit the ANY key to continue. "
		pause
		aecho  ninfo <nickname info>  information about a nickname  
		aecho  why <why nick>  shows why a nick has an op in a chan aop/sop/none etc.
		aecho  cinfo <channel info>  shows information about a chan.
		aecho  count <count channel>  counts aops/sops/users in a channel
		aecho  cinvite <chanserv invite>  requests chanserv to invite you into a chan
		aecho  cunban <chanserv unban> requests chanserv to unban you from a chan
		aecho  csop <channel op>  requests chanserv to op someone in current chan
		aecho  fop <channel op>  requests chanserv to op you in current chan
		aecho  cmkick <channel masskick>  requests chanserv to masskick current chan.
		aecho  cmdeop <channel massdeop>  requests chanserv to massdeop current chan.
		aecho  cdeop <channel deop>  requests chanserv to deop a nick in current chan
		aecho  slist <sop list>  lists sops in chan
		aecho  alist <aop list>  lists aops in chan
		aecho  addl <add aop>  add aop in chan
		aecho  adds <add sop>  add sop in chan.
		aecho  dell <del aop>  delete aop in chan.
		aecho  dels <del sop>  delete sop in chan.
		aecho  akick <autokick nick>  add autokick on nick in chan.
		aecho  akdel <removes autokick>  del autokick on a nick in chan.
		aecho  most of these commands are done via /command nick /command host /command chan
		aecho  check $(loadpath)modules/services/services.m for more information/commands

aecho  ------------------------------------------------------------------------
}
