# NIM_etudes
etudes du language Nim-lang avec outils  <br />
  
**<u>fait avec GINTRO 0.8.0</u>**

Bonjour 

je voudrais remercier :  Stefan Salewski  

[GINTRO](http://ssalewski.de/gintroreadme.html)

toutes l'équipe du forum Nim
[https://forum.nim-lang.org/](https://forum.nim-lang.org/)

la documentation est très facile à lire 
[https://nim-lang.org/](https://nim-lang.org/)


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
[https://nimble.directory/](https://nimble.directory/)

[https://devdocs.io/](https://devdocs.io/)

[https://hackr.io/tutorials/learn-nim-lang](https://hackr.io/tutorials/learn-nim-lang)

[http://inti.sourceforge.net/tutorial/libinti/cwbuttonboxes.html](http://inti.sourceforge.net/tutorial/libinti/cwbuttonboxes.html)

https://zestedesavoir.com/tutoriels/870/des-interfaces-graphiques-en-python-et-gtk/1446_decouverte/5775_le-positionnement-grace-aux-layouts/     très bien expliqué good good 

[https://www.developpez.net/forums/d1825565/c-cpp/bibliotheques/gtkp/gtkp-c-cpp/gtktreeview-gtkscrolledwindow/](https://www.developpez.net/forums/d1825565/c-cpp/bibliotheques/gtkp/gtkp-c-cpp/gtktreeview-gtkscrolledwindow/)
very good 

je fini par le plus agréable 

un programme pour toutes les plateformes 
oui vous me direz il faut faire une installation à chaque system , mais c'est comme ça partout , bon pour nim-lang cela m'a pris 5 mn et encore .... GTK c'est plus compliquer mais maintenant on trouve facilement sur les sites GTK comment faire 

quand au base de données c'est strictement pareille <br />



**module**
- 1.[nim-decimal ](https://github.com/AS400JPLPC/nim_dcml) <br />

valide pour les traitemnt numerique industriel j'ai apporté des modifications pour la Gestion/compta/commercial....

**astuce**

ils sont le task.json du dossier .vscode<br />


**<u>pour NIM </u>**<br />

**<u>SRCBUILDER</u>**<br />
&rarr;&nbsp;converti GLADE xml -> src.inc  

****SRCCSS****<br />
&rarr;&nbsp;converti CSS -> src.inc <br />




 
**Programme**<br />



- 2.table.nim

[https://github.com/nim-lang/ui](https://github.com/nim-lang/ui)<br />

a été fait avec le projet ui <br />

je n'ai pas repris les exemples de la gallery ils fonctionnen et est assé simple<br />

il y a des avertissements dans le source verifiez si les corrections on été faites sinon appliquez les recommendations....<br />

- 3.biggtk.nim<br />

le choix est gintro gtk <br />
il devient professionel avec tables de déscisions<br /> 
à terme il devrait recouvrir la majeur parti des problèmes rencontrer pour la gestion interactif.<br />

ainsi que les problèmes les plus courant avec nim , regex , les string les tables .... et les decimal.....<br />



