# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};


subpackage dict;

@ dict.serv = [dict.org];
@ dict.port = 2628;

alias dicthelp {
	//echo ----------------------= Dict Help =---------------------------;
	//echo $cparse("%Wu%nsage%K:%n /dict <word> looks up word in online dictionary");
	//echo ---------------------------------------------------------------;
};

alias dict {
	if (!@[$*]) {/dicthelp} {
		@dword=[$*];
                @ :fd = connect($dict.serv $dict.port);
		^on ^DCC_RAW "*" {};
		^on #^DCC_RAW 10 "% $dict.serv D *" {
			 ## remove the last ^M (dos style line ending) ##
			@:rawdata=sar(g/$chr(13)//$3-);
			switch ( $rawdata ) {
				(220*)
				(150*)
				(151*)
				(151*) {
					return;
				};
				(.) {
					xecho -c -- ------------------------------------------------------------------;
				};
				(?DEFINITION 0)
				(250*) {
					^dcc close raw $0;
				};
				(SPELLING 0) {
					xecho -c $acban $cparse($(hwht)$dword$(hblk):$(cl) No suggestions given.);
					^dcc close raw $0;
				};
				(552* no match*) {
					xecho -c $acban no match for $dword;
					^dcc close raw $0;
				};
				(*) {
					if ( strlen($rawdata) > 0) {
						xecho -c $rawdata;
					};
				};
			};
		};
		^on #^dcc_raw 11 "% $dict.serv e %" {
			xecho -c -- ------------------------------------------------------------------;

			msg =$0 DEFINE * $dword;
			msg =$0 QUIT;
                };
	};
};
