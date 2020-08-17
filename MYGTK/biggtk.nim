#-----------------------------------------
# test apprentissage NIM-lang and GTK3
#
# test simplifaction avec des macro
#-----------------------------------------
import gintro/[glib, gobject, gtk , gdk]
import gintro/gio except ListStore

from strutils import toUpper , toLower
from strutils import Digits, parseInt
from strutils import Digits, parseFloat
import strformat
import std/[re]

type Person = object
  nom: string
  prenom: string
  age: int
  annuel: float
  mensuel: float

var personList = newSeq[Person]()
personList.add(Person(nom: "Koch", prenom:"karl", age: 23, annuel: 0, mensuel : 0))
personList.add(Person(nom: "Pan", prenom:"Peter", age: 12, annuel: 0 , mensuel : 0))
personList.add(Person(nom: "Rouge", prenom:"JP", age: 68, annuel: 0 , mensuel : 0))
personList.add(Person(nom: "Moranne", prenom:"Bob", age: 30, annuel: 0 , mensuel : 0))
personList.add(Person(nom: "Naruto", prenom:"Konoan", age: 23, annuel: 0 , mensuel : 0))
personList.add(Person(nom: "Lion", prenom:"Afrique", age: 15, annuel: 0 , mensuel : 0))
personList.add(Person(nom: "Aigle", prenom:"Noir", age: 40, annuel: 0 , mensuel : 0))
personList.add(Person(nom: "Pierre", prenom:"Precieuse", age: 30, annuel: 0 , mensuel : 0))

var e_Nom : Entry
var e_Prenom : Entry
var e_Age : Entry

const 
  col_id = 0
  col_nom = 1
  col_prenom = 2
  col_age = 3
  col_annuel = 4
  col_mensuel = 5
  color_index = 6
  color_data = 7
  col_nbr = 8

var gSFLine : TreeView
var gListStore : ListStore
var svPath: string
var ind_Selection : bool = false
let gLinesV: TreeViewGridLines  = TreeViewGridLines.vertical


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
  tsti : bool
  min : int
  max : int
  tstf : bool
  minf: float
  maxf: float


# il faudrait mettre la possibilité plusieurs langues

var scrList = newSeq[oScreen]()
scrList.add(oScreen(id: col_id, name:"ID", ncar: 3 , typs : false, typi : true, typd : false, typf : false ,
                      rgs : "" ,
                        force: false , tsti: false , min: 0 , max: 0 , tstf: false , minf :0.0 , maxf :0.5 ))  # no contrôle


scrList.add(oScreen(id: col_nom, name:"NOM", ncar: 30, typs : true, typi : false, typd : false, typf : false ,
                      rgs: "^[A-ZÀÂÇÉÈÊËÏÎÔŒÙÛÜŸŶ \\-]*$",
                        force: true , tsti: false , min: 0 , max: 0 , tstf: false , minf :0 , maxf :0 ))

scrList.add(oScreen(id: col_prenom, name:"PRENOM", ncar: 30, typs : true, typi : false, typd : false, typf : false ,
                      rgs: "^[A-Za-zäâÀÂâçÇéÉèÈêÊëËïÏîÎöÖôÔœŒùÙüÛûÜïŸîŶ \\-]*$",
                        force: true , tsti: false , min: 0 , max: 0 , tstf: false , minf :0 , maxf :0 ))

scrList.add(oScreen(id: col_age, name:"AGE", ncar: 3, typs : false, typi : true, typd : false, typf : false,
                      rgs :"^\\d{1,3}$",
                        force: true , tsti: true, min: 0 , max: 120 , tstf: false , minf :0 , maxf :0 ))

scrList.add(oScreen(id: col_annuel, name:"ANNUEL", ncar: 12, typs : false, typi : false, typd : false, typf : true,
                      rgs :"^\\d{1,9}(\\.(?=\\d)\\d){0,2}$",
                        force: true , tsti: false, min: 0 , max: 0 , tstf: true , minf :0.00 , maxf :999999999.99 ))

