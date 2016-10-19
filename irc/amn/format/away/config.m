alias awayform (number) {
	if (@number) {
		if (format.loaditem(away $number)) {
			//echo crapple away: (not here) $format.returndesc(away);
			xecho $acban this is your new action format, /fsave to save.;
		}{
			xecho -b please make a valid selection.;
		};

	}{
		@:fni=format.numitems(away);
		for (@mm=1, mm <= fni, @mm++) {
			xecho $Cparse(%K[%n$mm%K]%n) crapple away: (not here) $format.fshow(away $mm away $format.readitem(away DESC));
		};
		xecho $acban /format w <number> to set away format;
		xecho $acban current format set to $theme.format.away;

	};
};
