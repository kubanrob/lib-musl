#! /bin/bash

LIB=$1
ARCH=$2
BASE_SRC=`echo src/$LIB/*.c`
ARCH_SRC=`echo src/$LIB/$ARCH/*.[csS]`
BASE_SUB_SRC=`sed -r "s%/$ARCH/([^ ]*)\\.[csS]%/\\1.c%g" <(echo $ARCH_SRC)`

echo "# reset sources proviously added"
echo "LIBMUSL_${LIB^^}_SRCS-y ="
echo "# base sources (skips the ones replaced by $ARCH)"
for src in $BASE_SRC; do
  if [[ "$BASE_SUB_SRC" =~ "$src" ]] ; then
    echo "#LIBMUSL_${LIB^^}_SRCS-y += \$(LIBMUSL)/$src"
  else
    echo "LIBMUSL_${LIB^^}_SRCS-y += \$(LIBMUSL)/$src"
  fi
done
echo "# $ARCH specific sources"
for src in $ARCH_SRC; do
  echo "LIBMUSL_${LIB^^}_SRCS-y += \$(LIBMUSL)/$src|$ARCH"
done