scrList.add(oScreen(id: col_mensuel, name:"MENSUEL", ncar: 12, typs : false, typi : false, typd : false, typf : true,
                        rgs :"",
                          force: false , tsti: false, min: 0 , max: 0 , tstf: false , minf :0 , maxf :0 ))

#rgs : ex: "^\\d{0,3}$"   integer 
#rgs : ex: "^\\d{1,3}(\\.(?=\\d)\\d){0,2}$"  decimales /float

#----------------------------
#Procedure Exit
#---------------------------
proc p_quitApp(b: Button; app: Application) =
  echo "Bye"
  quit(app)


# declaration Procedure 

#----------------------------
# Fonction interne
#----------------------------

proc toStringVal(s: string): Value

proc toUIntVal(i: int): Value

proc toBoolVal(b: bool): Value 

proc toFloatVal(f: float): Value 

#----------------------------
# Fonction GTK
#----------------------------

proc mLabel(sText: string; ncar: int; style: bool = true ): Label

proc mEntry( sName: string; ncar: int; style: bool = true; sText: string = "") : Entry

proc mButton(sName: string; sText: string; style: bool = true ): Button

proc mTreeViewColEdit(sName: string ; col_num: int ; nbrcar: int ; col_color : int ; col_alignment: cfloat = 0.0 ): (TreeViewColumn , CellRendererText)

proc mTreeViewColRead(sName: string; col_num: int ; nbrcar: int ;  col_color: int ; col_alignment: cfloat = 0.0 ): TreeViewColumn


proc p_CellDataErr(pColumn :TreeViewColumn; pVal: string): bool

proc p_UpdRowData(pRenderer: CellRendererText; pPath: string; pNewText: string; pColumn :TreeViewColumn )

proc p_GetRowData(pViewTree: TreeView; pPath: TreePath; pColumn: TreeViewColumn)

proc p_SetRowData(b: Button)

proc p_Cancel(b: Button; pSelection: TreeSelection)

proc p_AddRowData(b: Button)

proc p_DltRowData(b: Button, pSelection: TreeSelection)

#proc pcell_data_function(column: TreeViewColumn; cell: CellRenderer;  data: pointer)





proc p_EntryDataErr(pEntry : Entry ;pVal: string;): bool=


  let sName: string = pEntry.getName()

  var u : int
  for i in low(scrList)..high(scrList):
    if scrList[i].name == sName :
      u=i
      break

  echo fmt" p_EntryDataErr  vstr:, {pVal}  ,  name: , {sName} ,  lens Val  {scrList[u].ncar} : {pVal.len}   u {u}  errror"
  
  # controle len maxi 
  if pVal.len > scrList[u].ncar :
    return true

  # controle saisie obligatoire
  if pVal.len ==  0 and scrList[u].force :
    return true
  echo "ok2"
  echo fmt"regex   {scrList[u].rgs}"

  echo fmt"match(pVal ,re(scrList[u].rgs) {match(pVal ,re(scrList[u].rgs))}"
  #controle keyboard 
  if false == match(pVal ,re(scrList[u].rgs)) :
    return true
  echo "ok3"

  if scrList[u].tsti :
    if scrList[u].min >  parseInt(pVal) or scrList[u].max <  parseInt(pVal) :
      echo "oups"
      return true

  echo fmt"ok4 "

  if scrList[u].tstf :
    if scrList[u].minf >  parseFloat(pVal) or scrList[u].maxf <  parseFloat(pVal) :
      return true

  echo "ok5"


  return false

