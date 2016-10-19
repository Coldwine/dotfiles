alias pubform (number) {
	if (@number) {
		@format.setformat(public $number public);
	}{
		@format.printformats(public c public);
	};
};

alias spubform (number) {
	if (@number) {
		@format.setformat(send_public $number send public);
	}{
		@format.printformats(send_public d send public);
	};
};

alias puboform (number) {
	if (@number) {
		@format.setformat(public_other $number public other);
	}{
		@format.printformats(public_other e public other);
	};
};

