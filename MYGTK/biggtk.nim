#-----------------------------------------
# test apprentissage NIM-lang and GTK3
#
# test simplifaction avec des macro
#-----------------------------------------
import gintro/[glib, gobject, gtk , gdk]
import gintro/gio except ListStore


import strutils
import strformat
import std/[re]

include "./func_GTK.inc"

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

var e_Nom : Entry
var e_Prenom : Entry
var e_Age : Entry

const 
  col_id = 0
  col_nom = 1
  col_prenom = 2
  col_age = 3
  color_index = 4
  color_data = 5
  col_nbr = 6

var gSFLine : TreeView
var gListStore : ListStore
var svPath: string
var ind_Selection : bool = false



#-------------------------------------------------------------------------
# defintion pour validation du contenue mais pas de la valeurs du contenu
#-------------------------------------------------------------------------

type oScreen = object
  id : int
  name: string
  ncar : int
  typs : bool # string
  typi : bool # int
  typd : bool # decimal
  typf : bool # float
  rgs  : string
  force: bool # true obligatoire
  tst : bool
  min : int
  max : int
  tstf : bool
  minf: float
  maxf: float


# il faudrait mettre la possibilité plusieurs langues

var scrList = newSeq[oScreen]()
scrList.add(oScreen(id: col_id, name:"ID", ncar: 3 , typs : false, typi : true, typd : false, typf : false ,
 rgs : "" , force: false , tst: false , min: 0 , max: 0 , tstf: false , minf :0.0 , maxf :0.0 ))  # no contrôle


scrList.add(oScreen(id: col_nom, name:"NOM", ncar: 30, typs : true, typi : false, typd : false, typf : false ,
 rgs: "[A-ZÀÂÇÉÈÊËÏÎÔŒÙÛÜŸŶ \\-]", force: true , tst: false , min: 0 , max: 0 , tstf: false , minf :0.0 , maxf :0.0 ))

scrList.add(oScreen(id: col_prenom, name:"PRENOM", ncar: 30, typs : true, typi : false, typd : false, typf : false ,
 rgs: "[A-Za-zäâÀÂâçÇéÉèÈêÊëËïÏîÎöÖôÔœŒùÙüÛûÜïŸîŶ \\-]", force: true , tst: false , min: 0 , max: 0 , tstf: false , minf :0.0 , maxf :0.0 ))

scrList.add(oScreen(id: col_age, name:"AGE", ncar: 3, typs : false, typi : true, typd : false, typf : false,
 rgs : "\\d{0,%d}", force: true , tst: false , min: 0 , max: 0 , tstf: true , minf :0.0 , maxf :120.0 ))



#----------------------------
#Procedure Exit
#---------------------------
proc p_quitApp(b: Button; app: Application) =
  echo "Bye"
  quit(app)


#----------------------------------
# declaration Procedure 
#----------------------------------

proc p_UpdateRow(pRenderer: CellRendererText;pPath: cstring; pNewText: cstring; pColumn :TreeViewColumn )

proc p_GetRowData(pViewTree: TreeView; pPath: TreePath; pColumn: TreeViewColumn)

proc p_SetRowData(b: Button)

proc p_Cancel(b: Button; pSelection: TreeSelection)

proc p_AddRowData(b: Button)

proc p_Delete(b: Button, pSelection: TreeSelection)

#proc pcell_data_function(column: TreeViewColumn; cell: CellRenderer;  data: pointer)


proc p_CellDataErr(pColumn :TreeViewColumn;pNewText: cstring;): bool=

  var sVal:string = fmt"{pNewText}"

  let ColName: string = pColumn.getTitle()

  var scr : oScreen

  for i in low(scrList)..high(scrList):
    if scrList[i].name == ColName :
      scr = scrList[i]
      break

  echo fmt" p_CellDataErr  vstr:, {sVal}  ,  colname: , {ColName} ,  lens Val  {scr.ncar} : ,{sVal.len}   errror"
  
  # controle len maxi 
  if sVal.len > scr.ncar :
    return true

  # controle saisie obligatoire
  if sVal.len ==  0 and scr.force :
    return true

  #controle keyboard 
  let rgx = re(fmt"{scr.rgs}")
  if match(sVal ,rgx) :
    return true

  return false

#----------------------------
#Procedure Principal
#----------------------------
proc p_appActivate(app: Application) =

  include "./css_global.inc"


  let l_Nom = mLabel("Nom",30)
  let l_Prenom = mLabel("Prénom",30)
  let l_Age = mLabel("Age",3)

  e_Nom = mEntry("e_Nom",30)
  e_Prenom = mEntry("e_Prenom",30)
  e_Age = mEntry("e_Age",3)

  let  b_Exit = mButton("b_Exit","Exit")
  let  b_Update = mButton("b_Update","UPDATE")
  let  b_Cancel = mButton("b_Cancel","CANCEL")
  let  b_Add = mButton("b_Add","ADD")
  let  b_Del = mButton("b_Del","DEL")


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


