# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
## codelogic's theme module, thanx to robohak for help w/ padding
## modified crapple/kreca 05&06

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage theme;

alias tsave (name,...) {
	@:oldvars='auth desc name c1 c2 c3 c4 c5 sc1 sc2 sc3 sc4 acban';

	if (!@) {
		xecho $acban $scriptname usage: /tsave <theme> <description>;
	}{
		if (fexist($(loadpath)themes/${name}.th)==1) {
			@ rename($(loadpath)themes/${name}.th $(loadpath)themes/${name}.th.old);
			^exec rm $(loadpath)themes/${name}.th.old 1> /dev/null 2> /dev/null;
		};
	        @saveth = open($(loadpath)themes/${name}.th W T);
		@desc = *;
		@:auth=N;
	        @ write($saveth :$auth);
	        @ write($saveth :$desc);
	        @ write($saveth :$name);
		@ write($saveth assign scdesc \\\($desc\\\));
		fe ($oldvars ) cvar {
			@write($saveth assign $cvar $($cvar));
		};
		fe ($format_strings ) cvar {
			@write($saveth assign theme.format.$cvar $(theme.format.$cvar));
		};
	        @ close($saveth);
		xecho $acban saved theme file [$(loadpath)themes/$(name).th] $desc;
	};
};

alias theme (name,void) {
	if (!@name) {
		//echo      file name           author              description;
		fe ($glob($(loadpath)themes\/*.th)) th {
			@ :thfile = open($th R T);
			@ :auth = after(: $read($thfile));
			@ :desc = after(: $read($thfile));
			@ :name = after(: $read($thfile));
			@ close($thfile);
			//echo      $[10]name          $[12]auth        $desc$repeat(${20-strlen($strip( $stripansicodes($desc)))}  );
		};
		xecho $acban current theme is $scdesc;
	}{
		if (fexist($(loadpath)themes/${name}.th)==-1) {
			xecho $acban theme ${name} does not exist;
		}{
			load $(loadpath)themes/${name}.th;
			@format.init();
			^getusers;
			xecho $acban loaded theme file [${name}.th] by $auth $desc;
		};
	};
};
