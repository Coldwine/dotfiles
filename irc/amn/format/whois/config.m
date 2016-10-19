# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

## constructor
alias format.loadwhois (number,void) {
	if (fexist($(loadpath)format/whois/whois.$number) != -1) {
		load ${loadpath}format/whois/whois.$number;
		@theme.format.whois = number;
		return 1;
	}{
		return 0;
	};
};
alias whoisform.show (void) {
	fe ($numsort($glob($(loadpath)format/whois/whois.*))) ii { 
		@:i = after(-1 . $ii);
		load ${loadpath}format/whois/whois.$i;
		xecho -v whois  [$(i)];
		echo;
		@format.loaditem(whois $i);
		//shook 311 . crapple zak@psychedelic.hallucinogen.ca . . I am the hate you try to hide;
		//shook 319 . . @#epic @#amnesiac @#ceilingcat;
		//shook 312 . . hub.deathwish.net what god wants, god gets, god help us all;
		//shook 301 . Amused to death;
		//shook 313 . zak;
		//shook 317 . zak 6666666 0;
		//shook 318;
		echo;
	};
};

alias whoisform (number,void) {
	if (@number) {
		@format.loaditem(whois $number);
	}{
		whoisform.show;
	};
	xecho $acban whois format set to $(theme.format.whois);
};
