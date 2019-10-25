#[
bonjour :

ce model fonctionne sans bug pour ui.nim

il y a juste un beug dans 
ma correction ce module ne sert que pour les tables   taable.c
static void applyColor(GtkTreeModel *m, GtkTreeIter *iter, int modelColumn, GtkCellRenderer *r, const char *prop, const char *propSet)
{
	GValue value = G_VALUE_INIT;
	GdkRGBA *rgba=NULL;

	gtk_tree_model_get_value(m, iter, modelColumn, &value);
	//rgba = (GdkRGBA *) g_value_get_boxed(&value);
	if (rgba != NULL)
		g_object_set(r, prop, rgba, NULL);
	else
		g_object_set(r, propSet, FALSE, NULL);
	g_value_unset(&value);
}

le model d'origine est pas correct et losrque l'on commence c'est une galère
bref heureusement que j'ai commencer par le projet GINTRO

ceci etant dit il est rapide simple une fois operationel

on peu entre voir plein de chose comme par exemple dans le modelSetCellValue 
les condition et les erreur a signaler a l'utilisateur 

vous devez vous posez des question pour SFLine il faut le penser comme un sous fichier ligne sur le quel la table roule

biensur il faudrait ajouter des button dans l'application  pour valider et mettre ajour ect.... ou dans la ligne ...  

]#






import ui
import strformat
import strutils

const
  NUM_COLUMNS = 5
  NUM_ROWS = 10

const
  COLUMN_ID = 0
  COLUMN_NOM = 1
  COLUMN_PRENOM = 2
  COLUMN_AGE = 3

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
personList.add(Person(nom: "FanfFan", prenom:"Latulipe", age: 35))
personList.add(Person(nom: "TinTin", prenom:"Herge", age: 30))



proc modelNumColumns(mh: ptr TableModelHandler, m: TableModel): int {.cdecl.} = NUM_COLUMNS
proc modelNumRows(mh: ptr TableModelHandler, m: TableModel): int {.cdecl.} = NUM_ROWS


proc modelColumnType(mh: ptr TableModelHandler, m: TableModel, col: int): TableValueType {.noconv.} =
  result = TableValueTypeString



proc modelCellValue(mh: ptr TableModelHandler, m: TableModel, row: int, col: int): ptr TableValue {.noconv.} =

  if col == COLUMN_ID:
    result = newTableValueString($(row+1))
  elif col == COLUMN_NOM:
    result = newTableValueString(personList[row].nom)

  elif col == COLUMN_PRENOM:
    result = newTableValueString(personList[row].prenom)
  elif col == COLUMN_AGE:
    result = newTableValueString(fmt"{personList[row].age}")
  else:
    result = newTableValueString("")
 

proc modelSetCellValue(mh: ptr TableModelHandler, m: TableModel, row: int, col: int, val: ptr TableValue) {.cdecl.} =
  if col == COLUMN_NOM:
    echo tableValueString(val)
    personList[row].nom = fmt"{tableValueString(val)}"
  elif col == COLUMN_PRENOM:
    personList[row].prenom = fmt"{tableValueString(val)}"
    
  elif col == COLUMN_AGE:
    personList[row].age = parseInt(fmt"{tableValueString(val)}")

var
  mh: TableModelHandler
  p: TableParams
  tp: TableTextColumnOptionalParams

proc main*() =
  var mainwin: Window

  var menu = newMenu("File")
  menu.addQuitItem(proc(): bool {.closure.} =
    mainwin.destroy()
    return true)

  mainwin = newWindow("uiTable", 640, 280, true)
  mainwin.margined = true
  mainwin.onClosing = (proc (): bool = return true)

  let box = newVerticalBox(true)
  mainwin.setChild(box)

  mh.numColumns = modelNumColumns
  mh.columnType = modelColumnType
  mh.numRows = modelNumRows
  mh.cellValue  = modelCellValue
  mh.setCellValue = modelSetCellValue
  


  p.model = newTableModel(addr mh)
  p.rowBackgroundColorModelColumn = 4

  tp.ColorModelColumn =1

  var table = newTable(addr p)
  table.appendTextColumn("ID", COLUMN_ID, TableModelColumnNeverEditable,nil)
  table.appendTextColumn("Nom", COLUMN_NOM, TableModelColumnAlwaysEditable, nil)
  table.appendTextColumn("Prenom", COLUMN_PRENOM, TableModelColumnAlwaysEditable, nil)
  table.appendTextColumn("Age", COLUMN_AGE, TableModelColumnAlwaysEditable, nil)
 
  
  box.add(table, true)
  show(mainwin)
 


init()
main()
mainLoop()