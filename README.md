# NIM_etudes
etudes du language Nim-lang avec outils

Bonjour 

je vous part de mon expérience (très jeune ) de NIM-lang

https://nim-lang.org/


l’installation :

le plus simple :

 
si vous êtes sur Linnux:

curl https://nim-lang.org/choosenim/init.sh -sSf | sh

pour vos test il n’y a pas mieux …  rien ne vous empêchera par la suite de faire une installation system.



Puis : nimble list -i

nimble install c2nim // pour les conversions .c,.h … vers .nim

pour l’IDE je vais dir plutôt un éditeur de textes


visual studio-Code  allez le prendre sur un snap il sera à part et vous pourrez le mettre à jour facilement 

https://snapcraft.io/vscode


choisir les plugins …. important par exemple :
nim pour travailler agréablement 

    "files.associations": {
        "*.nim": "nim",
        "*.inc": "nim",
        
    },
    
    pour l’indentation et vis versa

indent on space






commande runner pour faire vos compilations ect 
dans le settings.json

    "command-runner.commands": {
        "Glade": "/usr/bin/glade $fileName",
        "Nim-Debug":"./compile.sh DEBUG $fileName",
        "Nim-Release":"./compile.sh PROD $fileName",
        "RUN-NIM":"./$fileName",
        "GLADE-conv":"$HOME/T_LIB/srcbuildnim -p $dir -f $fileName",
        "CSS-conv":"$HOME/T_LIB/srccssnim -p $dir -f $fileNameWithoutExt"
    }

run terminal commande :

cela vous permettra de coller une commande(s) :
 "runTerminalCommand.commands": [
        {
            "command": "grep -B2 gtk_builder_new_from_string ~/.nimble/pkgs/gintro-0.5.5/gintro/*",
            "name": "GREP-GTK"
        }
    ]


bien utile pour faire la transcription GTK / c  en GTK nim  avec Gintro 

de quoi vous mettre l’eau à la bouche :

http://ssalewski.de/gintroreadme.html

rainbowHighlighter 

vous permet de repairer facilement toutes les variables …. 

open Multifiles :
pour avoir plusieurs fichiers ouvert comme des onglets …. 

ça devient sympathique ;) 



