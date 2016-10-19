alias joinform (number) {
	if (@number) {
		@format.setformat(join $number join);
	}{
		@format.printformats(join g join);
	};
};

alias leaveform (number) {
	if (@number) {
		@format.setformat(leave $number leave);
	}{
		@format.printformats(leave h leave);
	};
};

alias signform (number) {
	if (@number) {
		@format.setformat(signoff $number sign off);
	}{
		@format.printformats(signoff f sign off);
	};
};

