# Copyright (c) 2003-2010 Amnesiac Software Project.
# Copyright (c) 2007 hokkaido <jzzskijj gmail com>
# See the 'COPYRIGHT' file for more information.
# Modifications by kreca
if (word(2 $loadinfo()) != [pf]) {
        load -pf $word(1 $loadinfo());
        return;
};

subpackage utf8;

## sets
addset encode_utf8_to_latin bool;
set encode_utf8_to_latin off;

## alias
alias utf8 {set encode_utf8_to_latin toggle;};

## hooks
on ^msg "*" { //echo $fparse(format_msg $0 $userhost() $_utf_to_latin($1-)); };
on ^public "*" (nick,chan,text) { //echo $fparse(format_public $nick:$chan $_utf_to_latin($text)); };
^on ^notice * { xecho $fparse(format_notice $0 $userhost() $_utf_to_latin($1-)); };

on ^action "*" (sender, recvr, body) {
        if (winchan($recvr)) {
                if (iscurchan($recvr)) {
                        xecho $fparse(format_action $sender $recvr $_utf_to_latin($body));
                } {
                        xecho $fparse(format_action_other $sender $recvr $_utf_to_latin($body));
                };
        } {
                xecho $fparse(format_desc $sender $recvr $_utf_to_latin($body));
        };
};

^on ^332 * {xecho -b $fparse(format_settopic $_utf_to_latin($1-));};
^on ^topic * {
        if (! @*2) {
                xecho -b Topic unset by $0 on $1 at $strftime(%a %b %d %T %Z);
        }{
                xecho -b $fparse(format_topic $0 $1 $_utf_to_latin($2-));
        };
};



alias _utf_to_latin (text) {
	if (getset(encode_utf8_to_latin) == "off") {
		return $text;
	};
	if (isutf8($text) <= 0) {
		return $text;
	};
	return $xform(ICONV "utf-8/iso-8859-1" $text);
};