#----------------------------
#Procedure Principal
#----------------------------
proc p_appActivate(app: Application) =

  include "./css_global.inc"


  let l_Nom = mLabel("Nom",30)
  let l_Prenom = mLabel("Prénom",30)
  let l_Age = mLabel("Age",6)

  e_Nom = mEntry("NOM",30)
  e_Prenom = mEntry("PRENOM",30)
  e_Age = mEntry("AGE",6)

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
  var h = [typeFromName("guint"), typeFromName("gchararray"), typeFromName("gchararray"),typeFromName("gchararray"),
  typeFromName("gchararray"),typeFromName("gchararray"),typeFromName("gchararray"),typeFromName("gchararray")]
  
  gListStore = newListStore(col_nbr,  cast[pointer]( unsafeaddr h)) # cast is ugly, we should fix it in bindings.

#--------------------------------------
# chargement data SFLine
#--------------------------------------
  var gIter: TreeIter
  for i in low(personList)..high(personList):
    gListStore.append(gIter) # currently we have to use setValue() as there is no varargs proc as in C original
    
    gListStore.setValue(gIter, col_id,      toUIntVal(i + 1))
    gListStore.setValue(gIter, col_nom,     toStringVal(personList[i].nom))
    gListStore.setValue(gIter, col_prenom,  toStringVal(personList[i].prenom))
    gListStore.setValue(gIter, col_age,     toStringVal(fmt"{personList[i].age}"))
    gListStore.setValue(gIter, col_annuel,  toStringVal(fmt"{personList[i].annuel:9.2f}"))
    gListStore.setValue(gIter, col_mensuel, toStringVal(fmt"{personList[i].mensuel:9.2f}"))
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

  setGridLines(gSFLine,gLinesV)

  var context = getStyleContext(gSFLine)
  context.addClass("treeview")
  
  var gSelection:TreeSelection = gSFLine.getSelection()
  gSelection.setMode(SelectionMode.single)
  
#--------------------------------------
# define Column
# define CellRenderer
# calback row.... 
#--------------------------------------
  let coln_1 = mTreeViewColRead("ID", col_id , 2, color_index,0.5)
  discard gSFLine.appendColumn(coln_1)
  
  let (coln_2 , renderer_2) = mTreeViewColEdit("NOM" , col_nom, 30  , color_data)
  connect(renderer_2, "edited", p_UpdRowData , coln_2)
  #setCellDataFunc(coln_2,renderer_2,f_CellDataFunction,nil,nil)
  discard gSFLine.appendColumn(coln_2)
  
  let (coln_3, renderer_3)  = mTreeViewColEdit("PRENOM" , col_prenom , 30 , color_data )
  connect(renderer_3, "edited", p_UpdRowData , coln_3)
  discard gSFLine.appendColumn(coln_3)
  
  let (coln_4, renderer_4)  = mTreeViewColEdit("AGE" , col_age , 3 , color_data, 1.0)
  connect(renderer_4, "edited", p_UpdRowData , coln_4)
  discard gSFLine.appendColumn(coln_4)

  let (coln_5, renderer_5)  = mTreeViewColEdit("ANNUEL" , col_annuel , 12 , color_data,1.0)
  connect(renderer_5, "edited", p_UpdRowData , coln_5)
  discard gSFLine.appendColumn(coln_5)

  let coln_6 = mTreeViewColRead("MENSUEL" , col_mensuel , 12 , color_data,1.0)
  discard gSFLine.appendColumn(coln_6)
  
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
  gridS.setSizeRequest(1092,175)  # 175 /5 = 35 -> une ligne
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
  connect(b_Del, "clicked", p_DltRowData,gSelection)

#----------------------------
# Fin de création display
#----------------------------
  let  gWINAPP = newApplicationWindow(app)
  gWINAPP.title = "TEST-BIG_GTK"
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
# Procedure de contrôle saisie SFLine
#----------------------------------------------------------

proc p_CellDataErr(pColumn :TreeViewColumn; pVal: string): bool=

  let ColName: string = pColumn.getTitle()

  var u : int
  for i in low(scrList)..high(scrList):
    if scrList[i].name == ColName :
      u=i
      break

  # controle len maxi 
  if pVal.len > scrList[u].ncar :
    return true

  # controle saisie obligatoire
  if pVal.len ==  0 and scrList[u].force :
    return true

  #controle keyboard 
  if false == match(pVal ,re(scrList[u].rgs)) :
    return true

  if scrList[u].tsti :
    if scrList[u].min >  parseInt(pVal) or scrList[u].max <  parseInt(pVal) :
      return true

  if scrList[u].tstf :
    if scrList[u].minf >  parseFloat(pVal) or scrList[u].maxf <  parseFloat(pVal) :
      return true

  return false


