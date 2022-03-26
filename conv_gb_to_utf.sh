 

#!/bin/bash

#批量转换gb2312到utf-8

 

if  [ $# -eq 0 ]

then

echo 'usage: conv.sh <file>'

exit

fi

echo $# files

#clear

echo "" > /tmp/find_in_dir_temp

for param in "$@"

do

#echo "$param"

    find . -name $param >> /tmp/find_in_dir_temp

done

cat /tmp/find_in_dir_temp

 

while read line

do

    echo convert $line

    if [[ -n $line ]]

    then

    if [ -f $line  ]

     then

    iconv -c -f gb2312 -t utf-8 $line > /tmp/ff

    if [[ $? -ne 0 ]]

        then

           # break
         echo !!! error skip $line
         echo   error skip $line > conv_error.log
    fi

 
    mv /tmp/ff $line".8"
#    mv $line $line".old"

#    mv /tmp/ff $line

    fi
    fi
done< /tmp/find_in_dir_temp
 
