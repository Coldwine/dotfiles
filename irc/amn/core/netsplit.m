# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# Taken from the base epic5/scripts.
#
# integration into amnesiac by crapple/kreca some simplifications
# and adaption with amnesiac formats
# crapple/kreca 05 rylan 06
# fixed by skullY 09

if (word(2 $loadinfo()) != [pf]) {
        load -pf $word(1 $loadinfo());
        return;
};

subpackage netsplit;

## some aliases //zak
alias listsplit wholeft;
alias npurge netpurge;  
alias nclean netclean;

## shows the current time in HH:MM:SS format
alias currtime { return $strftime(%T); };

# This function tests for bogus splits.
alias isbogus {
	if (# > 3)
		return 1;
	if (rmatch(.$1. $isbogus.pats *..*))
		return 1;
	if (rmatch(.$2. $isbogus.pats *..*))
		return 1;
	return 0;
};

# Add patterns.. like /boguspat *bonk* *thud* *haha*
# that will NOT be treated as server names..
alias boguspat {
	^assign isbogus.pats $isbogus.pats $*;
	//echo $* added;
};

alias boguslist {//echo Pats: $isbogus.pats;};
alias bogusclear {
	^assign -isbogus.pats;
	//echo Bogus list clean;
};

# If first word in Signoff contains a period then assume servername
# and thus a a split.  Stash in assoc array.
^ON ^CHANNEL_SIGNOFF "% % %.% %.%" {
	if (isbogus($1-)) {
		xecho $fparse(format_signoff $0 $1 $2-);
		defer getusers;
	} { 
		netbroke $encode($tolower($0)) $encode($1) $encode($2).$encode($3) $2 $3;
	};
};

# Stuff array. Tell us what server broke and set split flag.
alias netbroke {
	@ signcross[$2][$0][$1] = 1;
	@ signoffs[$0][$1] = *2;
	@ splittime[$2] = time();
	if ( !isbroke[$2] ) {
		xecho -b -level OPNOTES Netsplit at $currtime() \($3-\);
		@ isbroke[$2] = 1;
		@ splitname[$2] = "$3-";
	};
};

# When a person joins a channel.. Check them against the array.
# If they are in array, then remove silently.  Otherwards echo normally
^on ^join * {
	@nj = netjoined($encode($tolower($1)) $encode($0) $1 $0 $USERHOST());
	if (nj == 1) {
	xecho $fparse(format_join $0 $1 $2);
		if (clonecheck == 'on') {           
			xecho -b Checking for clones of $0!$userhost($0);
			fe ($channel($1)) channick {                     
				@nicklength = (strlen($channick) - 2);
				@channick = right($nicklength $channick);
				if (userhost($channick)==userhost($0)) {
					@clonelist = "$channick $clonelist";
				};
			};
			if (clonelist != '') {
				xecho -b Clones detected: $clonelist;
			};
		};
		defer getusers;
	};
};

# Unset the split flag
alias netjoined {
	if ( signoffs[$0][$1] ) {
		if ( isbroke[$signoffs[$0][$1]] ) {
			xecho -level OPNOTES *** Netjoined at $currtime() \($splitname[$signoffs[$0][$1]]\);
		};
		^assign -isbroke[$signoffs[$0][$1]];
		^assign -signcross[$signoffs[$0][$1]][$0][$1];
		^assign -signoffs[$0][$1];
		return 0;
	};
	return 1;
};

## Clear the array every 10 minutes to prevent excess garbage
^on #^timer 70 * netclean;
alias netclean {
	foreach splittime ii {
		foreach splittime.$ii jj {
			if ( time() - splittime[$ii][$jj] > 900 ) {
				foreach signcross.$(ii).$jj xx {
					foreach signcross.$(ii).$(jj).$xx yy {
						@ signcross[$ii][$jj][$xx][$yy] = signoffs[$xx][$yy] = '';
					};
				};
				@ xx = yy = isbroke[$ii][$jj] = '';
				@ splitname[$ii][$jj] = splittime[$ii][$jj] = '';
			};
		};
	};
};

alias netpurge {
	netsplit.purge isbroke;
	netsplit.purge splitname;
	netsplit.purge splittime;
	netsplit.purge signcross;
	netsplit.purge signoffs;
};

# Lists keys and contents
alias showsplit {
	if ( "$($0)" ) {
		//echo $0 $($0);
	};
	foreach $0 ii {
		showsplit $0.$ii;
	};
	^assign -ii;
};

alias netsplit.purge {
	foreach $0 ii {
		netsplit.purge $0.$ii;
	};
	^assign -ii;
	^assign -$0;
};

alias wholeft {
	foreach signoffs ii {
		foreach signoffs.$ii jj {
			//echo $lformat(15 $decode($ii)) $lformat(10 $decode($jj)) $splitname[$signoffs[$ii][$jj]];
		};
	};
	^assign -ii;
	^assign -jj;
};

# format and lformat differ from $[-num]var and $[num]var in that
# They don't chop off the string if it is too long.

alias lformat (len, stuff) {
	if (@stuff < len) { 
	    return $([$len]stuff); 
	} else { 
	    return $stuff; 
	};
};