#----------------------------------------------------------
# Procedure de traitement des données saisie avec SFLine
#----------------------------------------------------------
proc p_UpdRowData(pRenderer: CellRendererText;pPath: string; pNewText: string; pColumn :TreeViewColumn ) =

  ## update / mise à jour de la gine uniquement par en direct SFLine or Formulaire 

  if ind_Selection == true : return

  #recuperation le rang de la cellule
  let gPathTree = newTreePathFromString(pPath)

  #recuperation listStore -> l'iterator
  var gIter: TreeIter
  discard gListStore.getIter(gIter, gPathTree)

  #traitement de recuperation des données  à partir du model gListStore
  #update de la table personList
  
  let ColName : string = pColumn.getTitle()

  let Str : string = $pPath

  let Rown : int = parseInt(Str)

  var pVal:string = fmt"{pNewText}"

  case ColName
    of "NOM" :
      pVal = toUpper(pVal)
      if p_CellDataErr(pColumn,pVal):
        gListStore.setValue(gIter, col_nom,toStringVal(fmt"{personList[Rown].nom}"))
      else:
        personList[Rown].nom = fmt"{pVal}"
        gListStore.setValue(gIter, col_nom,toStringVal(pVal))

    of "PRENOM" :
      if p_CellDataErr(pColumn,pVal):
        gListStore.setValue(gIter, col_prenom,toStringVal(fmt"{personList[Rown].prenom}"))
      else:
        personList[Rown].prenom = fmt"{pVal}"
        gListStore.setValue(gIter, col_prenom,toStringVal(pVal))

    of "AGE" :
      
      if p_CellDataErr(pColumn,pVal):
        gListStore.setValue(gIter, col_age,toStringVal(fmt"{personList[Rown].age}"))
      else:
        personList[Rown].age = parseInt(pVal)
        gListStore.setValue(gIter, col_age, toStringVal(pVal))


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
    e_AGE.setText(vAge.getString())

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


  if p_EntryDataErr(e_NOM,toUpper(e_NOM.getText())):
    echo "error eNOM"
    return
  else:
    gListStore.setValue(gIter, col_nom, toStringVal(toUpper(e_NOM.getText())))
  
  if p_EntryDataErr(e_PRENOM,toUpper(e_PRENOM.getText())):
    echo "error e_PRENOM"
    return
  else:
    gListStore.setValue(gIter, col_prenom, toStringVal(e_PRENOM.getText()))

  if p_EntryDataErr(e_AGE,e_AGE.getText()):
    echo "error e_AGE"
    return
  else:
    gListStore.setValue(gIter, col_age, toStringVal(e_AGE.getText()))

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
  
  personList.add(Person(nom: e_NOM.getText() , prenom: e_PRENOM.getText(), age: parseInt(e_AGE.getText()) ,annuel: 0, mensuel: 0 ))

  
  #  retrived nombre element = next ellement for add
  var vNbrPerson :int
  for i in low(personList)..high(personList): 
    vNbrPerson = i

  var gIter: TreeIter
  gListStore.append(gIter)
  echo fmt"p_AddRowData   {vNbrPerson }"
  gListStore.setValue(gIter, col_id,      toUIntVal(vNbrPerson + 1))
  gListStore.setValue(gIter, col_nom,     toStringVal(personList[vNbrPerson].nom))
  gListStore.setValue(gIter, col_prenom,  toStringVal(personList[vNbrPerson].prenom))
  gListStore.setValue(gIter, col_age,     toStringVal(fmt"{personList[vNbrPerson].age}"))
  gListStore.setValue(gIter, color_index, toStringVal("SpringGreen"))
  gListStore.setValue(gIter, color_data,  toStringVal("cyan"))


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

