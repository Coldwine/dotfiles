# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage color;

@translatetbl="clear.cl!blue.blu!green.grn!cyan.cyn!red.red!magenta.mag!yellow.yel!white.wht!hblack.hblk!hblue.hblu!hgreen.hgrn!hcyan.hcyn!hred.hred!hmagenta.hmag!hyello.hyel!hwhite.hwht!bwhite.bwht!bmagenta.bmag!bblue.bblu!bred.bred!bblack.bblk!bgreen.bgrn!byellow.byel!bcyan.bcyn";

alias colour {color $*;};
alias sbcolour {sbcolor $*;};

alias _colorusage {
	abwecho available colors $(cyn):;
	@:outp='';
	@:ctr=0;
	fe ( $split(! $translatetbl) ) curcol {
		if ( ctr > 8) {
			abwecho $outp;
			@:outp='';
			@:ctr=0;
		};
		@:ctr=ctr+1;
		@:name = word(0 $split(. $curcol));
		@:var = word(1 $split(. $curcol));
		@:outp = "$(outp)$($var)$name%n ";
	};
	abwecho $outp;
};

alias _getcolor {
	fe ( $split(! $translatetbl) ) curcol {
		@:name = word(0 $split(. $curcol));
		@:var = word(1 $split(. $curcol));
		if ( name == *0 ) {
			return $($var);
		};
	};
	echo Unknown color $0;
};

alias color {
	if (#>4) {
		@c1 = _getcolor($0);
		@c2 = _getcolor($1);
		@c3 = _getcolor($2);
		@c4 = _getcolor($3);
		@c5 = _getcolor($4);
		abwecho color config set to $(c1)color1 $(c2)color2 $(c3)color3 $(c4)color4 $(c5)color5;
		^getusers;
	}{
		abwecho $a.ver usage : /color color1 color2 color3 color4 color5;
		abwecho color config set to $(c1)color1 $(c2)color2 $(c3)color3 $(c4)color4 $(c5)color5;
		_colorusage;
	};
};

alias sbcolor {
	if (#>3) {
		@sc1 = _getcolor($0);
		@sc2 = _getcolor($1);
		@sc3 = _getcolor($2);
		@sc4 = _getcolor($3);
		abwecho color statbar config set to $(sc1)color1 $(sc2)color2 $(sc3)color3 $(sc4)color4;
		_updatesbar;
	} {
		abwecho $scriptname usage : /sbcolor color1 color2 color3 color4;
		abwecho color statbar config set to $(sc1)color1 $(sc2)color2 $(sc3)color3 $(sc4)color4;
		_colorusage;
	};
};
