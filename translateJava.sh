
#
# This Simple Script translate java source code by creating the CLASSPATH from all 
# JARs files found in the source code directory tree.
# 
#

SCAVALID=`which sourceanalyzer`
if [ $? -ne 0 ];
then
  echo "ERROR: sourceanalyzer is missing from your bin PATH directories."
  echo "FIX: set the PATH to the location of the installed bin directory for sourceanalyzer"
  exit 99
fi

if [ $# -gt 1 ];
then
  
  BUILD_ID=$1
  SOURCE_DIR=$2

  CLASSPATH=${SOURCE_DIR}:
  for jarfile in `find ${SOURCE_DIR} -name "*.jar" `
  do
    CLASSPATH="${CLASSPATH}:${jarfile}:"
  done

  sourceanalyzer -b ${BUILD_ID} -clean
  sourceanalyzer -b ${BUILD_ID} -verbose -logfile ${BUILD_ID}.log -debug -cp ${CLASSPATH} ${SOURCE_DIR}
  sourceanalyzer -b ${BUILD_ID} -make-mobile
  sourceanalyzer -b ${BUILD_ID} -export-build-session ${BUILD_ID}.mbs

else

  echo "usage translateJava.sh <BUILD ID> <Source Directory>"
  exit 1
fi


