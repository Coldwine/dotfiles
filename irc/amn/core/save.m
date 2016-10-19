# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage save;

## save funcs
alias asave {
	@rename($(savepath)$savefile $(savepath)$savefile~);
        @savemt = open($(savepath)$savefile W T);
        @write($savemt ** amnesiac config file - saved $strftime($time() %D %T));
	@write($savemt notify $notify());
	@:vars = 'fke1 fke2 fke3 fke4 fke5 fke6 fke7 fke8 fke9 fke10 fke11 fke12 plog crapl msgl notl dccl awayt awayr showop kickops getumode togaway autoget windowdoubles clonecheck bt_ _bt et_ _et _ss _ort _pubnick _tss _ovsize _ovmode acban rfrombuf rsendbuf';
	fe ($vars ) cvar {
		@write($savemt assign $cvar $($cvar));
	};
	@close($savemt);
	xecho $acban Amnesiac settings saved to $(savepath)$savefile;
};

alias setsave {
	@rename($(savepath)$setsavefile $(savepath)$setsavefile~);
        @savemt = open($(savepath)$setsavefile W T);
        @write($savemt ** amnesiac settings file - saved $strftime($time() %D %T));
	fe ($symbolctl(pmatch builtin_variable *)) cur {
		@write($savemt set $cur $getset($cur));
	}
	@close($savemt);
	xecho $acban Epic settings saved to $(savepath)$setsavefile;
};

alias fsetsave {  
	@rename($(savepath)$fsetsavefile $(savepath)$fsetsavefile~);
        @fsetsavemt = open($(savepath)$fsetsavefile W T);
        @write($fsetsavemt ** amnesiac format file - saved $strftime($time() %D %T));
#fwords is edited in fsets.m
	fe ($fwords) a1 {
		@write($fsetsavemt ^sfset format_$a1 $(format_$a1));
	};
	@close($fsetsavemt);
	xecho $acban Fset settings saved to $(savepath)$fsetsavefile;
};

alias fsave {
	@rename($(savepath)$fsavefile $(savepath)$fsavefile~);
        @savemt = open($(savepath)$fsavefile W T);
        @write($savemt ** amnesiac format file - saved $strftime($time() %D %T));
	@write($savemt assign scdesc $scdesc);
	
	fe ($format_strings ) cvar {
		@write($savemt assign theme.format.$cvar $(theme.format.$cvar));
	};
	@close($savemt);
	xecho $acban Format settings saved to $(savepath)$fsavefile;
};

alias csave {
	@:vars = 'c1 c2 c3 c4 c5 sc1 sc2 sc3 sc4';
	@rename($(savepath)$csavefile $(savepath)$csavefile~);
        @savemt = open($(savepath)$csavefile W T);
        @write($savemt ** amnesiac color format file - saved $strftime($time() %D %T));
	fe ($vars ) cvar {
		@write($savemt assign $cvar $($cvar));
	};
	@close($savemt);
	xecho $acban Color settings saved to $(savepath)$csavefile;
};

alias igsave {
	@rename($(savepath)$igsfile $(savepath)$igsfile~);
	@saveig = open($(savepath)$igsfile W T);
	fe ($igmask(*)) _igmasks {
		@ write($saveig ^ignore $_igmasks $igtype($_igmasks));
	};
	@close($saveig);
	xecho $acban Ignores saved to $(savepath)$igsfile;
};

alias save saveall;
alias saveall {
#core saves
	@_savevar='asave csave fsave fsetsave modsave igsave setsave';
	fe ($_savevar) n1 {
		if (match($n1 $aliasctl(alias match *))) {
			$n1;
		} {xecho Warning: Core alias $n1 not found. Important changes might not be saved;};
	};
#saves from loaded modules
	fe ($listarray(_mods)) n1 {
                if (_modsinfo[$n1][savecmd]) {
			$_modsinfo[$n1][savecmd];
		};
	};
};
