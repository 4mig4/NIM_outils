#-----------------------------------------
# test apprentissage NIM-lang and GTK3
# démarer le lundi 07/10/2019
# premier jet le 1/10/2019 cohérent
#
# en attente 
# faire une requete sqlite voir postgresql
# une fenêtre modal
# un appel execv ou un call de programme 
# une communication entre programme de type <sys/msg.h>
# les thread <sys/shm.h>
# les traitement de signaux <signal.h>
# et les exceptions
#
#-----------------------------------------
import gintro/[glib, gobject, gtk , gdk]
import gintro/gio except ListStore
 

import strutils
import strformat



const 
  col_id = 0
  col_nom = 1
  col_prenom = 2
  col_age = 3
  Color1 = 4
  Color2 = 5
  Columns = 6

type Person = object
  nom: string
  prenom: string
  age: int

var personList = newSeq[Person]()
personList.add(Person(nom: "Koch", prenom:"karl", age: 23))
personList.add(Person(nom: "Pan", prenom:"Peter", age: 12))
personList.add(Person(nom: "Rouge", prenom:"JP", age: 68))
personList.add(Person(nom: "Moranne", prenom:"Bob", age: 30))
personList.add(Person(nom: "Naruto", prenom:"Konoan", age: 23))
personList.add(Person(nom: "Lion", prenom:"Afrique", age: 15))
personList.add(Person(nom: "Aigle", prenom:"Noir", age: 40))
personList.add(Person(nom: "Pierre", prenom:"Precieuse", age: 30))

var gSFLine : TreeView
var gListStore : ListStore
var svPath: string
var ind_Selection : bool = false

var e_Nom : Entry
var e_Prenom : Entry
var e_Age : Entry

#----------------------------
# Fonction
#----------------------------


proc toStringVal(s: string): Value =
  let gtype = typeFromName("gchararray")
  discard init(result, gtype)
  setString(result, s)

proc toUIntVal(i: int): Value =
  let gtype = typeFromName("guint")
  discard init(result, gtype)
  setUint(result, i)

proc toBoolVal(b: bool): Value =
  let gtype = typeFromName("gboolean")
  discard init(result, gtype)
  setBoolean(result, b)


#----------------------------------
# declaration Procedure UPDATE SFL
#----------------------------------

proc p_UpdateRow(pRenderer: CellRendererText;pPath: cstring; pNewText: cstring; pColumn :TreeViewColumn )

proc p_GetRowData(pViewTree: TreeView; pPath: TreePath; pColumn: TreeViewColumn)

proc p_SetRowData(b: Button)

proc p_Cancel(b: Button; pSelection: TreeSelection)

proc p_AddRowData(b: Button)

proc p_Delete(b: Button, pSelection: TreeSelection) 


#----------------------------
#Procedure Exit
#---------------------------
proc p_quitApp(b: Button; app: Application) =
  echo "Bye"
  quit(app)




#----------------------------
#Procedure Principal
#----------------------------
proc p_appActivate(app: Application) =

  include "./css_global.inc"

  let l_Nom = newLabel("Nom")
  let l_Prenom = newLabel("Prénom")
  let l_Age= newLabel("âge")

  e_Nom = newEntry()
  e_Prenom = newEntry()
  e_Age = newEntry()

  let  b_Exit = newButton("EXIT")

  let  b_Update = newButton("UPDATE")
  let  b_Cancel = newButton("CANCEL")
  let  b_Add = newButton("ADD")
  let  b_Del = newButton("DEL")



  var  context: StyleContext



