# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

## easykline
## taken from http://www.garion.org/hosc
## Public domain license compatible with amnesiac license
@kline_enabled = 0;
@kline_mask = 1;
@kline_time = 1440;
@kline_reason = "drones/flooding";
alias klineview (number default 0,void) {
	@:properties = "name kline";
	@new_window_with_properties($number $properties);
	abecho $banner klineview is turned on. Type help for help;
};
alias kline_status {
	echo Enabled is $kline_enabled;
	echo Kline time is $kline_time;
	echo Klining $mask($kline_mask user@host.com);
	echo Kline-reason is $kline_reason;
};
alias kline_print_help {
     echo Short help for now.;
     echo Anything you paste in this window gets searched for 
         user@host and those hostnames get K-lined;
     echo Available settings: enable/disable, time, reason, 
              klineuseronly.;
     echo Typing the following into this window will change settings:;
     echo on|off: turns the script on or off.;
     echo time <time>: sets the k-line time. 0 for perm kline.;
     echo reason <reason>: sets the k-line reason.;
     echo klineuser <on|off>: toggles the k-lining of *user@host and *@host.;
     echo Type 'status' to get the current status of easykline.;
};

on #?input -999 * (args) {
	if (windowctl(GET 0 NAME) == "kline") {
		switch ($args) {
			(status) {
				kline_status;
			};
			(help) {
				kline_print_help;
			};
			(on) {
				@kline_enabled = 1;
				echo Enabling easy K-lines;
			};
			(off) {
				@kline_enabled = 0;
				echo Disabling easy K-lines;
			};
			(time %) {
				@kline_time = word(1 $args);
				echo Setting K-line time to $kline_time;
			};
			(reason %) {
				@kline_reason = word(1 $args);
				echo Setting K-line time to $kline_reason;
			};
			(klineuser %) {
				@:kline_user_only = word(1 $args);
				if (kline_user_only == 1 || kline_user_only == 'on') {
					@kline_mask = 1;
					echo K-lining *user@host.;
				}
				else if (kline_user_only == 0 || kline_user_only == 'off') {
					@kline_mask = 2;
					echo K-lining *@host.;
				}
				else {
					echo Unkown value;
				};
			};
			(*) {
				if (left(1 $args) != "$K" && kline_enabled == 1 && #args == 1) {
					@:nmask = mask($kline_mask $args);
					@nmask = rest(${substr(! $nmask)+1} $nmask);
					if (@nmask == 0) {
						return;
					};
					if (kline_time == 0) {
						echo K-lined $nmask :$kline_reason;
						quote kline $nmask :$kline_reason;
					}
					else {
						echo K-lined $kline_time $nmask :$kline_reason;
						quote kline $kline_time $nmask :$kline_reason;
					};

				}
			}
		}
		return 1;
	};
	return 0;
};