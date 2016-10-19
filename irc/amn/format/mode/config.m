alias modeform (number) {
	if (@number) {
		@format.setformat(mode $number mode);
	}{
		@format.printformats(mode i mode);
	};
};
