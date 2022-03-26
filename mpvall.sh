 

#!/bin/bash

# open files via mpv
# you need to install mpv first: brew install mpv
 

if  [ $# -eq 0 ]

then

echo 'usage: mpvall.sh <file>'

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

    mpv $line &

    if [[ $? -ne 0 ]]

        then

           # break
         echo !!! error skip $line
         echo   error skip $line > conv_error.log
    fi

 


    fi
    fi
done< /tmp/find_in_dir_temp
 
rm /tmp/find_in_dir_temp
