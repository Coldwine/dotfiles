# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage addsets;

## compiling sets
addset auto_rejoin bool;
addset auto_rejoin_delay int;
addset auto_rejoin_connect bool;
addset auto_reconnect bool;
addset auto_reconnect_delay int;
addset auto_reconnect_retries int;
addset auto_new_nick bool;
addset auto_new_nick_char char;
addset auto_new_nick_length int;
addset auto_new_nick_list str;
addset auto_whowas_limit int;
addset beep_on_msg str;
addset history_circleq bool;
addset history_save_file str;
addset history_remove_dupes bool;
addset history_save_position bool;
addset history_timestamp bool;
addset suppress_server_motd bool;
addset paste_strip bool;
addset paste_delay int;
addset num_of_whowas int;
addset show_end_of_msgs bool;
addset show_who_hopcount bool;
addset auto_whowas bool;

## compile dcc port min/max funcs
addset dcc_port_min int {
   dcc_ports.regen
};
addset dcc_port_max int {
   dcc_ports.regen
};

## sets compiled above gets set here. (do not remove)
set auto_rejoin_delay 5;
set auto_new_nick on;
set auto_new_nick_char _;
set auto_new_nick_length 9;
set auto_whowas_limit 2;
set history_save_file ~/.epic_history;
set history_remove_dupes on;
set history_save_position on;
set history_timestamp on;
set beep_on_msg none;
set suppress_server_motd off;
set paste_strip OFF;
set paste_delay 20;
set dcc_port_min 19000;
set dcc_port_max 19500;
