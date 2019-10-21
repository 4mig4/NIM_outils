#!/bin/bash

faStabilo='\033[7m'
fcRouge='\033[31m'
fcJaune='\033[33;1m'
fcCyan='\033[36m'


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
# nim  c --threads --passC:-flto --deadCodeElim:on -d:danger   -d:forceGtk   -o:$projet_bin   $projet_src
# prod
# nim  c  --verbosity:0 --hints:off --opt:size --threads --passC:-flto --deadCodeElim:on -d:danger  -d:forceGtk -d:release  -o:$projet_bin   $projet_src



if [ "$mode" == "DEBUG" ] ; then 
	nim  c  -f --deadCodeElim:on   -o:$projet_bin   $projet_src
fi

if [ "$mode" == "PROD" ] ; then  
	nim  c  --verbosity:0 --hints:off  --opt:size  --deadCodeElim:on -d:release -f  -o:$projet_bin   $projet_src
fi

#-------------------------------------------------------------------
# resultat
#-------------------------------------------------------------------

	echo -en '\033[0;0m'	# video normal
	
	if test -f "$projet_bin"; then
		echo -en $faStabilo$fcCyan"BUILD $mode "$faStabilo$fcJaune"$projet_src -> $projet_bin\033[0;0m"
		echo -en "  octet : " 
		wc -c $projet_bin
	else
		echo -en $faStabilo$fcRouge"BUILD $mode "$faStabilo$fcJaune"$projet_src -> ERROR\033[0;0m\n"
	fi
exit