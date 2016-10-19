alias wallform (number) {
	if (@number) {
		if (format.loaditem(wall $number)&&format.loaditem(bwall $number)) {
			xecho $format.returndesc(wall);
			xecho $format.returndesc(bwall);
			xecho $acban this is your new wall format, /fsave to save.;
		}{
			xecho -b please make a valid selection.;
		};
	}{
		wallform.show;
	};
};

alias wallform.show {
	@:fni=format.numitems(wall);
	for (@mm=1, mm <= fni, @mm++) {
		xecho $format.returndesc(wall $mm);
		xecho $format.returndesc(bwall $mm);
	};
	xecho $acban /format v <number> to set wall format;
	xecho $acban current format set to $theme.format.wall;
};

alias svform (number) {
	if (@number) {
		@format.setformat(version_reply $number version reply (sv));
	}{
		@format.printformats(version_reply s version reply(sv));
	};
};

alias whoform (number) {
	if (@number) {
		if (format.loaditem(who $number)&&format.loaditem(who_footer $number)) {
			xecho $format.returndesc(who);
			xecho $format.returndesc(who_footer);
			xecho $acban this is your new who format, /fsave to save.;
		}{
			xecho -b please make a valid selection.;
		};
	}{
		@format.printformats(who 2 who);
	};
};

alias format.loadtimestamp_some (number,void)
{
	## timestamp some. timestamp all has been removed.
	if (_tss=='on') {
		@_timess='Z';
		^assign -zt;
		return $format.loaditemfromfile(timestamp_some $number);
	}{
		^assign -_timess;
		^assign -format_timestamp_some;
                @ZT = G;
	};
	return 1;
};

alias timeform (number) {
	if (@number) {
		@format.setformat(timestamp_some $number time stamp);
	}{
		timeform.show;
	};
};

alias timeform.show {
	@:fni=format.numitems(timestamp_some);
	for (@mm=1, mm <= fni, @mm++) {
		xecho $format.returndesc(timestamp_some $mm)$cparse(%m<%ncrapple%m>%n timestamp in public format example.);
	};
	xecho $acban /format 3 <number> to set time stamp format;
	xecho $acban current format set to $theme.format.timestamp_some;
};
