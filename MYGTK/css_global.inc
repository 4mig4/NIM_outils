#  fichier : /home/soleil/NIM/MYGTK/css_global.css
#  2019-10-28.11:16:48

const cssString =".entry {color: #0000FF;font-style: normal;font-family:'monospace';font-size: 1em;}.button {color: black;border: 4px solid rgb(76, 175, 158);font-style: normal;font-family:'monospace';font-size: 1em;}.text {color: #0000FF;font-style: italic;font-family:'monospace';font-size: 1em;}.grid {font-style: normal;font-family:'monospace';font-size: 1em;}.treeview {color: rgb(3, 3, 3);background: rgb(4, 198, 246);font-style: normal;font-family:'monospace';font-size: 1em;}.treeview:selected {background: rgb(3, 3, 3);color: rgb(4, 198, 246);}"

# Ouverture du fichier Css
var provider = newCssProvider()

discard provider.loadFromData(cssString)

addProviderForScreen(getDefaultScreen(), provider, STYLE_PROVIDER_PRIORITY_APPLICATION)
