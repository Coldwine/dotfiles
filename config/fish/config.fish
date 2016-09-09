source /usr/local/share/autojump/autojump.fish

set -gx LANG en_GB.UTF-8
set -gx MAVEN_OPTS '-Xms512m -Xmx512m -XX:MaxPermSize=256m'
set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
set -gx M2_HOME ~/Projects/cb/apache-maven-3.3.9
set -gx OPENSSL_INCLUDE_DIR /usr/local/opt/openssl/include
set -gx OPENSSL_ROOT_DIR /usr/local/opt/openssl
set -gx FZF_DEFAULT_COMMAND 'ag -g ""'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx NVIM_TUI_ENABLE_CURSOR_SHAPE 1
set -gx FZF_DEFAULT_OPTS '--color fg:242,bg:-1,hl:65,fg+:15,bg+:-1,hl+:65,info:108,prompt:109,spinner:108,pointer:168,marker:168'
