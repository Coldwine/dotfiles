# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) { load -pf $word(1 $loadinfo()); return; };

subpackage mmatrix;

@wordsfile=word(0 $_modsinfo.mmatrix.savefiles);

## some short form aliases.
alias unword {delword $*;};
alias rmword {delword $*;};
alias bwk listword;
alias word listword;
#end

alias addword {
	if ( # < 2) {
		xecho $acban Usage: /addword word #chan [type] to bk a word in specified chan.;
		xecho $acban type is either bk or kick. Default is bk.;
	}{
		@:bktype=[bk];
		if ( # >= 3 && findw($2 bk kick)) {
			@:bktype=[$2];
		};
		@setitem(_words 0 !);
		@setitem(_wordschan 0 !);
		@setitem(_wordstype 0 !);
		@setitem(_words $numitems(_words) $0);
		@setitem(_wordschan $numitems(_wordschan) $1);
		@setitem(_wordstype $numitems(_wordstype) $bktype);
		xecho $acban added word [$0] to channel $1 w/flag [$bktype];
	};
};
			
alias listword {
	if (numitems(_words) == 1) {
		xecho $acban no words current on list;
	}{
		xecho -v -- ------------------------------------------------------------------;
		for (@xx=1, xx<numitems(_words), @xx++) {
			xecho -v  | $cparse(%K[%n$xx%K]%n) $getitem(_words $xx) $getitem(_wordschan $xx) $getitem(_wordstype $xx);
		};
		xecho -v -- ------------------------------------------------------------------;
	};
};

alias delword {
	if (# == 1) {
		if ( [$0] > 0 && [$0] < numitems(_words))
		{
			xecho $acban deleted $getitem(_words $0) $getitem(_wordschan $0) from list;
			@delitem(_words $0);
			@delitem(_wordschan $0);
			@delitem(_wordstype $0);
		}{
			xecho $acban number out of range.;
		};
	}{
		xecho $acban Usage: /delword <number>;
	};
};

^on #-public 322 * {
	fe ($2-) a1 {
		if (matchitem(_words $a1) > -1 && getitem(_wordschan $matchitem(_words *$a1*)) == [$1] && (ischanop($0 $1)==0 || kickops == [on])) {
			@:mnum=matchitem(_words $a1);
			if (getitem(_wordstype $mnum) != [kick]) {
					//mode $1 +b $mask($_bt $userhost($0));
				};
				//kick $1 $0 BWK $getitem(_words $mnum);
			};
		};
};

^on #-public_other 322 * {
	fe ($2-) a1 {
		if (matchitem(_words $a1) > -1 && getitem(_wordschan $matchitem(_words *$a1*)) == [$1] && (ischanop($0 $1)==0 || kickops == [on])) {
			@:mnum=matchitem(_words $a1);
			if (getitem(_wordstype $mnum) != [kick]) {
				//mode $1 +b $mask($_bt $userhost($0));
			};
			//kick $1 $0 BWK $getitem(_words $matchitem(_words $a1));
		};
	};	
};

alias wordssave {
	@rename($(savepath)$wordsfile $(savepath)$wordsfile~);
	@savemt = open($(savepath)$wordsfile W T);
	@write($savemt @pubtrap = [$pubtrap]);
	for (@xx=1, xx<numitems(_words), @xx++) {
		@write($savemt @_words.$xx=[$getitem(_words $xx)]);
		@write($savemt @_wordschan.$xx=[$getitem(_wordschan $xx)]);
		@write($savemt @_wordstype.$xx=[$getitem(_wordstype $xx)]);
	};
	@close($savemt);
	xecho $acban Mmatrix wordlist(s) saved to $(savepath)$wordsfile [mod];
};

alias wordsload {
	^eval load $(savepath)$wordsfile;
	@ delarray(_words);
	@ delarray(_wordschan);
	@ delarray(_wordstype);
	@ ii = 1;
	@setitem(_words 0 !);
	@setitem(_wordschan !);
	@setitem(_wordstype !);
	while (_words[$ii]) {
		@ setitem(_words $ii $_words[$ii]);
		@ setitem(_wordschan $ii $_wordschan[$ii]);
		@ setitem(_wordstype $ii $_wordstype[$ii]);
		
		#add this for backwards compability with old savefile
		if (strlen($_wordstype[$ii]) == 0) {
			@ setitem(_wordstype $ii bk);
		};
		
		@ ii++;
	};
};

## pubtrap stuff, based off BlackJacs highlight script w/mods
## function moved here due to more switches being added to /addword
## in the near future
## pubtrap will notify you of triggered words/phrases said in a hidden
## window to current visable window.
@pubtrap=[];

## ptrap wrapper
alias ptrap {_pubtrap $*;};
alias _pubtrap {
        if (#) {
		@pubtrap=[$*];
	};
	xecho -v $acban pubtrap word/phrase notify set to "$pubtrap";
	^assign $pubtrap;
};

## ptrap hook
fe (public public_other) hh {
	^on #-$hh 4 '% % *\\\\[$$pubtrap\\\\]*' {
		@ :window = winchan($1);
		if (!winvisible($window)) {
			xecho -b -c $Z (trap) $0 in $1 at [window #$window]: $2-;
		};
	};
};

alias bwkhelp mmhelp;
alias wordhelp mmhelp;
alias mmhelp {
	//echo -----------------------= Multi-Matrix Help =--------------------------;
	//echo addword   /addword /addword word #chan [type] to bk a word in;
	//echo specified channel... type is either bk or kick. Default is bk.;
	//echo delword   /delword <num> will delete specified word from list.;
	//echo listword  /listword will list words in bankick word list.;
	//echo wordssave /wordssave will save the word list in bankick word list.;
	//echo ptrap     /ptrap <word> will notify you about the event in the current window.;
	//echo                       -= Wordkick Quick Aliases =-;
	//echo			/unword, /rmword, /bwk, /word;

	//echo -------------------------------------------------------------------;
};
