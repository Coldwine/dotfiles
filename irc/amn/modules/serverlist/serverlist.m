# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};
alias servload {
};
alias servsave {
	@rename($(savepath)servergroups.conf $(savepath)servergroups.conf~);
        @savemt = open($(savepath)servergroups.conf W T);
        @write($savemt ** amnesiac servergroups file - saved $strftime($time() %D %T));
	fe ($serverctl(ALLGROUPS)) cg {
        	@write($savemt [$cg]);
		@:refs=serverctl(GMATCH $cg);
		fe ($refs) cr {
			@:desc=serverctl(GET $cr FULLDESC);
			echo $desc;
			@:sname=before(: $desc);
			@:port=before(: $after(1 : $desc));
			if (@port && port!=6667) {
				@port=":$port";
			}{
				@port="";
			};
			@mstr="$sname$port";
			fe (pass.2 nick.3 type.5 proto.6 vhost.7) cc {
				@:cur=after($after(. $cc) : $desc);
				@cur=before(: $cur);
				if (@cur) {
					@mstr #= ":$before(. $cc)=$cur";
				};
			};

			@write($savemt $mstr);
		};
	};
	@close($savemt);
};
