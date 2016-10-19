# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage ncomp;

^on ^input "%: *" {
	@:txt = before(: $0);
	if (pattern($txt* $chanusers($serverchan()))) {
		@ per = pattern($txt* $chanusers($serverchan()));
 		if (numwords($per) > 1) {
			xecho $acban Ambiguous matches: $per;
			//sendline $*;
		}{
			//sendline $stripansicodes($per$format_nick_comp $1-);
		};
		return;
	};
	if (!pattern($txt* $chanusers($serverchan())) && pattern(*$txt* $chanusers($serverchan()))) { 
		@ per = pattern(*$txt* $chanusers($serverchan()));
		if (numwords($per) > 1) {
			xecho $acban Ambiguous matches: $per;
			//sendline $*;
		}{
			//sendline $stripansicodes($per$format_nick_comp $1-);
		};
		return;
	};
	//sendline $*;
};

alias ncompunload (void) {
	^on input -"%: *";
};