#--------------------------------------
# define SFLINE 
# liststore or tabeau display ;)
#--------------------------------------
  var h = [typeFromName("guint"), typeFromName("gchararray"), typeFromName("gchararray"),typeFromName("guint"), typeFromName("gchararray"),typeFromName("gchararray")]
  
  gListStore = newListStore(col_nbr,  cast[pointer]( unsafeaddr h)) # cast is ugly, we should fix it in bindings.

#--------------------------------------
# chargement data SFLine
#--------------------------------------
  var gIter: TreeIter
  for i in low(personList)..high(personList):
    gListStore.append(gIter) # currently we have to use setValue() as there is no varargs proc as in C original
    
    gListStore.setValue(gIter, col_id,  toUIntVal(i + 1))
    gListStore.setValue(gIter, col_nom, toStringVal(personList[i].nom))
    gListStore.setValue(gIter, col_prenom, toStringVal(personList[i].prenom))
    gListStore.setValue(gIter, col_age,  toUIntVal(personList[i].age))
    gListStore.setValue(gIter, color_index, toStringVal("PaleGoldenRod"))

    if ( i mod 2  == 0):
      gListStore.setValue(gIter, color_data, toStringVal("Azure"))
    else :
      gListStore.setValue(gIter, color_data, toStringVal("Beige"))
#--------------------------------------
# define SFLINE 
# Model
#--------------------------------------

  gSFLine  = newTreeViewWithModel(gListStore)
  gSFLine.setHexpand
  gSFLine.setVexpand
  gSFLine.setProperty("activate-on-single-click", toBoolVal(true))
  
  var context = getStyleContext(gSFLine)
  context.addClass("treeview")
  
  var gSelection:TreeSelection = gSFLine.getSelection()
  gSelection.setMode(SelectionMode.single)
  
#--------------------------------------
# define Column
# define CellRenderer
# calback row.... 
#--------------------------------------
  let coln_1 = mTreeVwColRead("ID", col_id , 3, color_index)
  discard gSFLine.appendColumn(coln_1)
  
  let (coln_2 , renderer_2) = mTreeVwColEdit("NOM" , col_nom, 30  , color_data )
  connect(renderer_2, "edited", p_UpdateRow , coln_2)
  #setCellDataFunc(coln_2,renderer_2,f_CellDataFunction,nil,nil)
  discard gSFLine.appendColumn(coln_2)
  
  let (coln_3, renderer_3)  = mTreeVwColEdit("PRENOM" , col_prenom , 30 , color_data)
  connect(renderer_3, "edited", p_UpdateRow , coln_3)
  discard gSFLine.appendColumn(coln_3)
  
  let (coln_4, renderer_4)  = mTreeVwColEdit("AGE" , col_age , 3 , color_data)
  connect(renderer_4, "edited", p_UpdateRow , coln_4)
  discard gSFLine.appendColumn(coln_4)
  
  connect(gSFLine, "row-activated", p_GetRowData)

#---------------------------------------
# Ajout barres de défilement  ScrollBar
#---------------------------------------
  let gScrollbar  = newScrolledWindow()
  gScrollbar.setPolicy(automatic, automatic)
  gScrollbar.add(gSFLine)

#----------------------------
# Form grid sfline
#----------------------------
  var gridS = newGrid() 
  gridS.setSizeRequest(816,175)  # 140 /4 = 35 -> une ligne
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

  #traitement de recuperation des données  à partir du model gListStore
  #update de la table personList
  
  let ColName : string = pColumn.getTitle()

  let Str : string = $pPath
  let Rown : int = parseInt(Str)


  case ColName
    of "NOM" :
      if p_CellDataErr(pColumn,pNewText):
        gListStore.setValue(gIter, col_nom,toStringVal(fmt"{personList[Rown].nom}"))
      else:
        personList[Rown].nom = fmt"{pNewText}"
        gListStore.setValue(gIter, col_nom,toStringVal(fmt"{pNewText}"))

    of "PRENOM" :
      if p_CellDataErr(pColumn,pNewText):
        gListStore.setValue(gIter, col_prenom,toStringVal(fmt"{personList[Rown].prenom}"))
      else:
        personList[Rown].prenom = fmt"{pNewText}"
        gListStore.setValue(gIter, col_nom,toStringVal(fmt"{pNewText}"))

    of "AGE" :
      
      if p_CellDataErr(pColumn,pNewText):
        gListStore.setValue(gIter, col_age,toUIntVal(personList[Rown].age))
      else:
        personList[Rown].age = parseInt(fmt"{pNewText}")
        gListStore.setValue(gIter, col_age, toUIntVal(parseInt(fmt"{pNewText}")))


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
  gListStore.setValue(gIter, color_index, toStringVal("SpringGreen"))
  gListStore.setValue(gIter, color_data, toStringVal("cyan"))


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
    gListStore.setValue(gIter, color_index, toStringVal("SpringGreen"))
    gListStore.setValue(gIter, color_data, toStringVal("cyan"))

  if vPerson <= vPos : 
    gSFLine.setcursor(newTreePathFromString(fmt"{vPerson}"),nil,true); # position row

  e_NOM.setText("")
  e_PRENOM.setText("")
  e_Age.setText("")
  svPath = ""


  ind_Selection = false
  queueDraw(gSFLine)


