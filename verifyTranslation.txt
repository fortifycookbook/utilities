
#
# Find all Files that could be translated by Fortify
#

function checktranslation()
{
  #echo "DEBUG: checking: $fileext"
  for filesrc in `find .  -name "*${fileext}"`
  do
   basepath=`echo $filesrc | cut -c3-`
   grep $basepath  ${TMPFILE} > foo
   if [ $? = 0 ];
   then
    foo=foo
   else
    echo "SCA Source File Not Translates: ($filesrc)"
   fi
  done
}


TMPFILE="`pwd`/scaTranslated.tmp"
SCACMD=`which sourceanalyzer `
SCAConfigDir=`echo ${SCACMD}  | sed 's;bin/sourceanalyzer;Core/config;'`
FortifyConfigFile="${SCAConfigDir}/fortify-sca.properties"

BUILDID=$1
SOURCEDIR=$2

if [ $# -gt 1 ];
then
 if [ ! -d ${SOURCEDIR} ];
 then
  echo "ERROR: Source not found ! Verify it exists and is readable"
  exit 1
 fi

 if [ -r "$FortifyConfigFile" ];
 then

  $SCACMD -b ${BUILDID} -show-files > ${TMPFILE}
  cd ${SOURCEDIR}

#  for fileext in `grep com.fortify.sca.fileextensions $FortifyConfigFile | cut -f1 -d" " | sed 's;com.fortify.sca.fileextensions;;' | sort | uniq`

  scafileext=`grep com.fortify.sca.DefaultFileTypes $FortifyConfigFile`
  cnt=1
  fileext=`echo  ${scafileext} | cut -d= -f2 |  cut -d, -f1 `
  while true
  do
   cnt=`expr $cnt + 1`
   if [ "$fileext" != "" ];
   then
    # echo "DEBUG: ($fileext)"
      #
      # Find All potential files that can be translated.
      #
    checktranslation
    fileext=`echo  ${scafileext} | cut -d\, -f${cnt}`
   else
    exit 0

   fi


  done

 else

 echo "ERROR:  Fortify Config File not Found at: ($FortifyConfigFile)"
 echo "Verify that sourceanalyzer is install and in your PATH . "
 exit 2

 fi

else

echo "Usage:  verifyTranalation.sh <SCA BUILD ID> <Source Code Dir>"
exit 99

fi
