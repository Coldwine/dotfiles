# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# hops little paste script so you can paste shit without worrying about
# commands....ctrl-p to toggle.. /set paste for some other shit.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

# Uncomment this if you want a key binding.
bind ^P parse_command { _pastetog; };

alias _pasteon {
	stack push bind ^I;
	^bind ^I self_insert;
	stack push bind ^P;
	^bind ^P parse_command { _pasteoff; };

	stack push on input;
	^on input -*;
	^on ^input * {
		if ( !@ && getset(paste_strip) == 'OFF') {
			//send  ;
		} {
			//send $*;
		}; 
	};

	xecho -s $acban PASTE mode ON. Ctrl-P to turn off, automatically ends in $paste_delay seconds.;
	timer -refnum PASTEOFF $getset(paste_delay) _pasteoff;
};


alias _pasteoff {
	^on input -*;
	stack pop on input;
	stack pop bind ^P;
	stack pop bind ^I;
	^timer -delete PASTEOFF;
	xecho -s $acban PASTE mode OFF;
};

alias _pastetog {
	if (@timerctl(GET PASTEOFF timeout)) {
		_pasteoff;
	} {
		_pasteon;
	};
};

#hop'y2k3
