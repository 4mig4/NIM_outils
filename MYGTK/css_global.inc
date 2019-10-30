#  fichier : /home/soleil/NIM/MYGTK/css_global.css
#  2019-10-30.03:24:55

const cssString =".entry {font-style: normal;font-family:'monospace';font-size: 1em;}.button {border: 2px solid #006400;font-style: normal;font-family:'monospace';font-size: 1em;}.text {font-style: italic;font-family:'monospace';font-size: 1em;}.treeview {color: #000000;font-style: normal;font-family:'monospace';font-size: 1em;}.treeview:selected {background: #000000;color: 	#00FFFF;}"

# Ouverture du fichier Css
var provider = newCssProvider()

discard provider.loadFromData(cssString)

addProviderForScreen(getDefaultScreen(), provider, STYLE_PROVIDER_PRIORITY_APPLICATION)