#----------------------------
# field
#----------------------------
  l_Nom.setWidthChars(30)
  context = getStyleContext(l_Nom)
  context.addClass("label")





  e_Nom.set_name("e_Nom")
  e_Nom.setWidthChars(30)
  e_Nom.setMaxLength(30)
  context = getStyleContext(e_Nom)
  context.addClass("entry")


  l_Prenom.setWidthChars(30)
  context = getStyleContext(l_Prenom)
  context.addClass("label")

  e_Prenom.set_name("e_Prenom")
  e_Prenom.setWidthChars(30)
  e_Prenom.setMaxLength(30)
  context = getStyleContext(e_Prenom)
  context.addClass("entry")

  l_Age.setWidthChars(3)
  context = getStyleContext(l_Age)
  context.addClass("label")

  e_Age.set_name("e_Age")
  e_Age.setWidthChars(3)
  e_Age.setMaxLength(3)
  context = getStyleContext(e_Age)
  context.addClass("entry")


#----------------------------
# button 
#----------------------------
  b_Exit.set_name("b_Exit")
  context = getStyleContext(b_Exit)
  context.addClass("button")

  b_Update.set_name("b_Update")
  context = getStyleContext(b_Update)
  context.addClass("button")

  b_Cancel.set_name("b_Cancel")
  context = getStyleContext(b_Cancel)
  context.addClass("button")

  b_Add.set_name("b_Add")
  context = getStyleContext(b_Add)
  context.addClass("button")
  b_Del.set_name("b_Del")
  context = getStyleContext(b_Del)
  context.addClass("button")



#--------------------------------------
# define SFLINE 
# liststore or tabeau display ;)
#--------------------------------------
  var h = [typeFromName("guint"), typeFromName("gchararray"), typeFromName("gchararray"),typeFromName("guint"), typeFromName("gchararray"),typeFromName("gchararray")]

  gListStore = newListStore(Columns,  cast[pointer]( unsafeaddr h)) # cast is ugly, we should fix it in bindings.

#--------------------------------------
# chargement data SFLine
#--------------------------------------
  for i in low(personList)..high(personList):
    var gIter: TreeIter
    gListStore.append(gIter) # currently we have to use setValue() as there is no varargs proc as in C original
    
    gListStore.setValue(gIter, col_id,  toUIntVal(i + 1))
    gListStore.setValue(gIter, col_nom, toStringVal(personList[i].nom))
    gListStore.setValue(gIter, col_prenom, toStringVal(personList[i].prenom))
    gListStore.setValue(gIter, col_age,  toUIntVal(personList[i].age))
    gListStore.setValue(gIter, Color1, toStringVal("DarkSeaGreen"))

    if ( i mod 2  == 0):
      gListStore.setValue(gIter, Color2, toStringVal("Azure"))
    else :
      gListStore.setValue(gIter, Color2, toStringVal("Beige"))


#--------------------------------------
# define SFLINE 
# Model
#--------------------------------------

  gSFLine  = newTreeViewWithModel(gListStore)
  gSFLine.setHexpand
  gSFLine.setVexpand
  gSFLine.setProperty("activate-on-single-click", toBoolVal(true))
  context = getStyleContext(gSFLine)
  context.addClass("treeview")

  var gSelection:TreeSelection = gSFLine.getSelection()
  gSelection.setMode(SelectionMode.single)



#--------------------------------------
# define Column
# define CellRenderer
# calback row.... 
#--------------------------------------
  var coln_1 = newTreeViewColumn()
  var renderer_1 = newCellRendererText()


  var coln_2 = newTreeViewColumn()
  var renderer_2  = newCellRendererText()
  setProperty(renderer_2 , "editable", toBoolVal(true))
  connect(renderer_2, "edited", p_UpdateRow, coln_2)

  var coln_3 = newTreeViewColumn()
  var renderer_3  = newCellRendererText()
  setProperty(renderer_3 , "editable", toBoolVal(true))
  connect(renderer_3, "edited", p_UpdateRow, coln_3)
  
  var coln_4 = newTreeViewColumn()
  var renderer_4  = newCellRendererText()
  setProperty(renderer_4 , "editable", toBoolVal(true))
  connect(renderer_4, "edited", p_UpdateRow, coln_4)

  connect(gSFLine, "row-activated", p_GetRowData)
