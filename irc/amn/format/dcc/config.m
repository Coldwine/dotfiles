alias sdcform (number) {
	if (@number) {
		@format.setformat(send_dcc_chat $number send dcc chat);
	}{
		@format.printformats(send_dcc_chat l send dcc chat);
	};
};

alias dcform (number) {
	if (@number) {
		@format.setformat(dcc_chat $number dcc chat);
	}{
		@format.printformats(dcc_chat m dcc chat);
	};
};
