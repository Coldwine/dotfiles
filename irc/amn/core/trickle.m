# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage trickle;

alias trickle {
	if ( # < 3 || ! (ischannel($0) || *0 == '*')) {
		xecho $acban usage: /trickle #channel|* nick|nick!ident@host [nick|nick!ident@host] ...  command;
		return;
	};

	@ :cmd = *[~];
	@ :nums = # - 2;
## Stores $1-$xx in the variable allusers
## Using the $n-m expando.
	@ :allusers = *[1-$nums];
	if (ischannel($0) ) {
		@:users = chanusers($0);
	} {
		@:users = '';
		fe ($mychannels()) curchan {
			push users $chanusers($curchan);
		};
		@users = uniq($users);
	};
	fe ($allusers) curmatch {
		@:tmp = split(! $curmatch);
		if ( #tmp == 2)	{
			@:preusers=pattern($word(0 $tmp) $users);
			@:uhosts=userhost($preusers);
			@:users = copattern( $word(1 $tmp) uhosts preusers);
		} else 	{
			@:users= pattern($curmatch $users);
		};
		fe ($users) curuser {
			$cmd $curuser;
		};
	};
};

## trickle example swiss army knife features.
alias tdeop {trickle $serverchan() $* deop;};
alias top {trickle $serverchan() $* op;};
alias tkick {trickle $serverchan() $* kick;};
alias tbk {trickle $serverchan() $* bk;};
alias tfuck {trickle $serverchan() $* fuck;};

alias thelp {
        if (!@) {

//echo -------------= Trickle IRC Swiss Army Knife Help =-------------;
//echo tdeop  /tdeop [ident@host] specified match will deop user(s) in;
//echo current chan.;
//echo tkick  /tkick [ident@host] specified match will kick user(s) in;
//echo current chan.;
//echo tbk    /tbk   [ident@host] specified match will bankick user(s);
//echo in current chan.;
//echo top    /top   [ident@host] specified match will op user(s) in;
//echo current chan.;
//echo common /common #somechan will compare nicks between current and;
//echo specified chan.;
input_char "menu paused, hit the ANY key to continue. ";
pause;
//echo;
//echo /trickle can do a wide variety of commands/matches these are just;
//echo some of the quick aliases which makes usage of /trickle.;
//echo some /trickle usage examples.;
//echo /trickle #somechan *!*@*aol.com kill;
//echo /trickle #somechan *!ident@* voice;
//echo /trickle * will run the command on all channels like:;
//echo /trickle * *!~*@* bk Real ident must be used.;
//echo ---------------------------------------------------------------------;
        };
};
