#!/bin/bash

faStabilo='\033[7m'
fcRouge='\033[31m'
fcJaune='\033[33;1m'
fcCyan='\033[36m'
fcGreen='\033[32m'


#-------------------------------------------------------------------
# ccontrôle si projet nim
#-------------------------------------------------------------------
if [[ ! "$2" =~ '.nim' ]]; then
echo -en $faStabilo$fcJaune"$2 -->"$faStabilo$fcRouge"ce n'est pas un fichier .nim \033[0;0m\\n"
exit 0 
fi



mode=$1

projet_src=$2

projet_bin=${projet_src%.*}


#-------------------------------------------------------------------
# clean
#-------------------------------------------------------------------
if test -f $projet_bin ; then
	rm -f $projet_bin
fi

#-------------------------------------------------------------------
# compile
#-------------------------------------------------------------------
# force full option gtk
# debug
# nim  c --threads --passc:-flto --deadCodeElim:on -d:danger   -d:forceGtk   -o:$projet_bin   $projet_src
# prod
# nim  c  --verbosity:0 --hints:off --opt:size --threads --passc:-flto --deadCodeElim:on -d:danger  -d:forceGtk -d:release  -o:$projet_bin   $projet_src
# --passL:-no-pie  bin executable   par defaut -pie compilateur gcc and nim 


if [ "$mode" == "DEBUG" ] ; then 
	nim  c  -f --deadCodeElim:on  --app:GUI --passL:-no-pie -o:$projet_bin   $projet_src
fi

if [ "$mode" == "PROD" ] ; then  
	nim  c  --verbosity:0 --hints:off  --deadCodeElim:on --app:GUI  --passc:-flto -d:release -f -o:$projet_bin   $projet_src
fi

if [ "$mode" == "TEST" ] ; then  
	nim  c -f -o:$projet_bin   $projet_src
fi
#-------------------------------------------------------------------
# resultat
#-------------------------------------------------------------------

	echo -en '\033[0;0m'	# video normal
	echo " "
	if test -f "$projet_bin"; then
		echo -en $faStabilo$fcCyan"BUILD "$mode"\033[0;0m  "$fcJaune$projet_src"->\033[0;0m  "$fcGreen $projet_bin "\033[0;0m"
		echo -en "  size : " 
		ls -lrtsh $projet_bin | cut -d " " -f6
	else
		echo -en $faStabilo$fcCyan"BUILD "$mode"\033[0;0m  "$fcJaune$projet_src"->\033[0;0m  "$faStabilo$fcRouge"not compile\033[0;0m\n"
	fi
	echo " "

	if [ "$mode" == "TEST" ] ; then
		if test -f "$projet_bin"; then  
			echo "..TEST.. "
			echo " "
			./$projet_bin
			echo " "
		fi
fi
exit