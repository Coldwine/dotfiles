alias ncomp (number) {
	if (@number) {
		if (format.loaditem(nick_comp $number)) {
			xecho $Cparse("%K<%ncrapple%K>%n") kreca$format.fshow(nick_comp $number) hi!;
			xecho $acban this is your new nick completion format, /fsave to save.;
			return 1;
		}{
			xecho -b please make a valid selection.;
			return 0;
		};
		
	}{
		fe ($jot(1 $format.numitems(nick_comp))) aa { 
		xecho $Cparse("%K[%n$([2]aa)%K]%n %K<%ncrapple%K>%n") kreca$format.fshow(nick_comp $aa) hi!
		};
		xecho $acban /format r <number> to set nick completion;
		xecho $acban current format set to $theme.format.nick_comp;
	};
};



alias nickform (number) {
	if (@number) {
		@format.setformat(nickname $number nick change);
	}{
		@format.printformats(nickname u nick change);
	};
};

