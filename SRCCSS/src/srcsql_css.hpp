///  fichier : /home/soleil/GTK/srcsql/src/srcsql.css
///  2019-09-11.17:43:03

const char*  buildcss =
".entry {"\
"color: #0000FF;"\
"font: 18px 'Monospace';"\
"}"\
".button {"\
"color: #A52A2A;"\
"font: 18px 'Monospace';"\
"}"\
".label {"\
"color: #000000;"\
"font: 18px 'Monospace';"\
"}"\
".grid {"\
"font: 18px 'Monospace';"\
"}";
unsigned long lencss = strlen(buildcss);

/* Ouverture du fichier Css */
GtkCssProvider *css_provider = gtk_css_provider_new ();

gtk_css_provider_load_from_data (css_provider, buildcss,lencss,NULL);

gtk_style_context_add_provider_for_screen(gdk_screen_get_default(),\
		GTK_STYLE_PROVIDER(css_provider),GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