#---------------------------------------------------------------------------------------
# Bind the Color column to the "cell-background" property.
# calcul width  police monospace 20 font-size 2mm  setFixedWidth=((nombr_car +1) * 12)
# ex: 3car + 1 tampon * 12 = 48 
#-------------------------

  coln_1.setTitle("ID")
  coln_1.packStart(renderer_1, true)
  coln_1.addAttribute(renderer_1, "text", col_id)
  coln_1.addAttribute(renderer_1, "cell-background", Color1)
  coln_1.setFixedWidth(48)
  discard gSFLine.appendColumn(coln_1)

  coln_2.setTitle("NOM")
  coln_2.packStart(renderer_2, true)
  coln_2.addAttribute(renderer_2, "text", col_nom)
  coln_2.addAttribute(renderer_2, "cell-background", Color2)
  coln_2.setFixedWidth(372)
  discard gSFLine.appendColumn(coln_2)

  coln_3.setTitle("PRENOM")
  coln_3.packStart(renderer_3, true)
  coln_3.addAttribute(renderer_3, "text", col_prenom)
  coln_3.addAttribute(renderer_3, "cell-background", Color2)
  coln_3.setFixedWidth(372)
  discard gSFLine.appendColumn(coln_3)

  coln_4.setTitle("AGE")
  coln_4.packStart(renderer_4, true)
  coln_4.addAttribute(renderer_4, "text", col_age)
  coln_4.addAttribute(renderer_4, "cell-background", Color2)
  coln_4.setFixedWidth(48)
  discard gSFLine.appendColumn(coln_4)


#---------------------------------------
# Ajout barres de défilement  ScrollBar
#---------------------------------------
  let gScrollbar  = newScrolledWindow()
  gScrollbar.setPolicy(automatic, automatic)
  gScrollbar.add(gSFLine)




#----------------------------
# Form Formulaire
#----------------------------
  let  gridA = newGrid()
  gridA.attach(l_Nom, 0, 0, 1, 1)
  gridA.attach(l_Prenom, 1, 0, 1, 1)
  gridA.attach(l_Age, 2, 0, 1, 1)
  gridA.attach(e_Nom, 0, 1, 1, 1)
  gridA.attach(e_Prenom, 1, 1, 1, 1)
  gridA.attach(e_Age, 2, 1, 1, 1)
  gridA.setColumnSpacing(30)

#----------------------------
# Form button
#----------------------------
  let  butonBox = newButtonBox(Orientation.horizontal)
  butonBox.setLayout(spread )
  butonBox.add(b_Exit)
  butonBox.add(b_Update)
  butonBox.add(b_Cancel)
  butonBox.add(b_Add)
  butonBox.add(b_Del)
  butonBox.setHomogeneous(true)

#----------------------------
# Form grid sfline
#----------------------------
  var gridS = newGrid() 
  gridS.setSizeRequest(860,175)  # 140 /4 = 35 -> une ligne
  gridS.attach(gScrollbar, 0, 0, 1, 1)
#----------------------------
# Form General
#----------------------------
  let  gridForm = newGrid()
  gridForm.attach(gridA, 0, 0, 1, 1)
  gridForm.attach(gridS, 0, 1, 1, 1)
  gridForm.attach(butonBox, 0, 2, 1, 1)
  gridForm.setRowSpacing(15)
  gridForm.setMarginLeft(15);
  gridForm.setMarginRight(15);


#----------------------------
# Callback button
#----------------------------

  connect(b_Exit, "clicked", p_quitapp,app)
  connect(b_Update, "clicked", p_SetRowData)
  connect(b_Cancel, "clicked", p_Cancel,gSelection)
  connect(b_Add, "clicked", p_AddRowData)
  connect(b_Del, "clicked", p_Delete,gSelection)




  
