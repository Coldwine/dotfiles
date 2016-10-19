# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage urlgrab;

@httpsavefile=word(0 $_modsinfo.urlgrab.savefiles);

alias url urlgrab;
alias urlgrab {
        more ${savepath}$httpsavefile;
};

alias rmurl rmgrab;
alias rmgrab {
	if (fexist(${savepath}$httpsavefile) == -1) {
		xecho $acban url log file does not exist.;
	}{
		input "remove url log? [y|n]: " {
			if ([$0]==[y]) {
				exec rm ${savepath}$httpsavefile;
					xecho $acban ${savepath}$httpsavefile deleted;
			}{
				xecho $acban remlog canceled;
			};
		};
	};
};

alias urlload {
	^on #-public 33 "% % *http://*" {
		@fd = open(${savepath}$httpsavefile W);
		@write($fd $strftime(%x at %I:%M:%S %p) $*);
		@close($fd);
	};
};
alias urlunload {
	^on #-public 33 "% % *http://*" -;
};

alias urlhelp {
//echo ------------------------= Urlgrab Help =------------------;

//echo urlgrab  /urlgrab will view urls catched if any;
//echo uurl     /url will view urls catched if any;
//echo rmgrab   /rmgrab will delete url log;
//echo rmurl    /rmurl will remove url log;
//echo ------------------------------------------------------------;
};
