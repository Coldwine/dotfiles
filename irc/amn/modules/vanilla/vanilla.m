# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# Make amnesiac behave a bit more like default epic with tc and netsplit
# loaded, just the way skullY likes it.
if (word(2 $loadinfo()) != [pf]) { load -pf $word(1 $loadinfo()); return; };
subpackage vanilla;

@ bindctl(sequence ^D set parse_command listsplit);
@ bindctl(sequence ^E set end_of_line);
@ bindctl(sequence ^P set parse_command window prev);
@ bindctl(map ^W clear);

window -1 level ALL;

alias echo (args) {
	xecho -v $args;
};

alias sc (chan) {
	if (chan) {
		names $chan;
	} {
		names $serverchan();
	};
};

alias paste (args) {
	_pasteon $args;
};