#----------------------------
# Fin de création display
#----------------------------
  let  gWINAPP = newApplicationWindow(app)
  gWINAPP.title = "TEST-Manuel"
  gWINAPP.setBorderWidth(5)
  
  gSFLine.setcursor(newTreePathFromString("0"),nil,true);
  gWINAPP.add(gridForm)
  showAll(gWINAPP)

#----------------------------
# Procedrue MAIN
#----------------------------
proc main =
  let app = newApplication("org.gtk.example")
  connect(app, "activate", p_appActivate)
  discard run(app)

main()

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#----------------------------------------------------------
# Procedure de traitement des données saisie avec SFLine
#----------------------------------------------------------
proc p_updateRow(pRenderer: CellRendererText;pPath: cstring; pNewText: cstring; pColumn :TreeViewColumn ) =

  ## update / mise à jour de la gine uniquement par en direct SFLine or Formulaire 

  if ind_Selection == true : return

  #recuperation le rang de la cellule
  let gPathTree = newTreePathFromString(pPath)

  #recuperation listStore -> l'iterator
  var gIter: TreeIter
  discard gListStore.getIter(gIter, gPathTree)

  #receptacle de donnés string int .....

  var vStr: Value
  var vInt: Value

  #traitement de recuperation des données

  let ColName : string = pColumn.getTitle()
  let Str : string = $pPath
  let Rown : int = parseInt(Str)

  case ColName

    of "NOM" :
      gListStore.getValue(gIter, col_nom,vStr)
      personList[Rown].nom = fmt"{pNewText}"
      gListStore.setValue(gIter, col_nom,toStringVal(fmt"{pNewText}"))
      echo fmt" vstr:,{ vStr.getString()} ,  path: ,{ pPath } ,  colname: , {ColName} ,  value : ,{pNewText}"


    of "PRENOM" :
      gListStore.getValue(gIter, col_prenom,vStr)
      personList[Rown].prenom = fmt"{pNewText}"
      gListStore.setValue(gIter, col_prenom,toStringVal(fmt"{pNewText}"))
      echo fmt" vstr:,{ vStr.getString()} ,  path: ,{ pPath } ,  colname: , {ColName} ,  value : ,{pNewText}"


    of "AGE" :
      gListStore.getValue(gIter, col_age, vInt)
      personList[Rown].age = parseInt(fmt"{pNewText}")
      gListStore.setValue(gIter, col_age, toUIntVal(parseInt(fmt"{pNewText}")))
      echo fmt" vint : , {vInt.getUint()} ,  path: ,{ pPath } ,  colname: , {ColName} ,  value : ,{pNewText}"

    else: discard
  queueDraw(gSFLine)


#----------------------------------------------------------
# Procedure recuperation de la ligne selectioner
#----------------------------------------------------------

proc p_GetRowData(pViewTree: TreeView; pPath: TreePath; pColumn: TreeViewColumn) =

  if ind_Selection == true : return


  let ColName : string = pColumn.getTitle()


  echo fmt"p_GetRowData     ColName : ,{ ColName  } , path: {toString(pPath)} "


  case ColName
  of "ID" :

    var gIter : TreeIter
    discard gListStore.getIter(gIter, pPath)


    var vNom: Value
    var vPrenom: Value
    var vAge: Value


    gListStore.getValue(gIter, col_nom, vNom)
    e_NOM.setText(vNom.getString())
    
    gListStore.getValue(gIter, col_prenom, vPrenom)
    e_PRENOM.setText(vPrenom.getString())

    gListStore.getValue(gIter, col_age, vAge)
    e_AGE.setText(fmt"{vAge.getUint()}")

    svPath = toString(pPath)
    ind_Selection = true

  else: discard
  queueDraw(gSFLine)

#----------------------------------------------------------
# Procedure recuperation de la ligne selectioner
#----------------------------------------------------------

