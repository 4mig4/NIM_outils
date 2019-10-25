# NIM_etudes
etudes du language Nim-lang avec outils

Bonjour 

je voudrais remercier :  Stefan Salewski  
effectivement ilest simple d'écrire le designe à la main et sans warning ;)

http://ssalewski.de/gintroreadme.html

et toutes l'équipe du forum Nim
https://forum.nim-lang.org/

la documentation est très facile à lire 
https://nim-lang.org/


j'ai beaucoup regardé ce qui ce faisait un peu partout
et comment aborder le passage à Nim-lang

Nim-lang me parrait un excellent compromis , tant sur la fiabilité , que sur la circonsision du language 
pour ceux qui viennent du c/c++ ou pascal voir python il n'auront aucun problème de compréhention.

j'ai aussi parfois galéré pour faire l'analogie entre mes habitudes et Nim-lang
par exemple comment faire une structure multidimentions et naviguer dedans 
 mais cela ma obligé à fouiller sérieusement 

d'autre part j'ai testé beaucoup de produit pour travailler en interactif (GUI) et pas une heures mais des heures pour faire un bon choix.
pour moi le plus honnêtement possible c'est Gintro  GTK3/4 à la sauce Nim-lang

j'ai été très surpris par la simplicité même si ce n'est pas évident la translation

en travaillant j'ai compris l'intérets d'avoir des macros (hélas je n'ai pas fait dans mon exemple cela viendra ;) )

j'ai déposé mes outils pour facilité le travail.... 
quelque adresse utiles:
https://nimble.directory/

https://devdocs.io/

https://hackr.io/tutorials/learn-nim-lang

http://inti.sourceforge.net/tutorial/libinti/cwbuttonboxes.html

https://zestedesavoir.com/tutoriels/870/des-interfaces-graphiques-en-python-et-gtk/1446_decouverte/5775_le-positionnement-grace-aux-layouts/     très bien expliqué good good 

https://www.developpez.net/forums/d1825565/c-cpp/bibliotheques/gtkp/gtkp-c-cpp/gtktreeview-gtkscrolledwindow/
very good 

je fini par le plus agréable 

un programme pour toutes les plateformes 
oui vous me direz il faut faire une installation à chaque system , mais c'est comme ça partout , bon pour nim-lang cela m'a pris 5 mn et encore .... GTK c'est plus compliquer mais maintenant on trouve facilement sur les sites GTK comment faire 

quand au base de données c'est strictement pareille 

ne pas confondre environnement de développeur et utilisateur 2 installations différentes 
# module
- 1.nim-decimal 

valide pour les traitemnt numerique industriel j'ai apporté des modifications pour la Gestion/compta/commercial....

# astuce
- 1.dans vs-code  avec le plugin  runTerminalCommand

cela vous aidera pour la translation en nim-code de GTK dans une fenetre 
  
"runTerminalCommand.commands": [
        {
            "command": "xfce4-terminal --title=GREP --hold --geometry 160x20 --zoom=2 -e '/home/soleil/NIM/MYGTK/grep_gtknim.sh ?*'",
            "name": "GREP-GTK"
        }
    ],



 
# Programme

j'avais besoin de me rendre compte pour savoir comment et le temps que cela prends pour developper

le 1° c'est une question de translation pour retrouver les ordres

après ce n'est que de la logique pour les methodes de contrôle

il offre une grande palette de fonction qui permette de titiller finement  

le 2° c'est l'apprentissage d'ordre

il s'appuit aussi sur gtk3 comme le premier 

la simplicité il ne reste que les methodes de contrôle  

- 1.manuel.nim

https://github.com/StefanSalewski/gintro

a été fait avec Gintro

aucun problème 

il comprends la sasie dans la table et dans un masque  


- 2.table.nim

https://github.com/nim-lang/ui

a été fait avec le projet ui 

je n'ai pas repris les exemple de la gallery il fonctionne et est assé simple

il y a des avertissements dans le source verifiez si les corrections on été faites sinon appliquez les recommendations.... 

