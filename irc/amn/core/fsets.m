# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};
subpackage fsets;

@fwords="back chops ctcp_reply dcc_connect dcc_done_file dcc_lost_chat dcc_lost_file dcc_request invite scan_footer scan_header scan_nicks scan_nicks_border scan_users scan_users_non scan_users_op scan_users_voc server_notice sort user_non wallop whois_actual whois_admin whois_away whois_channels whois_footer whois_header whois_ident whois_idle whois_name whois_nick whois_operator whois_server whois_signon whois_unknown whowas_footer whowas_header whowas_name whowas_nick whowas_unknown $format_strings";

## sfset, internal function used in wis etc to set formats
## Full variable name is used here i.e. input is format_var
alias sfset (format_name,value){
	@format_$after(_ $format_name) = value;
};

alias fset (format_name,value) {
	if (@format_name) {
   		if (!pattern($format_name* $fwords)) {
	    		xecho $acban $format_name format not found;
  		}{
			if (findw($format_name $fwords) != -1 && @value) {
        	        	^assign format_$0 $value;
				xecho $acban fset $format_name changed to $value;
			}{
				fe ($pattern($format_name* $fwords)) a1 {
					xecho $acban $[31]a1 ...... $(format_$a1);
				};
			};
		};
	}{
		fe ($fwords) a1 {
			xecho $acban $[31]a1 ...... $(format_$a1);
		};
	};
};

alias fparse {return ${**cparse($($*))};};

## who fsets.
^on ^who * {
	xecho $fparse(format_who $*);
};

^on ^315 "*" {
	xecho $fparse(format_who_footer $*);
};
## NOTE: Confusions as to why some are using //echo or xecho
## Im certain there is a valid reason but we should probably
## be consistent for sanitys sake if possible //zak

