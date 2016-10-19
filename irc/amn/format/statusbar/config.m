# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage sbar;
alias format.loadstatusbar (number,void) {
	if (fexist($(loadpath)format/statusbar/stat.$number) != -1 ) {
		@theme.format.statusbar=number;
		_updatesbar;
		return 1;
	};
	return 0;
};

alias sbar (statnum,void) {
	if (format.loaditem(statusbar $statnum)) {
		xecho $acban $scriptname sbar set to $statnum;
       		xecho $acban type /fsave to save status bar;
	}{ 
		^local i;
		for (@i=1 , fexist($(loadpath)format/statusbar/stat.$i) != -1 , @i++) {};
		xecho $acban Usage: /sbar <1-${i-1}> current sbar is ${hwht}$theme.format.statusbar;
	};
};

alias _updatesbar (void) {
	load $(loadpath)format/statusbar/stat.$theme.format.statusbar;
	fe ($windowctl(refnums)) tt {
		^window $tt double $windowdoubles;
	};
};
