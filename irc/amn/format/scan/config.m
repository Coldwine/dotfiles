# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
## constructor
alias format.loadscan (number,void)
{
	if (fexist($(loadpath)format/scan/scan.$number) != -1) {
		load ${loadpath}format/scan/scan.$number;
		@theme.format.scan = number;
		return 1;
	}{
		return 0;
	};
};

alias scanform.show (void) {
	fe ($numsort($glob($(loadpath)format/scan/scan.*))) ii { 
		@i = after(-1 . $ii);
		load ${loadpath}format/scan/scan.$i;
		xecho -v scan  [$(i)];
		@printnames(2 #amnesiac @azel @billhicks @brandonl @criminal @eyeless @HIVlntine @kreca @krimson @ku @pisqon @ruiner @rumball @rylan @skriver @skullY @twez @warjest @warjest` @Xavier @xcrapple @xpsycho @Ylluks @wicked @david liam  violence +zak +persiac crapple hayzus);
		xecho -v;
	};
	load ${loadpath}format/scan/scan.$theme.format.scan;
};
alias scanform (num,void){
	if (!@num) {
		scanform.show;
	}{
		@format.loaditem(scan $num);
	};
	xecho $acban scan format set to $(theme.format.scan);
};
