 
#! /usr/bin/sh


printf 'Welcome to the Mutt-Wizard by Ky Nguyen\n'
printf 'can I Ask you your real name? ' 
IFS= read -r realname

echo -e "Hello " $realname
echo "Before the wizard generate config file, give the name for your mailbox: "
read path
mkdir ~/.mutt/$path/cache
touch ~/.mutt/$path/cache/headers
touch ~/.mutt/$path/cache/bodies
touch ~/.mutt/$path/${email}.signature
echo "okay " $path "created"
echo "Which email host you are using? "
read host

IMAP_PORT = 993
SMTP_PORT = 465

if [ $host == "gmail" ]
then
	printf "Type in your gmail account: "
	read email
	printf "Your in-App password: "
	read -s pass
	tee -a ~/.mutt/${path}/mail1 >/dev/null << END
    set imap_user =		'${email}@${host}.com'
	set imap_pass =		'${pass}'
	set smtp_url  =		'smtps://${email}@smtp.${host}.com:${SMTP_PORT}/'
	set smtp_pass =		'${pass}'
	set from =			'${email}@${host}.com'
	set realname =		'${realname}'
	set spoolfile = 	'+INBOX'
	set postponed =		'+[Gmail]Drafts'
	set header_cache =	~/.mutt/${path}/cache/headers
	set message_cachedir =	~/.mutt/${path}/cache/bodies
	set certificate_file =	~/.mutt/${path}/certificates
	set signature =		~/.mutt/${path}/${email}.signature
END
elif [ $host == "yahoo" ]
then
	printf "Type in your yahoo account: "
	read email
 	printf "Your in-App password: "
	read -s pass
	tee -a ~/.mutt/${path}/mail1 >/dev/null << END
   	set imap_user =		'${email}@${host}.com'
	set imap_pass =		'${pass}'
	set smtp_url  =		'smtps://${email}@smtp.mail.${host}.com:${SMTP_PORT}'
	set smtp_pass =		'${pass}'
	set from =			'${email}@${host}.com'
	set realname =		'${realname}'
	set spoolfile = 	'+INBOX'
	set postponed =		'+Drafts'
	set header_cache =	~/.mutt/${path}/cache/headers
	set message_cachedir =	~/.mutt/${path}/cache/bodies
	set certificate_file =	~/.mutt/${path}/certificates
	set signature =		~/.mutt/${path}/${email}.signature
END
fi

tee -a ~/.config/mutt/muttrc >/dev/null << END
# Import color for mutt
source ~/.config/mutt/color.muttrc

# Set editor
set editor = "vim"

# Initialize mailbox host
set folder = "imaps://imap.${email}.com:${IMAP_PORT}"

# General setting
set ssl_starttls = yes
set ssl_force_tls = yes
set sort = threads
set sort_browser = date
set sort_aux = reverse-last-date-received 
set imap_keepalive = 900
set imap_check_subscribed = yes
set ssl_starttls = yes
set ssl_force_tls = yes
set move = no
# Index setup
#set index_format = '%C\r%Z\r%{%D} %Fp %c %N %s'

# Key bindings
bind index,pager \Cp sidebar-prev
bind index,pager \Cn sidebar-next
bind index,pager \Co sidebar-open

# Sidebar setup
set sidebar_visible = yes
set sidebar_width = 30
set sidebar_short_path = yes 
set mail_check_stats = yes
set sidebar_sort_method = new
set sidebar_next_new_wrap = yes
set sidebar_folder_indent = yes
set sidebar_format = "%D%?F? [%F]?%* %N/%S" 
color sidebar_indicator white red
color sidebar_highlight white red
color sidebar_spoolfile green default

# Default account
source ~/.mutt/${path}/mail1

END

tee -a ~/.config/mutt/color.muttrc >/dev/null << END
# vim: filetype=neomuttrc
# Default index colors:
color index yellow default '.*'
color index_author white default '.*'
color index_number blue default
color index_subject cyan default '.*'

# For new mail:
color index brightyellow black "~N"
color index_author brightred black "~N"
color index_subject brightcyan black "~N"

# Header colors:
color header blue default ".*"
color header brightmagenta default "^(From)"
color header brightcyan default "^(Subject)"
color header brightwhite default "^(CC|BCC)"

mono bold bold
mono underline underline
mono indicator reverse
mono error bold
color normal default default
color indicator brightblack white
color sidebar_highlight red default
color sidebar_divider brightblack black
color sidebar_flagged red black
color sidebar_new green black
color normal brightyellow default
color error red default
color tilde black default
color message cyan default
color markers red white
color attachment white default
color search brightmagenta default
color status brightyellow black
color hdrdefault brightgreen default
color quoted green default
color quoted1 blue default
color quoted2 cyan default
color quoted3 yellow default
color quoted4 red default
color quoted5 brightred default
color signature brightgreen default
color bold black default
color underline black default
color normal default default

color body red default "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+" # Email addresses
color body brightblue default "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+" # URL
color body green default "\`[^\`]*\`" # Green text between ` and `
color body brightblue default "^# \.*" # Headings as bold blue
color body brightcyan default "^## \.*" # Subheadings as bold cyan
color body brightgreen default "^### \.*" # Subsubheadings as bold green
color body yellow default "^(\t| )*(-|\\*) \.*" # List items as yellow
color body brightcyan default "[;:][-o][)/(|]" # emoticons
color body brightcyan default "[;:][)(|]" # emoticons
color body brightcyan default "[ ][*][^*]*[*][ ]?" # more emoticon?
color body brightcyan default "[ ]?[*][^*]*[*][ ]" # more emoticon?
color body red default "(BAD signature)"
color body cyan default "(Good signature)"
color body brightblack default "^gpg: Good signature .*"
color body brightyellow default "^gpg: "
color body brightyellow red "^gpg: BAD signature from.*"
mono body bold "^gpg: Good signature"
mono body bold "^gpg: BAD signature from.*"
color body red default "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"

END

tee -a ~/.config/mutt/mailcap>/dev/null << END
# htmail-view w/o focus handling
#text/html; htmail-view file://%s; test=test -n "$DISPLAY"; nametemplate=%s.html; needsterminal;

# htmail-view w/ focus handling using wmctrl
text/html; /usr/lib/htmail-view/wmctrl-wrapper file://%s; test=test -n "$DISPLAY"; nametemplate=%s.html; needsterminal;
END
#sudo mv color.muttrc mailcap muttrc ~/.config/mutt
#sudo mv mail1 ~/.mutt/${path}/cache
echo "File generation is completed"

