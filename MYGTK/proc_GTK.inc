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
  var x = newButton(sName)
  x.set_name(sText)
  if style :
    var  contextx: StyleContext
    contextx = getStyleContext(x)
    contextx.addClass("button")
  return x

proc mTreeVwColEdit(sName: string ; col_num: int ; nbrcar: int ; col_color : int ): (TreeViewColumn , CellRendererText) =
  var coln = newTreeViewColumn()
  
  var renderern = newCellRendererText()
  var col_size:int = nbrcar * 12
  setProperty(renderern , "editable", toBoolVal(true))

  coln.setTitle(sName)
  coln.packStart(renderern, true)
  coln.addAttribute(renderern, "text", col_num)
  coln.addAttribute(renderern, "cell-background", col_color)
  coln.setFixedWidth(col_size)
  coln.setMaxWidth(col_size)
  return (coln , renderern)

proc mTreeVwColRead(sName: string; col_num: int ; nbrcar: int ;  col_color: int  ): TreeViewColumn =
  var coln = newTreeViewColumn()

  var renderern = newCellRendererText()
  var col_size:int = nbrcar * 12

  coln.setTitle(sName)
  coln.packStart(renderern, true)
  coln.addAttribute(renderern, "text", col_num)
  coln.addAttribute(renderern, "cell-background", col_color)
  coln.setFixedWidth(col_size)
  coln.setMaxWidth(col_size)
  return coln