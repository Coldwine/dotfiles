alias notform (number) {
	if (@number) {
		@format.setformat(notice $number notice);
	}{
		@format.printformats(notice j notice);
	};
};

alias snotform (number) {
	if (@number) {
		@format.setformat(send_notice $number send notice);
	}{
		@format.printformats(send_notice k send notice);
	};
};

alias pubnotform (number) {
	if (@number) {
		@format.setformat(public_notice $number public notice);
	}{
		@format.printformats(public_notice z public notice);
	};
};
