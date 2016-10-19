/*
 * ``TC'' - Tabscript Clone For EPIC
 * Copyright 1995 Jeremy Nelson
 * Copyright 1998 The EPIC Project
 * Originally written for Daveman's Toolbox
 * Please use and distribute this script like crazy!
 */

if (word(2 $loadinfo()) != [pf]) { load -pf $word(1 $loadinfo()); return; };

# (note from jfn)  The original allowed you to save up to 10 nicks to 
# by cycled through by pressing <tab> or <esc>.  I totaly rewrote the file
# and added the ability to set the number of nicks to save, and also made 
# it a full tabkey clone.  This file is a lot easier to figure out, too.
# 
# What it does:
#     save an arbitrary number of nicks in a list (settable by you)
#     cycle through the list by pressing <tab>
#     cycle backwards through the list by pressing <^R>
#     remove last <TAB>bed nick from the list (^X^X)
#
# Because this script uses a queue instead of a list and index counter, 
# you may find this script has a different set of idiosyncrasies then 
# the original tabscript.
#
subpackage tc;

bind ^I parse_command ^tc.get_nick;
bind ^R parse_command ^tc.get_nick_backward;

# FIXME: Find a good bind for this.
#bind ^X^X parse_command {
#	xecho -b Nickname $word($tc.position $tc.msglist) removed;
#	@ tc.msglist = notw($tc.position $tc.msglist);
#	@ tc.num_nicks = #tc.msglist;
#	@ tc.position--;
#	tc.get_nick;
#};

# maximum number of nicks you want to keep track of...
@ tc.max_nicks = 10;

#
# add a word to a list -- makes sure the list doesnt get longer then
# the number allowed in max_nicks.
#
alias tc.add_to_list {
	# This was suggested by David Luyer (david_luyver@pacfici.net.au)
	(tc.msglist = [$0 $leftw(${tc.max_nicks-1} $remw($0 $tc.msglist))]);
	(tc.num_nicks = #tc.msglist);
	(tc.position = 0);
};
alias tc.get_nick {
	parsekey erase_line;
	xtype -l /msg $word($tc.position $tc.msglist);
	((++tc.position >= tc.num_nicks) && (tc.position -= tc.num_nicks));
};
alias tc.get_nick_backward {
	parsekey erase_line;
	xtype -l /msg $word($tc.position $tc.msglist);
	((--tc.position < 0) && (tc.position += tc.num_nicks));
};

alias addnick for x in ($*) {tc.add_to_list $x; };
alias nicklist xecho -b Nickname list: $tc.msglist;

on #-msg -12782 "*" { tc.add_to_list $0; };
on #-send_msg -12782 "*" { tc.add_to_list $0; };

on #-dcc_chat -12782 "*" { tc.add_to_list =$0; };
on #-send_dcc_chat -12782 "*" { tc.add_to_list =$0; };
