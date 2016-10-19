# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};
subpackage history;

@ history.index = '';

#	Copyright (c) 2005 (BlackJac@EFNet)
#  /history [<indexnum>]
#	Returns a list of all commands in the history buffer, or
#	all commands up to <indexnum>. 
#  /!<indexnum|pattern> Retrieves history buffer entries and outputs them 
#	to the input line. Use /!<indexnum> to retrieve <indexnum>
#	or /!<pattern> to retrieve the most recent entry matching <pattern>.

## flush the history buffer
alias hflush (void) { 
	@historyctl(reset);
	xecho -b -c History index flushed;
};

## history funcs cont
alias history (index, void) {
	xecho -b -c Command History:;
	if (index > (:numitems = numitems(array.history)) || !index) {
		@ index = numitems;
	};
	if (index > 0) {
		fe ($jot(0 ${index - 1} 1)) hh {
			@ :item = getitem(array.history $hh);
			xecho -c $hh${history_timestamp == 'on' ? "  [$word(3 $stime($word(0 $item)))]  " : ': '}$restw(1 $item);
		};
	};
};

alias history.add (...) {
	if (@) {
		if (history_remove_dupes == 'on') {
			fe ($getmatches(array.history % $*)) hh {
				@ delitem(array.history $hh);
			};
		};
		if (numitems(array.history) == history) {
			@ delitem(array.history 0);
		};
		@ setitem(array.history $numitems(array.history) $time() $*);
		@ history.index = '';
	};
};

# the only difference between these two functions is that erase_line
# adds the removed text to the cut buffer

alias history.erase (void) {
	@ history.index = '';
	parsekey reset_line;
};

alias history.erase_line (void) {
	@ history.index = '';
	parsekey erase_line;
};

alias history.get (direction, void) {
	if (direction == 1) {
		if (@L && @history.index == 0) {
			history.add $L;
		};
		if ((history.index == (:numitems = numitems(array.history) - 1) || @history.index == 0)) {
			if (history_circleq == 'on') {
				history.show 0;
			} else {
				history.erase;
			};
		} else if (history.index < numitems && @history.index) {
			history.show ${history.index + 1};
		};
	} else if (direction == -1) {
		if (@L && @history.index == 0) {
			history.add $L;
			@ history.index = numitems(array.history) - 1;
		};
		if ((history.index == 0 && history_circleq == 'on') || @history.index == 0) {
			history.show ${numitems(array.history) - 1};
		} else if (history.index > 0) {
			history.show ${history.index - 1};
		};
	};
};

alias history.shove (void) {
	history.add $L;
	parsekey reset_line;
};

alias history.show (index, void) {
	if (@index) {
		@ history.index = index;
		parsekey reset_line $restw(1 $getitem(array.history $history.index));
	};
};

alias historyctl (action, ...) {
	switch ($action) {
		(add) {
			if (history) {
				history.add $*;
				return 1;
			};
			return 0;
		};
		(delete) {
			@ delitem(array.history $0);
		};
		(get) {
			return $restw(1 $getitem(array.history $0));
		};
		(index) {
			if (strlen($getitem(array.history $0))) {
				@ history.index = *0;
				return 1;
			};
			return 0;
		};
		(read) {
			if ((:fd = open(${*0 ? *0 : history_save_file} R)) > -1) {
				while (:line = read($fd)) {
					if (numitems(array.history) == history) {
						@ delitem(array.history 0);
					};
					@ setitem(array.history $numitems(array.history) $line);
				};
				@ close($fd);
				return $fd;
			};
		};
		(reset) {
			@ history.index = '';
			@ delarray(array.history);
		};
		(save) {
			if ((:fd = open(${*0 ? *0 : history_save_file} W)) > -1) {
				fe ($jot(0 ${numitems(array.history) - 1} 1)) hh {
					@ write($fd $getitem(array.history $hh));
				};
				@ close($fd);
				return $fd;
			};
		};
		(set) {
			^set history $0;
			return 1;
		};
	};
};

## cmd input
alias sendline (...) {
	if (@) {
		history.add $*;
		//sendline $*;
	};
};

^on ^input "/!*" {
	@ :find = after(! $0);
	if (isnumber($find)) {
		if (:found = getitem(array.history $find)) {
			xtype -l $restw(1 $found)${*1 ? "$1-" : ''};
		} else {
			xecho -b -c No such history entry: $find;
		};
	} else if (:found = "$getmatches(array.history % /$find*) $getmatches(array.history % $find*)") {
		@ :index = rightw(1 $numsort($found));
		if (history_save_position == 'on') {
			@ history.index = index;
		};
		xtype -l $restw(1 $getitem(array.history $index))${*1 ? " $1-" : ''};
	} else {
		xecho -b -c No match;
	};
};

addset history int {
	if (*0 == 0) {
		@ delarray(array.history);
		@ history.index = '';
		^bind ^] nothing;
		^on #input 2 -"*";
		^on #input 2 -"/!*";
	} else if (@) {
		if (numitems(array.history) > history) {
			until (numitems(array.history) == history) {
				@ delitem(array.history 0);
			};
		};
		^bind ^] shove_to_history;
		^on #-input 2 "*" {
			history.add $*;
		};
		^on #-input 2 "/!*" #;
	};
};

## settings
set history 150;
addset history_persistent bool {
	if (*0 == 'on') {
		^on #-exit 2 "*" {
			@ historyctl(save $history_save_file);
		};
	} else if (@) {
		^on #exit 2 -"*";
	};
};

set history_persistent off;
if (history_persistent == 'on' && fexist($history_save_file) == 1) {
	@ historyctl(read $history_save_file);
};
