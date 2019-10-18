#-----------------------------------------
# test apprentissage NIM-lang and GTK3
# démarer le lundi 07/10/2019
# premier jet le 1/10/2019 cohérent
#
# en attente 
# addition de ligne 
# delete de ligne 
# faire une requete sqlite voir postgresql
# une fenêtre modal
# un appel execv ou un call de programme 
# une communication entre programme de type <sys/msg.h>
# les thread <sys/shm.h>
# les traitement de signaux <signal.h>
# et les exceptions
#
#-----------------------------------------
import gintro/[gtk, gobject, gio, glib]

import gintro/gdk
import strutils
import strformat
from strutils import Digits, parseInt


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


var gSFLine : TreeView
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

# we need the following two procs for now -- later we will not use that ugly cast...
proc typeTest(o: gobject.Object; s: string): bool =
  let gt = g_type_from_name(s)
  return g_type_check_instance_is_a(cast[ptr TypeInstance00](o.impl), gt).toBool

proc listStore(o: gobject.Object): gtk.ListStore =
  assert(typeTest(o, "GtkListStore"))
  cast[gtk.ListStore](o)




#----------------------------------
# declaration Procedure UPDATE SFL
#----------------------------------

proc p_UpdateRow(pRenderer: CellRendererText;pPath: cstring; pNewText: cstring; pColumn :TreeViewColumn )

proc p_GetRowData(pViewTree: TreeView; pPath: TreePath; pColumn: TreeViewColumn)

proc p_SetRowData(b: Button)

proc p_Annul(b: Button; pSelection: TreeSelection)

#----------------------------------
#Procedure Ajustement scrollbar
#----------------------------------
proc p_Ajustement (pAjust: Adjustment) =

  pAjust.setValue(pAjust.getUpper())


#----------------------------
#Procedure Exit
#---------------------------
proc p_quitApp(b: Button; app: Application) =
  echo "Bye"
  quit(app)

#----------------------------
#Procedure Message lollll 
#---------------------------
proc p_hello(b: Button; msg: string ) =
  echo "Hello", msg

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
  let  b_Annul = newButton("ANNUL")
  let  b_Add = newButton("ADD")
  let  b_Del = newButton("DEL")



  var  context: StyleContext


  let  gWINAPP = newApplicationWindow(app)
  gWINAPP.title = "TEST-Manuel"
  gWINAPP.setBorderWidth(5)

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

  b_Annul.set_name("b_Annul")
  context = getStyleContext(b_Annul)
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

  var gListStore = newListStore(Columns,  cast[pointer]( unsafeaddr h)) # cast is ugly, we should fix it in bindings.


  for i in low(personList)..high(personList):
    var gIter: TreeIter
    gListStore.append(gIter) # currently we have to use setValue() as there is no varargs proc as in C original
    
    gListStore.setValue(gIter, col_id,  toUIntVal(i + 1))
    gListStore.setValue(gIter, col_nom, toStringVal(personList[i].nom))
    gListStore.setValue(gIter, col_prenom, toStringVal(personList[i].prenom))
    gListStore.setValue(gIter, col_age,  toUIntVal(personList[i].age))
    gListStore.setValue(gIter, Color1, toStringVal("SpringGreen"))
    gListStore.setValue(gIter, Color2, toStringVal("cyan"))






  # proc for treeview data
#--------------------------------------
# define SFLINE 
# Model
#--------------------------------------

  gSFLine  = newTreeViewWithModel(gListStore)
  gSFLine.setHexpand
  gSFLine.setVexpand
  gSFLine.setProperty("activate-on-single-click", toBoolVal(true))
  context = getStyleContext(gSFLine)
  context.addClass("treview")

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
#----------------------------


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
  butonBox.add(b_Annul)
  butonBox.add(b_Add)
  butonBox.add(b_Del)
  butonBox.setHomogeneous(true)

#----------------------------
# Form grid sfline
#----------------------------
  var gridS = newGrid() 
  gridS.setSizeRequest(860,90)
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
  context = getStyleContext(gridForm)
  context.addClass("grid")


#----------------------------
# Callback 
#----------------------------

  connect(b_Exit, "clicked", p_quitapp,app)
  connect(b_Update, "clicked", p_SetRowData)
  connect(b_Annul, "clicked", p_Annul,gSelection)
  connect(b_Add, "clicked", p_hello, "Page down")
  connect(b_Del, "clicked", p_hello, "Page up")

  connect(gScrollbar.getVadjustment(),"changed",p_Ajustement)



#----------------------------
# Fin de création display
#----------------------------

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

  #recuperation listStore et l'iterator
  let gListStore = listStore(gSFLine.getModel())
  var gIter: TreeIter
  discard gListStore.getIter(gIter, gPathTree)

  #receptacle de donnés string int .....

  var vStr: Value
  var vInt: Value

  #traitement de recuperation des données  à partir du model gListStore
  #update de la table personList
  
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



#----------------------------------------------------------
# Procedure recuperation de la ligne selectioner
#----------------------------------------------------------

proc p_GetRowData(pViewTree: TreeView; pPath: TreePath; pColumn: TreeViewColumn) =

  if ind_Selection == true : return


  let ColName : string = pColumn.getTitle()


  echo fmt"p_GetRowData     ColName : ,{ ColName  } "


  case ColName
  of "ID" :

    let gListStore = listStore(gSFLine.getModel())
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

#----------------------------------------------------------
# Procedure recuperation de la ligne selectioner
#----------------------------------------------------------

proc p_SetRowData(b: Button) =

  if ind_Selection == false  : return

  echo fmt"p_SetRowData           path: ,{ svPath } "

  let gPath = newTreePathFromString(svPath)
  let gListStore = listStore(gSFLine.getModel())
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

  #----------------------------------------------------------
# Procedure Annul la ligne selectioner e purge le Formulaire
#----------------------------------------------------------

proc p_Annul(b: Button,pSelection:TreeSelection) =

  if ind_Selection == false  : return

  echo fmt"p_Annul"

  pSelection.unselectAll()

  e_NOM.setText("")
  e_PRENOM.setText("")
  e_Age.setText("")
  svPath = ""
  ind_Selection = false