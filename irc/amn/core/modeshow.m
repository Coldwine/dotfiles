# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage modeshow;

# config
alias modeshow {vocop $*;};

alias config.showop {
	if ( *0 == '-r' )
	{
		return $showop;
	} else if (*0 == '-s') {
		config.matchinput on|off showop '$1' showing <@nick> and <+nick> in public;
	};
};

alias vocop {
	config.showop -s $*
};

osetitem misc showop Extended publics:;

# end of config

alias highlightpub (nick, text) {
	fe (_pubnick) cur {
		@:cursearch = $cur;
		if (  strlen($cursearch) && match($cursearch* $text) > 0 ) {
			return $(hwht)$nick$(cl);
		};
	};
	return $nick;
};

alias pubpad {
	@:thenick=word(0 $split(: $2));
	@:thechan=word(1 $split(: $2));
	@:extravar='';
	if (showop == 'on') {
		if (ischanop($thenick $thechan)) {
			@:extravar = "$(c5)@$(cl)";
		} else if (ischanvoice($thenick $thechan)) {
			@:extravar = "$(c5)+$(cl)";
		};
	};
	if (*1>0) {
		@:thenick="$[$1]thenick";
		if (!strlen($extravar)){
			@:thenick=" $thenick";
		};
	};
	@:thenick = highlightpub($thenick $3-);

	if (!iscurchan($thechan)) {
		return $(extravar)$0$(thenick):$thechan;
	} else {
		return $(extravar)$0$(thenick);
	};
};

alias spubpad {
	@:thenick=word(0 $split(: $2));
	@:thechan=word(1 $split(: $2));
	@:extravar='';
	if (showop == 'on') {
		if (ischanop($thenick $thechan)) {
			@:extravar = "$(c5)@$(cl)";
		} else if (ischanvoice($thenick $thechan)) {
			@:extravar = "$(c5)+$(cl)";
		};
	};
	if (*1>0) {
		@:thenick="$[$1]thenick";
		if (!strlen($extravar)){
			@:thenick=" $thenick";
		};
	};
	return $(extravar)$0$(thenick);
};

on ^public * (nick,chan,text) {
	//echo $fparse(format_public $nick:$chan $text);
};

on ^public_other * (nick,chan,text) {
	@:extravar = '';

	if (showop == 'on') {
		if (ischanop($nick $chan)) {
			@extravar = "$(c5)@$(cl)";
		} else if (ischanvoice($nick $chan)) {
			@extravar = "$(c5)+$(cl)";
		};
	};
	@nick = highlightpub($nick $text);

	//echo $fparse(format_public_other $(extravar)$(nick) $chan $text);
};

on ^send_public * (chan, text) {
	if ( iscurchan($chan)) {
		//echo $fparse(format_send_public $servernick():$chan $text);
	} {
## Compensate for lame setup of send_public_other ##
		@extravar = '';
		if (showop == 'on') {
			if (ischanop($servernick() $chan)) {
				@extravar = "$(c5)@$(cl)";
			} else if (ischanvoice($servernick() $chan)) {
				@extravar = "$(c5)+$(cl)";
			};
		};
		//echo $fparse(format_public_other $(extravar)$(N) $chan $text);
	};
};
