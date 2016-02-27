#! /bin/sh
## fvim: finds files and opens them in vim
#I use this little script. If we find an exact match (wc -l = 1), i open the file in vim. If I find more than one matches, open a list of the files. Then I can use 'gf' (gotofile) in vim to open the specific file.
listfile=/tmp/fvim.tmp

## Find files and store them in a list
find . -iname "$1" > $listfile

findcount=`cat $listfile | wc -l`
if [ $findcount -ge 2 ] ; then
 vim $listfile
else
 vim `cat $listfile`
fi
