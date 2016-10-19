alias actform (number) {
	if (@number) {
		if (format.loaditem(action $number)&&format.loaditem(action_other $number)) {
			xecho $format.returndesc(action);
			xecho $format.returndesc(action_other);
			xecho $acban this is your new action format, /fsave to save.;
		}{
			xecho -b please make a valid selection.;
		};
	}{
		actform.show;
	};
};

alias actform.show {
	@:fni=format.numitems(action);
	for (@mm=1, mm <= fni, @mm++) {
		xecho $format.returndesc(action $mm);
		xecho $format.returndesc(action_other $mm);
	};
	xecho $acban /format x <number> to set action format;
	xecho $acban current format set to $theme.format.action;
};

alias xdescform (number) {
	if (@number) {
		if (format.loaditem(desc $number)&&format.loaditem(send_desc $number)) {
			xecho $format.returndesc(desc);
			xecho $format.returndesc(send_desc);
			xecho $acban this is your new describe format, /fsave to save.;
		}{
			xecho -b please make a valid selection.;
		};
	}{
		xdescform.show;
	};

};


alias xdescform.show {
	@:fni=format.numitems(desc);
	for (@mm=1, mm <= fni, @mm++) {
		xecho $format.returndesc(desc $mm);
		xecho $format.returndesc(send_desc $mm);
	};
	xecho $acban /format y <number> to set describe format;
	xecho $acban current format set to $theme.format.desc;
};
