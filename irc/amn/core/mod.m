# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage mod;

alias emod {
	//echo -----------------= Module Description =--------------------------;
	//echo [*] Default    [M] Non-default /mhelp for more info.;
	@cnt=0;
	fe ($sort($_modules)) aa {
		//echo $_realpad(13 [$(aa)])- $_realpad(41 $(_modsinfo.$(aa).description))$_isdefaultmod($aa);
		if (cnt== word(1 $geom())-6 ) {
			input_char "menu paused hit the ANY key to continue ";
			pause;
		};
		@cnt++;

	};
	//echo -----------------------------------------------------------------;
};

alias _isdefaultmod (name,void)
{
	if (!@name) {
		return;
	};
	if (findw($name $_defaultmods)>=0) {
		return [*];
	};
	return [M];
};
alias _realpad (chars, text) {
	return $leftpc(${chars-1} $(text)$pad(${chars} " "));
};
alias vmod {
	//echo --------------------= Available Modules =------------------------;
	fe ($sort($_modules)) aa bb cc {
		@:outp="";
		fe ($aa $bb $cc) cur {
			push outp $_realpad(14 [$(cur)])$_isdefaultmod($cur)    ;
		};
		//echo $outp;
	};
//echo;
//echo [*] Default [M] Non-default /mhelp for more info.;
	//echo -----------------------------------------------------------------;
};
alias cyclemod (cmod) {delmod $cmod;addmod $cmod;};
alias addmod (mods){
	if (!@mods) {
		xecho $acban Usage: /addmod module1,module2,etc..;
		xecho $acban valid modules are [$_modules];
	}{
		fe ($split(, $mods)) n1 {
			if (match($n1 $_modules) > 0 && finditem(_mods $n1) < 0) {
				if (_loadmod($n1)==1) {
					xecho $acban $n1 module loaded. Type /$_modsinfo[$n1][helpcmd] for detailed instructions.;
				}{
					xecho $acban $n1 module loaded.;
				};
			}{
				xecho $acban $n1 module not found or already loaded.;
			};
		};
	};
};

alias listmod {
	if (numitems(_mods) == 0) {
		xecho $acban no modules current on list;
	}{
		aecho ----------------------= Modules Loaded =------------------;
		for (@xx=0, xx<numitems(_mods), @xx=xx+2) {
			@ :mod1 = "\($xx\) $getitem(_mods $xx)";
			if ( xx+1 >= numitems(_mods) )
			{
				@:mod2 = '';
			}{
				@ :mod2 = "\(${xx+1}\) $getitem(_mods ${xx+1})";
			};
			//echo $[30]mod1 $mod2;
		};
		aecho -----------------------------------------------------------;
		xecho $acban /vmod to list valid modules /emod view module descriptions;
	};
};

alias delmod {
	if (!@){
		xecho $acban usage: /delmod num1,num2,etc.. or name1,name2,etc..;
	}{
		if ("$0"=='*') {
			fe ($listarray(_mods)) n1 {
#if the script has an unloadcmd, run it
				if (@_modsinfo[$n1][unloadcmd]) {
					$_modsinfo[$n1][unloadcmd];
				};
				^unload $n1;
			};
			@delarray(_mods);
			xecho $acban deleted all modules from list;
		}{
			fe ($split(, $0)) n1 {
				@:li=finditem(_mods $n1);
				if (li>=0) {
#if the script has an unloadcmd, run it
					if (@_modsinfo[$n1][unloadcmd]) {
						$_modsinfo[$n1][unloadcmd];
					};
					^unload $n1;
					@delitem(_mods $li);
					xecho $acban $n1 module unloaded;
				}{
					xecho $acban $n1 module not loaded;
				};

			};

		};
	};
};

alias modsave {
	@rename($(savepath)$modfile $(savepath)$modfile~);
	@savemt = open($(savepath)$modfile W);
	for (@xx=0, xx<numitems(_mods), @xx++) {
		@write($savemt @mods.$xx=[$getitem(_mods $xx)]);
	};
	@close($savemt);
	xecho $acban Modules saved to $(savepath)$modfile;
};

alias _loadmod {
	if (!@)
		return 0;
	@:cmod="$0";
	if (finditem(_mods $cmod)>=0)
		return 0;
	@ setitem(_mods $numitems(_mods) $cmod);
	@:bhelp = 0;
	if (fexist($(loadpath)modules/$(cmod)/config)==1) {
		load -pf $(loadpath)modules/$(cmod)/config;
		if (@_modsinfo[$cmod][helpcmd]) {
			@:bhelp=1;
		};
	};
	load $(loadpath)modules/$(cmod)/$(cmod).m;
	if ( _modsinfo[$cmod][savefiles]) {
#if the script has a loadcmd, use it
		if (_modsinfo[$cmod][loadcmd]) {
			$_modsinfo[$cmod][loadcmd];
		};
	};
	return $bhelp;
};

alias _modload {
	fe ($_modules) cmod {
		if (fexist($(loadpath)modules/$(cmod)/config)==1) {
			load -pf $(loadpath)modules/$(cmod)/config;
		};
	};
	if (fexist($(savepath)$modfile)==1) {
		@ delarray(_mods);
		load $(savepath)$modfile;
		foreach mods aa {
			@_loadmod($mods[$aa]);
			^assign -mods.$aa;
		};
		^assign -mods;
	}{
		fe ($_defaultmods) cm {
			@_loadmod($cm);
		};
	};

};

alias mhelp modhelp;
alias modhelp {
	if (!@) {
//echo ---------------------= Module Usage Help =---------------------------;
//echo listmod   /listmod will view currently loaded modules.;
//echo emod      /emod will view extended module description.;
//echo vmod      /vmod will view loadable modules.;
//echo addmod    /addmod module1,module2 etc.. will load specified modules.;
//echo modsave   /modsave will save all modules.;
//echo delmod    /delmod num1,num2,etc.. or name1,name2,etc.. will unload;
//echo           specified modules.;
//echo ---------------------------------------------------------------------;
	};
};
