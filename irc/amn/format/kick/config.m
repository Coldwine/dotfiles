alias kickform (number) {
	if (@number) {
		@format.setformat(kick $number kick);
	}{
		@format.printformats(kick 4 kick);
	};
};
