#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. $DIR/local.config


aDate=`date +%F`
aTime=`date +%+65H:%M:%S`


clear

#rozpakowanie paczki
echo "Rozpakowywanie plik�w"
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

# ZAKU	Nag��wki dokument�w zakupu

tableName='zaku.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName | $home/convdate.sh col=12 | $home/convdate.sh col=14 | sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

# FAKT	Nag��wki dokument�w sprzeda�y

tableName='fakt.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName | $home/convdate.sh col=9 | sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new


# POZC	Pozycje z dokumentu sprzeda�y

tableName='pozc.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName |  sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

# ZPOZ	Pozycje z dokument�w zakupu

tableName='zpoz.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName | $home/convdate.sh col=14 | sed -e '1d' > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

# TOWA	Opisy towar�w i us�ug

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

# KASA	Powi�zania dokument�w kasowych i bankowych

tableName='spin.txt'
iconv -f WINDOWS-1250 -t  ISO-8859-2 $source/$tableName > $tmp/$tableName
$home/convdate.sh col=1 $tmp/$tableName | sed -e '1d' | $home/convspin.sh col=3 | $home/convspin.sh col=6 > $tmp/$tableName.new
rm $tmp/$tableName
mysqlimport --delete --fields-terminated-by=';' --fields-optionally-enclosed-by='"' --host=$dbHost --lines-terminated-by="\r\n" --ignore-lines=1 --password=$dbPass --user=$dbUser $dbName $tmp/$tableName.new
rm $tmp/$tableName.new

echo "Usuni�cie plik�w zrodlowych"

rm $source/*.*
