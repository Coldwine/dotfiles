alias mform (number) {
	if (@number) {
		@format.setformat(msg $number msg);
	}{
		@format.printformats(msg a msg);
	};
};

alias smform (number) {
	if (@number) {
		@format.setformat(send_msg $number send msg);
	}{
		@format.printformats(send_msg b send msg);
	};
};