proc p_DltRowData(b: Button,pSelection:TreeSelection) =

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
    gListStore.setValue(gIter, col_id,      toUIntVal(i + 1))
    gListStore.setValue(gIter, col_nom,     toStringVal(personList[i].nom))
    gListStore.setValue(gIter, col_prenom,  toStringVal(personList[i].prenom))
    gListStore.setValue(gIter, col_age,     toStringVal(fmt"{personList[i].age}"))
    gListStore.setValue(gIter, col_annuel,  toStringVal(fmt"{personList[i].annuel:9.2f}"))
    gListStore.setValue(gIter, col_mensuel, toStringVal(fmt"{personList[i].mensuel:9.2f}"))
    gListStore.setValue(gIter, color_index, toStringVal("SpringGreen"))
    gListStore.setValue(gIter, color_data,  toStringVal("cyan"))

  if vPerson <= vPos : 
    gSFLine.setcursor(newTreePathFromString(fmt"{vPerson}"),nil,true); # position row

  e_NOM.setText("")
  e_PRENOM.setText("")
  e_Age.setText("")
  svPath = ""


  ind_Selection = false
  queueDraw(gSFLine)



#----------------------------
# Fonction Interne
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

proc toFloatVal(f: float): Value =
  let gtype = typeFromName("gfloat")
  discard init(result, gtype)
  setFloat(result, f)

#----------------------------
# Fonction GTK
#----------------------------

proc mLabel(sText: string; ncar: int; style: bool = true ): Label =
  var x = newLabel(sText)
  x.setWidthChars(ncar)
  if style :
    var  contextx: StyleContext
    contextx = getStyleContext(x)
    contextx.addClass("text")
  return x

proc mEntry( sName: string; ncar: int; style: bool = true; sText: string = ""): Entry =
  var x = newEntry()
  x.set_name(sName)
  x.setText(sText)
  x.setWidthChars(ncar)
  x.setMaxLength(ncar)
  if style :
    var  contextx: StyleContext
    contextx = getStyleContext(x)
    contextx.addClass("entry")
  return x

proc mButton(sName: string; sText: string; style: bool = true ): Button =
  var x = newButton(sText)
  x.set_name(sName)
  var  contextx: StyleContext
  contextx = getStyleContext(x)
  contextx.addClass("button")
  return x

proc mTreeViewColEdit(sName: string ; col_num: int ; nbrcar: int ; col_color : int ; col_alignment: cfloat = 0.0): (TreeViewColumn , CellRendererText) =
  var coln = newTreeViewColumn()
  
  var renderern = newCellRendererText()
  var col_size:int = (nbrcar + 1) * 13
  
  setProperty(renderern , "editable", toBoolVal(true))
  renderern.setAlignment(col_alignment,0.0)

  coln.setAlignment(col_alignment)
  coln.setTitle(sName)
  coln.packStart(renderern, true)
  coln.addAttribute(renderern, "text", col_num)
  coln.addAttribute(renderern, "cell-background", col_color)
  coln.setFixedWidth(col_size)
  coln.setMaxWidth(col_size)

  return (coln , renderern)

proc mTreeViewColRead(sName: string; col_num: int ; nbrcar: int ;  col_color: int ; col_alignment: cfloat = 0.0 ): TreeViewColumn =
  var coln = newTreeViewColumn()

  var renderern = newCellRendererText()
  var col_size:int = (nbrcar + 1) * 13

  renderern.setAlignment(col_alignment,0.0)

  coln.setAlignment(col_alignment)
  coln.setTitle(sName)
  coln.packStart(renderern, true)
  coln.addAttribute(renderern, "text", col_num)
  coln.addAttribute(renderern, "cell-background", col_color)
  coln.setFixedWidth(col_size)
  coln.setMaxWidth(col_size)

  return coln