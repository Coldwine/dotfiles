# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage dcc;

## binds.
@ bindctl(sequence ^[t set parse_command {dcc chat $pop(dccchats)};);
@ bindctl(sequence ^[r set parse_command {dcc close chat $pop(dccchats)};);
@ bindctl(sequence ^T set parse_command _dcc.get);
@ bindctl(sequence ^R set parse_command _dcc.reject);

## aliases.
alias dcg {dcc close get $*;};
alias dcs {dcc close send $*;};
alias dcx {dcc close chat $*;};
alias dca dcc closeall;
alias dcn {dcc close * $0;};
alias dcr {dcc rename -chat $*;};
alias nochat {dcx $*;};
alias chat {dcc chat $*;};
alias send {dcc send $*;};
alias get {dcc get $*;};
alias uldir {cd $*;};
alias bchat {ctcp $* chat;};

## dcc bind hook
on -dcc_request "% CHAT *" {
	push dccchats $0;
	xecho -b DCC $0 has sent a dcc chat request.;
	xecho -b DCC Press alt-T to respond or alt-R to reject from $0.;
};

on #-dcc_request 22 "% SEND*"  {
	@dccnick = *0;
	xecho -b press ctrl-T to accept file or ctrl-R to reject;
};
## end dcc bind

## dcc auto-get toggle
on #-dcc_request 23 "% SEND*"  {
	@dccnick = *0;
	@dccfile = *5;
	if (autoget == 'on') {
		^dcc get $dccnick;
		xecho -b autogetting dcc $dccfile from $dccnick;
	};
};

alias _dcc.get {
	dcc get $dccnick;
};
 
alias _dcc.reject {
	dcc close get $dccnick;
};

## config
alias config.dccag {
	if ( *0 == '-r' ) {
		return $autoget;
	} else if (*0 == '-s') {
		config.matchinput on|off autoget '$1' dcc autoget;
	};
};

alias autoget {dccag $*;};
alias dccag {
	config.dccag -s $*;
};

osetitem misc dccag Dcc autoget:;
## end dcc_auto_get

## dcc_ports (allows you to set which port range to use for dcc)
## taken from epic/scripts written by hop, merged to amnesiac by zak

alias dcc_ports.regen {
   @dcc_ports.picklist = jot($dcc_port_min $dcc_port_max)
};

alias dcc_ports.nextport {
   if (#dcc_ports.picklist == 0) {
      dcc_ports.regen
   };
   @function_return = shift(dcc_ports.picklist);
};

@dccctl(DEFAULT_PORT $$dcc_ports.nextport());
## end dcc portrange
## dcc menu help.
alias dcchelp {
        if (!@) {
                   
//echo ---------------------= Dcc Help =------------------------------;
//echo chat   /chat <nick> [-p portnum] will send or accept a dcc chat;
//echo to specified nick -p port is optional.;
//echo nochat /nochat <nick> will close/deny a dcc chat session to;
//echo specified nick.;
//echo send   /send <nick> <somefile> will send specified nick specified;
//echo filename.;
//echo get    /get <nick> will grab file from specified nick.;
//echo dcc    /dcc will list current dcc sessions if any.;
//echo dca    /dca will kill all dcc sessions.;
//echo dcs    /dcs <nick> will close file transfer to specified nick.;
//echo dcs    /dcg <nick> will close file transfer from specified nick.;
//echo dcx    /dcx <nick> will close chat session to specified nick.;
//echo dcn    /dcn <nick> will close any dcc sessions to specified nick.;
//echo dcr    /dcr <oldnick> <newnick> will change dcc chat nick;
//echo ---------------------= dcc keybinds =----------------------------;
//echo alt-r  : will reject dcc chat request.;
//echo alt-t  : will accept dcc chat request.;
//echo ctrl-t : will accept dcc file/send request.;
//echo ctrl-r : will reject dcc file/send request.;
//echo ------------------------------------------------------------------;
        };
};
