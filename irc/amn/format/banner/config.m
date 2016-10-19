alias format.loadbanner (number,void){
	@:rv=format.loaditemfromfile(banner $number);
	^set banner $fparse(format_banner);
	return $rv;
};

alias echostr (number) {
	if (@number) {
		@format.setformat(banner $number banner);
	}{
		fe ($jot(1 $format.numitems(banner))) aa bb cc dd { 
			//echo $cparse(%K[%w$[2]aa%K]%n $format.fshow(banner $aa)    %K[%w$[2]bb%K]%n $format.fshow(banner $bb)    %K[%w$[2]cc%K]%n $format.fshow(banner $cc)    %K[%w$[2]dd%K]%n $format.fshow(banner $dd));
		};
		xecho $acban /format q <number> to set banner;
		xecho $acban current format set to $theme.format.banner;
	};
};
