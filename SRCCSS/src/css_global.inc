#  fichier : /home/soleil/GTK/srccssnim/bin/css_global.css
#  2020-11-01.05:56:15

const cssString =".entry {color: #0000FF;font-style: normal;font-family:'monospace 20';}.button {color: black;border: 4px solid rgb(76, 175, 158);font-style: normal;font-family:'monospace 20';}.label {color: #0000FF;font-style: italic;font-family:'monospace 20';}.grid {font-style: normal;font-family:'monospace 20';}.treeview {background: rgba(0,255,255,1.0);font-style: normal;font-family:'monospace';font-size: 2mm;}.treeview:selected {background: rgba(255,255,0,1.0);color: rgba(0,0,255,1.0);}"

# Ouverture du fichier Css
var provider = newCssProvider()

discard provider.loadFromData(cssString)

addProviderForScreen(getDefaultScreen(), provider, STYLE_PROVIDER_PRIORITY_APPLICATION)
