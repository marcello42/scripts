#!/bin/sh
clear
cp ~/.local/share/qutebrowser/webengine/Cookies /tmp

sqlite3 /tmp/Cookies << SQL
.output /tmp/cookies.txt
.separator '	'
SELECT
    host_key
  , 'TRUE'
  , path
  , iif(is_secure, 'TRUE', 'FALSE')
  , expires_utc
  , name
  , value 

FROM cookies 
WHERE host_key LIKE '.%'

UNION

SELECT 
    '.'||host_key AS host_key
  , 'TRUE'
  , path
  , iif(is_secure, 'TRUE', 'FALSE')
  , expires_utc
  , name
  , value 

FROM cookies 
WHERE host_key NOT LIKE '.%';

SQL
sed -i '1s/^/# Netscape HTTP Cookie File\n/' /tmp/cookies.txt
rm /tmp/Cookies

read -p 'Path to output file? [~/.local/share/qutebrowser/webengine/] ' outputpath

if [ -z $outputpath ]
then export outputpath=~/.local/share/qutebrowser/webengine/
else
mv /tmp/cookies.txt $outputpath
fi

echo 'wrote file cookie.txt to' $outputpath
exit 0
