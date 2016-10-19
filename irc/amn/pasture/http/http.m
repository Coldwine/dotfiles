# Copyright (c) 2003-2009 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# HTTP client library. Provides some useful commands for communicating with
# servers that speak HTTP. Written by skullY.
subpackage http

### Test for various client features we require.
# If we have xform then we can do base64 encoding for basic auth. While we're
# at it, let's make sure that urlencode works.
if ([$xform(URL E KEY +)]==[+]) {
	@_basicauth = 1
	alias urlquote {
		@ function_return = xform(URL E KEY $*)
	}
}{
	xecho -c -nolog $acban WARNING: Your version of epic does not have the neccesary function required for HTTP Basic Auth. You will be unable to authenticate with a web server.
	@_basicauth = 0
	alias urlquote {
		@ function_return = sar(g/+/%2b/$urlencode($url))
	}
}

### Useful functions
# _sendline: Send a line terminated with CRLF to the specified connection.
# Args: <DCC REFNUM> <Line>
alias _sendline {
	#msg =$0 $1$chr(13)
	xecho -b http: _sendline: $*
}

# _parseurl: Split the url into the hostname and path.
alias _parseurl {
	@ _urlparts = sar(g,/, ,$*)
	@ _hostport = sar(g,:, ,$word(1 $_urlparts))
	if (word(1 $_hostport)) {
		@ _host = word(0 $_hostport)
		@ _port = word(1 $_hostport)
	}{
		@ _host = _hostport
		@ _port = 80
	}
	@ _path = word(2 $_urlparts)
	@ function_return = [$_host $_port $_path]
}

### User exposed functions
# urlquote: Quotes a URL for use in an HTTP request. Assigned above.
#           This function is needed because early versions of epic don't
#           properly encode the + char.
# Args: <string to encode>

# httpget: Fetch a url.
# Args: <URL> [username] [pass]
alias httpget {
	@ _urlparts = _parseurl($0)
	#@ _conn = $connect($word(0 $_urlparts) $word(1 $_urlparts))
	@ _headers.1 = [Host: $word(0 $_urlparts)]
	@ _headers.2 = [Accept: text/*]
	@ _headers.3 = [User-Agent: ircII $J \($V\) [$info(i)] "$info(r)" $a.ver/$a.rel]
	@ _headers.4 = [Connection: Close]
	if ([$2] && _basicauth) {
		@ _headers.5 = [Authorization: BASIC $xform(B64 E KEY ${1}:${2}]
	}
	_sendline $_conn GET /$word(2 $_urlparts) HTTP/1.1
	foreach _headers xx {
		_sendline $_conn $_headers[$xx]
	}
	_sendline $_conn
}

alias httppost {
}

alias httpformpost {
}
