#  fichier : /home/soleil/GTK/srccssnim/bin/srcsql.css
#  2020-11-01.05:58:12

const cssString =".entry {color: #0000FF;font: 18px 'Monospace';}.button {color: #A52A2A;font: 18px 'Monospace';}.label {color: #000000;font: 18px 'Monospace';}.grid {font: 18px 'Monospace';}"

# Ouverture du fichier Css
var provider = newCssProvider()

discard provider.loadFromData(cssString)

addProviderForScreen(getDefaultScreen(), provider, STYLE_PROVIDER_PRIORITY_APPLICATION)