proc p_SetRowData(b: Button) =

  if ind_Selection == false  : return

  echo fmt"p_SetRowData           path: ,{ svPath } "

  let gPath = newTreePathFromString(svPath)
  
  var gIter : TreeIter
  discard gListStore.getIter(gIter, gPath)

  gListStore.setValue(gIter, col_nom, toStringVal(e_NOM.getText()))

  gListStore.setValue(gIter, col_prenom, toStringVal(e_PRENOM.getText()))
  
  gListStore.setValue(gIter, col_age, toUIntVal(parseInt(e_AGE.getText())))

  e_NOM.setText("")
  e_PRENOM.setText("")
  e_Age.setText("")
  svPath = ""
  ind_Selection = false
  queueDraw(gSFLine)

#----------------------------------------------------------
# Procedure Annul la ligne selectioner e purge le Formulaire
#----------------------------------------------------------

proc p_Cancel(b: Button,pSelection:TreeSelection) =


  echo fmt"p_Cancel"

  pSelection.unselectAll()

  e_NOM.setText("")
  e_PRENOM.setText("")
  e_Age.setText("")
  svPath = ""
  ind_Selection = false
  queueDraw(gSFLine)

#----------------------------------------------------------
# Procedure Canceled la ligne selectioner e purge le Formulaire
#----------------------------------------------------------

proc p_AddRowData(b: Button) =

  if ind_Selection == true  : return

  echo fmt"p_AddRowData"
  
  personList.add(Person(nom: e_NOM.getText() , prenom: e_PRENOM.getText(), age: parseInt(e_AGE.getText())))

  
  #  retrived nombre element = next ellement for add
  var vNbrPerson :int
  for i in low(personList)..high(personList): 
    vNbrPerson = i

  var gIter: TreeIter
  gListStore.append(gIter)
  echo fmt"p_AddRowData   {vNbrPerson }"
  gListStore.setValue(gIter, col_id,  toUIntVal(vNbrPerson + 1))
  gListStore.setValue(gIter, col_nom, toStringVal(personList[vNbrPerson].nom))
  gListStore.setValue(gIter, col_prenom, toStringVal(personList[vNbrPerson].prenom))
  gListStore.setValue(gIter, col_age,  toUIntVal(personList[vNbrPerson].age))
  gListStore.setValue(gIter, Color1, toStringVal("SpringGreen"))
  gListStore.setValue(gIter, Color2, toStringVal("cyan"))


  gSFLine.setcursor(newTreePathFromString(fmt"{vNbrPerson}"),nil,true); # position last row

  e_NOM.setText("")
  e_PRENOM.setText("")
  e_Age.setText("")
  svPath = ""

  ind_Selection = false
  queueDraw(gSFLine)

#----------------------------------------------------------
# Procedure delete 
#----------------------------------------------------------

proc p_Delete(b: Button,pSelection:TreeSelection) =

  if ind_Selection == false  : return

  echo fmt"Delete   , {svPath} "



  var vPerson: int = parseInt(svPath)
  personList.delete(vPerson)
  
  var vPos: int

  # fausse l'index clear et recharger la liste
  pSelection.unselectAll()

  clear(gListStore)

  for i in low(personList)..high(personList):
    var gIter: TreeIter
    gListStore.append(gIter) # currently we have to use setValue() as there is no varargs proc as in C original
    vPos = i
    gListStore.setValue(gIter, col_id,  toUIntVal(i + 1))
    gListStore.setValue(gIter, col_nom, toStringVal(personList[i].nom))
    gListStore.setValue(gIter, col_prenom, toStringVal(personList[i].prenom))
    gListStore.setValue(gIter, col_age,  toUIntVal(personList[i].age))
    gListStore.setValue(gIter, Color1, toStringVal("SpringGreen"))
    gListStore.setValue(gIter, Color2, toStringVal("cyan"))

  if vPerson <= vPos : 
    gSFLine.setcursor(newTreePathFromString(fmt"{vPerson}"),nil,true); # position row

  e_NOM.setText("")
  e_PRENOM.setText("")
  e_Age.setText("")
  svPath = ""


  ind_Selection = false
  queueDraw(gSFLine)