# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage format;
## Format helper functions (for scripters) 
alias _format.getop (noop dwords 1, nickchan) {
	@:nick=word(0 $split(: $nickchan));
	@:chan=word(1 $split(: $nickchan));
	if (showop == 'on') {
		if (ischanop($nick $chan)) {
			return @;
		} else if (ischanvoice($nick $chan)) {
			return +;
		} else {
			return $noop;
		};
	};
};

alias _format.npad (padding, nickchan, text) {
	@:nick=word(0 $split(: $nickchan));
	@:chan=word(1 $split(: $nickchan));
	return $_format.rchan($padding $nick $chan "" $text)
};
## internal format helper functions
alias _format.rchan (padding, nick , chan, prefix dwords 1, text) {
	@:output="";
	if (!iscurchan($chan)) {
		@output = "$(nick):$chan";
	} else {
		@output = nick;
	};
	@output = "$(prefix)$highlightpub($output $text)";
	return $_format.pad($padding $output);
};
alias _format.pad (padding, text) {
	if (padding > 0) {
		return $leftpc($padding $(text)$pad($padding " "));
	};
	return $text;
};
## format.getfilename (format_name)
## translate format_name to the file name containing the format strings
alias format.getfilename (format_name) {
#	@:sname=rest($strlen(format_) $format_name);
	@:sname=format_name;
	fe ($glob($(loadpath)format/*)) ii {
		if (fexist("$(ii)$sname") == 1 ) {
			return $(ii)$sname;
		};
	};
	echo WARNING: format file for $format_name not found.;
};
## format.numitems (format_name)
## highest numbered format string (note this might acually differ from the
## total number of formats)
alias format.numitems (fname) {
	@:fn=format.getfilename($fname);
	@:mv=0;
	if (fexist("$fn") == 1) {
			@ :fd = open("$fn" R);

			while ( !eof($fd)) {
				@:cline = read($fd);
				@:cv= word(0 $cline);
				if (isnumber($cv) && cv > mv )
					@mv=cv;
			};
			@close($fd);
	};
	return $mv;
};
## format.loaditem (format_name, number)
## Set @format_name from the specific format contained in <number>
alias format.loaditem (format_name, number ) {
	if (symbolctl(PMATCH ALIAS format.load$format_name)) {
		return $(format.load$(format_name)($number));
	};

	return $format.loaditemfromfile($format_name $number);
};

alias format.loaditemfromfile (format_name,number){
	@:cf=format.readitem($format_name $number);
	if (cf == 0 )
		return 0;
	@format_$format_name = "$cf";
	@theme.format.$format_name = number;

	return 1;
};

## format.fshow (format_name, number)
## Like fparse but instead of using the value in format_name it takes
## it from the file.
alias format.fshow (format_name, number, ...) {
	return ${**cparse($format.readitem($format_name $number))};
};

## format.printdesc (format_name)
## Helper function to print the description in the format files
## based on number
alias format.returndesc (format_name, number) {
	if (@number) {
		return $cparse(%K[%n$number%K]%n) $format.fshow($format_name $number $format_name $format.readitem($format_name DESC));
	};
	return $format.fshow($format_name ${theme.format.$format_name} $format_name $format.readitem($format_name DESC));
};

## format.readitem (format_name, number)
## return the format string by number
alias format.readitem (fname, number) {
	@:fn=format.getfilename($fname);
	if (fexist("$fn") == 1) {
			@ :fd = open("$fn" R);

			while ( !eof($fd)) {
				@:cline = read($fd);
				@:cv= word(0 $cline);
				if (cv == number ) {
					@close($fd);
					return $rest(${@cv+1} $cline);
				};
			};
			@close($fd);
	};
	return 0;
};

## Helper functions for config.m (to handle generic cases)
## 
alias format.printformats (format_name,letter,long_name) {
	@:fni=format.numitems($format_name);
	for (@mm=1, mm <= fni, @mm++) {
		xecho $format.returndesc($format_name $mm);
	};
	xecho $acban /format $letter <number> to set $long_name format;
	xecho $acban current format set to ${theme.format.$format_name};
};
alias format.setformat (format_name,number,long_name) {
	if (format.loaditem($format_name $number)) {
		xecho $format.returndesc($format_name);
		xecho $acban this is your new $long_name format, /fsave to save.;
		return 1;
	}{
		xecho -b please make a valid selection.;
		return 0;
	};
};

alias format.init {
	fe ($format_strings) cf {
		@format.loaditem($cf ${theme.format.$cf});
	};
};

alias format (choice,value,void) {
	if (@choice) {
		if (@value) {
			@:extra=" $value";
		}{
			@:extra='';
		};
	        switch ($choice) {
        	        (a) { mform$extra};
			(b) { smform$extra};
			(c) { pubform$extra};
			(d) { spubform$extra};
			(e) { puboform$extra};
			(f) { signform$extra};
			(g) { joinform$extra};
			(h) { leaveform$extra};
			(i) { modeform$extra};
			(j) { notform$extra};
			(k) { snotform$extra};
			(l) { sdcform$extra};
			(m) { dcform$extra};
			(n) { topform$extra};
			(o) { ctcpform$extra};
			(p) { sctcpform$extra};
			(q) { echostr$extra};
			(r) { ncomp$extra};
			(s) { svform$extra};
			(t) { scanform$extra};
			(u) { nickform$extra};
			(v) { wallform$extra};
			(w) { awayform$extra};
			(x) { actform$extra};
			(y) { xdescform$extra};
			(z) { pubnotform$extra};
			(1) { whoisform$extra};
			(2) { whoform$extra};
			(3) { timeform$extra};
			(4) { kickform$extra};
			(5) { ctcprform$extra};
		};
	}{
//echo;
//echo -------------------= Amnesiac Formats =------------------------;
//echo;
//echo  [a] messages            [k] send notices    [u] nick changes;
//echo  [b] send messages       [l] send dcc chat   [v] channel wall;
//echo  [c] publics             [m] dcc chat        [w] away formats;
//echo  [d] send publics        [n] topics          [x] action formats;
//echo  [e] public other        [o] ctcps           [y] desc formats;
//echo  [f] channel signoffs    [p] send ctcps      [z] public notice;
//echo  [g] channel joins       [q] echostrings     [1] whois formats;
//echo  [h] channel leaves      [r] nick completion [2] who formats;
//echo  [i] modes               [s] version reply   [3] timestamp formats;
//echo  [j] notices             [t] channel scans   [4] kick formats;
//echo  [5] ctcp replies;
//echo;
//echo ----------------------------------------------------------------;
	};
};
