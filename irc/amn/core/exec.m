# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage exec;

## dns stuff.
alias dns {
	if (match(*.* $0)) {
		exec -name dns nslookup $0;
		@ _dnst=*0;
	}{
			^userhost $0 -cmd if (*4 !='<UNKNOWN>') {
				exec -name dns nslookup $4;
				@ _dnst=*0;
			};
	};
};
 	
alias nslookup {dns $*;};
 
^on ^exec "dns *" {
	if (*1 == 'Non-authoritative') {
		xecho -c [dns] Non-authoritative answer for $_dnst;
	}{
		if (*1 == 'Server:') {
			xecho -c [dns] -----------------------------------------;
			xecho -c [dns] System Name Server: $2-;
		} else if (@"$1-") {
			xecho -c [dns] $1-;
		};
	};
};

^on ^exec_exit "dns % %" {
	xecho -c [dns] -----------------------------------------;
};

## (pager) this taken from EPIC4 dist written by archon
alias more {
	if ( @ ) {
		if (fexist("$*") == 1) {
			@ :fd = open("$*" R);

			while (1) {
				@:rows = winsize() - 1;
				for (@:line=0, line <= rows, @line++) {
					@ outp = read($fd);
					if (eof($fd)) {
						@ close($fd);
						return;
					}{
						xecho $outp;
					};
				};
				^local ret $'Enter q to quit, or anything else to continue ';
				if (ret == 'q') {
					@ close($fd);
					return;
				};
			};
		}{
			xecho -b $*\: no such file.;
		};
	}{
		xecho -b Usage: /more <filename>;
	};
};

## archon'96 rylan'06 kreca'06
## end of pager

## cmd exec shit.
alias ps (...) {
	exec -direct ps $*;
};

alias ls (...) {
	exec -direct ls $*;
};

alias osv (...) {
	exec -o uname -amnv;
};

alias hosts (...) {
	exec -direct host $*;
};

alias dig (...) {
	exec -direct dig $*;
};
