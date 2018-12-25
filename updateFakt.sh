#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. $DIR/local.config


aDate=`date +%F`
aTime=`date +%+65H:%M:%S`


clear

#rozpakowanie paczki
echo "Rozpakowywanie plików"
unzip $fileSource/$packName -d $source
#echo $fileSource/$packName -d $source

echo "Zasilenie bazy"
# KONT	Opis kontrahenta

tableName='kont.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=17 $tmp/$tableName | sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

# ZAKU	Nag³ówki dokumentów zakupu

tableName='zaku.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName | $home/convdate.sh col=12 | $home/convdate.sh col=14 | sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

# FAKT	Nag³ówki dokumentów sprzeda¿y

tableName='fakt.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName | $home/convdate.sh col=9 | sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new


# POZC	Pozycje z dokumentu sprzeda¿y

tableName='pozc.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName |  sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

# ZPOZ	Pozycje z dokumentów zakupu

tableName='zpoz.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName | $home/convdate.sh col=14 | sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

# TOWA	Opisy towarów i us³ug

tableName='towa.txt'
iconv -f WINDOWS-1250 -t  iso-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=19 $tmp/$tableName | sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

# KASA	Dokumenty kasowe i bankowe

tableName='kasa.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName | $home/convdate.sh col=9 | sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

# KASA	Powi¹zania dokumentów kasowych i bankowych

tableName='spin.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName | sed -e '1d' | $home/convspin.sh col=3 | $home/convspin.sh col=6 > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

echo "Usuniêcie plików zrodlowych"

rm $source/*.*
