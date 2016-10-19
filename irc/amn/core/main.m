# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage main;

#amnesiac version info
@a.ver='amnesiac';
@a.rel_id='2';
@a.rel="2.0.$a.rel_id";
@a.date='20100726';
@a.snap='20100726';
@a.commitid='51';

## color vars.
@ cl    = "[0m";
@ blk   = "[0\;30m";
@ blu   = "[0\;34m";
@ grn   = "[0\;32m";
@ cyn   = "[0\;36m";
@ red   = "[0\;31m";
@ mag   = "[0\;35m";
@ yel   = "[0\;33m";
@ wht   = "[0\;37m";
@ hblk  = "[1\;30m";
@ hblu  = "[1\;34m";
@ hgrn  = "[1\;32m";
@ hcyn  = "[1\;36m";
@ hred  = "[1\;31m";
@ hmag  = "[1\;35m";
@ hyel  = "[1\;33m";
@ hwht  = "[1\;37m";
@ bwht  = "[47m";
@ bmag  = "[45m";
@ bblu  = "[44m";
@ bred  = "[41m";
@ bblk  = "[40m";
@ bgrn  = "[42m";
@ byel  = "[43m";
@ bcyn  = "[46m";

## default assigns
@_ort='3';
@_bt='3';
@_et='3';
@bt_='better';
@et_='better';
@awayt='60';
@awayl='on';
@awayr='Not Here';
@rfrombuf='15';
@rsendbuf='10';
@_ss='15';
@_ovsize='5';
@_ovmode='bfiklrsuwxyzZ';
@skills='on';
@srkline='on';
@srkbots='on';
@owcopy='off';
@dateconv='off';
@kickops='off';
@togpager='off';
@fke1='wholeft';
@fke2='wl';
@fke3='wsa';
@fke4='scan';
@fke5='uptime';
@fke6='dcc';
@fke7='arejoin';
@fke8='svlist';
@fke9='config';
@fke10='topic';
@fke11='ahelp';
@fke12='ehelp';
@crapl='on';
@msgl='on';
@notl='on';
@plog='on';
@dccl='on';
@togaway='off';
@getumode='iw';
@showop='on';
@autoget='off';
@_pubnick=N;
@_tss='on';
@clonecheck='off';

# load default theme
load $(loadpath)/themes/main.th;

# Seed the RNG for cases where it's necessary
@srand();