## msg fsets.
^on ^msg_group * {//echo $fparse(format_msg_group $0 $1 $2-);};
^on ^msg * {//echo $fparse(format_msg $0 $userhost() $1-);};
^on ^send_msg * {//echo $fparse(format_send_msg $0 $1-);};

## wallop/notice
^on ^wallop * {//echo $fparse(format_wallop $0 $1 $2-);};
^on ^notice * {xecho $fparse(format_notice $0 $userhost() $1-);};
^on ^send_notice * {//echo $fparse(format_send_notice $0 $1-);};
^on ^public_notice * {
	xecho -w $winchan($1) $fparse(format_public_notice $0 $1 $2-);
};

## ctcp fsets.
^on ^ctcp * {xecho $fparse(format_ctcp $0 $userhost() $1 $2 $3 $4);};
^on ^ctcp_reply * {xecho $fparse(format_ctcp_reply $0 $2 $3-);};
^on ^send_ctcp * {
	if ( *0 == 'privmsg' && *2 != 'action') {
		//echo $fparse(format_send_ctcp $0 $1 $2 $3-);
	};
};

## dcc fsets.
^on ^dcc_request * {
	//echo $fparse(format_dcc_request $0 $1 $2 $3 $4 $5 $6);
};
^on ^dcc_connect * {
	if ( *1 != 'RAW') {
		//echo $fparse(format_dcc_connect $0 $1 $2 $3 $4 $5);
	};
};
^on ^dcc_lost "% CHAT *" {
	xecho $fparse(format_dcc_lost_chat $*);
};

^on ^send_dcc_chat * {//echo $fparse(format_send_dcc_chat $0 $1-);};
^on ^dcc_chat * {//echo $fparse(format_dcc_chat $0 $1-);};

## fsets to defer getusers(status_update)
^on ^channel_signoff * {
	xecho $fparse(format_signoff $0 $1 $2-);
	defer getusers;
};

^on ^part * {
	xecho $fparse(format_leave $0 $userhost() $1 $3-);
	defer getusers;
};

^on ^mode * {
	xecho $fparse(format_mode $0 $1 $2 $3-);
	defer getusers;
};

^on ^kick * {
	xecho $fparse(format_kick $0 $1 $2 $3-);
	defer getusers;
};

^on ^channel_nick * {
	xecho $fparse(format_nickname $1 $2);
};

^on ^invite * {
	xecho $fparse(format_invite $0 $1);
	xecho $G press Ctrl-K to join;
	//push invchan $1;
};

## non-moduler fsets. (perm)
^on ^471 * {xecho $fparse(format_timestamp_some $($_timess)) $1: Channel is full;};
^on ^475 * {xecho $fparse(format_timestamp_some $($_timess)) $1: Incorrect key;};
^on ^473 * {xecho $fparse(format_timestamp_some $($_timess)) $1: Invite required;};
^on ^329 * {xecho $fparse(format_timestamp_some $($_timess)) Channel $1 created at $strftime($2 %a %b %d %T %Z %Y);};
^on ^221 * {xecho $fparse(format_timestamp_some $($_timess)) Current user mode is "$1";};
^on ^341 * {xecho $fparse(format_timestamp_some $($_timess)) Inviting $1 to $2;};

## knocks.
^on ^710 * {
	@:thenick=word(0 $split(! $2));
	@:therest=mid($strlen($thenick) $strlen($2) $2);
	aecho $fparse(format_timestamp_some $($_timess))$(hwht)\<$(cl)knock$(hwht)\>$(cl) $(hred)$0$(cl) $(hwht)$(thenick)$(cl)$therest \($1\);
};

## CID notification.
^on ^718 * {
	@:thenick=word(0 $split(! $2));
	@:therest=mid($strlen($thenick) $strlen($2) $2);
	xecho -l msg $fparse(format_timestamp_some $($_timess))$(hwht)\<$(cl)CID$(hwht)\>$(cl) $(hred)$0$(cl) $(hblu)$(thenick)$(cl)$therest \($1\);
	push cidreq $1;
	xecho -l msg $fparse(format_timestamp_some $($_timess))$(hwht)\<$(cl)CID$(hwht)\>$(cl) Press alt-Y to accept from $1;
};

## topic stuff 
## NOTE: Need to investigate if we really need to suppress
## some of these numerics with so many changes to the ircd in the past
## 8 years //zak
^on ^331 * {xecho $fparse(format_notopic $1-);};
^on ^332 * {xecho $fparse(format_settopic $1-);};
^on ^333 * {xecho $fparse(format_topicby $1 $2 $stime($3));};
^on ^315 * #;
^on ^305 * #;
^on ^topic * {
        if (! @*2) {
                xecho $fparse(format_topic $0 $1 (unset topic));
	}{
                xecho $fparse(format_topic $0 $1 $2-);
        };
};

## banlist hooks
^on ^433 * {xecho $fparse(format_timestamp_some $($_timess)) $1 $sar(g/:/$(hblk):$(cl) /$2) $3 $4 $5 $6;};
^on ^306 * #;
^on ^405 * {xecho $fparse(format_timestamp_some $($_timess)) $1: You have joined too many channels;};
^on ^441 * {xecho $fparse(format_timestamp_some $($_timess)) $1 isn't on channel $2 ;};
^on ^482 * {xecho $fparse(format_timestamp_some $($_timess)) $1: You are not oped;};
^on ^474 * {xecho $fparse(format_timestamp_some $($_timess)) $1: You are banned;};

## whois stuff
on ^311 * {
## Since 311-318 is an atomic operation we can safely do this crazy
## ircii feature.

	stack push on 301;
	on ^301 * xecho $$fparse\(format_whois_away $$1-\);
	if (format_whois_header) {
		xecho $fparse(format_whois_header);
	};
	xecho $fparse(format_whois_nick $1 $2 $3 $5-);
	if (format_whois_name) {
		xecho $fparse(format_whois_name $5-);
	};
};
on ^319 * {xecho $fparse(format_whois_channels $2-);};
on ^312 * {xecho $fparse(format_whois_server $2 $3-);};

on ^317 * {
	xecho $fparse(format_whois_idle $2);
	xecho $fparse(format_whois_signon $1 $stime($3));
};

on ^318 * {
	stack pop on 301;
	if (format_whois_footer) {
		xecho $fparse(format_whois_footer);
	};
};
on ^314 * { 
	xecho $fparse(format_whowas_header);
	xecho $fparse(format_whowas_nick $1 $2 $3);
	xecho $fparse(format_whowas_name $5-);
};
on ^338 * {
	xecho $fparse(format_whois_actual $*);
};
on ^330 * {
        xecho $fparse(format_whois_login $*);
};
on ^307 * {
        xecho $fparse(format_whois_ident $*);
};
## Unreal ircd stuff for fikle. ## gonna remove unrealircd shit
## in the near future, such uglyness, perhaps could modularize it?
on ^310 * {
        xecho $fparse(format_whois_active $*);
};

on ^320 * {                                 
        xecho $fparse(format_whois_root $*);
};

on ^378 * {                                 
        xecho $fparse(format_whois_connect $*);
};
## End Unreal.

on ^308 * {
	xecho $fparse(format_whois_admin $1-);
};

## oper whois.
on ^313 * {
	xecho $fparse(format_whois_operator $1 $randread($(loadpath)reasons/oper.reasons));
};

^on ^401 * { 
        xecho $fparse(format_whois_header);
	xecho $fparse(format_whois_unknown $1);
        xecho $fparse(format_whois_footer);
	if (getset(auto_whowas) == 'on' && !ischannel($1)) {
		whowas $1 $getset(auto_whowas_limit);
	};
};

## for /wii aka whois nick nick
^on ^402 * {
        xecho $fparse(format_whois_header);
        xecho $fparse(format_whois_unknown $1);
        xecho $fparse(format_whois_footer);
};

^on ^369 * {
	xecho $fparse(format_whowas_footer);
};

^on ^406 * { 
	xecho $fparse(format_whowas_header);
	xecho $fparse(format_whowas_unknown $1);
};

## ssl client format for whois
on ^671 * {xecho $fparse(format_whois_security $2-);};
