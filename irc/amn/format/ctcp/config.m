alias ctcpform (number) {
	if (@number) {
		@format.setformat(ctcp $number ctcp);
	}{
		@format.printformats(ctcp o ctcp);
	};
};

alias ctcprform (number) {
	if (@number) {
		@format.setformat(ctcp_reply $number ctcp reply);
	}{
		@format.printformats(ctcp_reply 5 ctcp reply);
	};
};

alias sctcpform (number) {
	if (@number) {
		@format.setformat(send_ctcp $number send ctcp);
	}{
		@format.printformats(send_ctcp p send ctcp);
	};
};
