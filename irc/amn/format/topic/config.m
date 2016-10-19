alias topform (number) {
	if (@number) {
		fe (topic notopic settopic topicby) cf {
			if (! format.loaditem($cf $number) ) {
				xecho -b please make a valid selection.;
				return;
			};
		};
		fe (topic notopic settopic topicby) cf {
			xecho $format.returndesc($cf);
		};

		xecho $acban this is your new topic format, /fsave to save.;

	}{
		@:fni=format.numitems(topic);
		for (@mm=1, mm <= fni, @mm++) {
				fe (topic notopic settopic topicby) cf {
					if (cf == 'topic') {
						xecho $cparse(%K[%n$mm%K]%n) $format.fshow($cf $mm $cf $format.readitem($cf DESC));
					}{
						xecho     $format.fshow($cf $mm $cf $format.readitem($cf DESC));
					};
				};
		};
		xecho $acban /format n <number> to set topic format;
		xecho $acban current format set to $theme.format.topic;
	};
};

