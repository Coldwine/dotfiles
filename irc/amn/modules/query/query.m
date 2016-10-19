# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
/* 
 * Copyright (c) 2003 Brian Weiss <brian@epicsol.org>
 * All rights reserved.
 *
 */

if (word(2 $loadinfo()) != [pf]) {
        load -pf $word(1 $loadinfo());
        return;
};

subpackage query;

## assign
assign AUTO_QUERY 1;
assign AUTO_QUERY_WINDOW_ARGS hide;

## hooks
on #-msg -835 "*" { _autoquery $0 $userhost(); };
on #-send_msg -835 "*" { _autoquery $0 $userhost(); };

## funcs
alias _autoquery (nick, uhost, void) {
	if (!nick || uhost == '<UNKNOWN>@<UNKNOWN>') {
		return;
	};
	if (AUTO_QUERY && querywin($nick $lastserver()) == -1) {
		window new name $nick query $nick $AUTO_QUERY_WINDOW_ARGS;
		xecho -v $acban New query window created for $nick;
	};
};
