#include <unistd.h>
#include <cstring>
#include <stdio.h>
#include <time.h>

#include <iostream>
#include <fstream>
#include <algorithm>
 

using namespace std;




/// affichage help ou rappel si passage de paramètre en erreur

static void show_usage()
{

	cerr <<"Options:" << endl;
	cerr <<"-h -H,--help                        Show this help message" << endl;
	cerr <<"-p -P,--path           Path......   Specify the path" << endl;
	cerr <<"-f -F,--file           File......   specify the file" << endl; 
	
	cerr <<"\nex: -p \"/home/xxx/GTK/\"  -f \"DYSPLAY\" " << endl; 

}
 

/// Get current date/time, format is YYYY-MM-DD.HH:mm:

const std::string currentDateTime()
{
    time_t     now = time(0);
    struct tm  tstruct;
    char       buf[80];
    tstruct = *localtime(&now);
    strftime(buf, sizeof(buf), "%Y-%m-%d.%X", &tstruct);

    return buf;
}


/// trim du contenu

string Trim(string  _bufstring)
{
	string s = _bufstring ;
	std::string::const_iterator it = s.begin();
	while (it != s.end() && isspace(*it))
	it++;

	std::string::const_reverse_iterator rit = s.rbegin();
	while (rit.base() != it && isspace(*rit))
	rit++;
	s = std::string(it, rit.base());
	return s;
}



int main(int argc, char* argv[])
{
bool P_P  = false; /// parm path
bool P_E  = false; /// parm File

std::string path		="NaN";
std::string file		="NaN";

std::string fileSrc		="NaN";
std::string fileCss		="NaN";

std::string contenu;

std::string arg_PX = argv[1];

	if ((arg_PX == "-h") || (arg_PX == "-H") || (arg_PX == "--help") || argc < 5  || argc > 5 )
	{
		show_usage();
		return EXIT_FAILURE ;
	}



	for(int i = 1 ; i < argc ; i++)
	{	arg_PX = argv[i];
		if ((arg_PX == "-p") || (arg_PX == "-P") || (arg_PX == "--path"))
		{
			if (i + 1 < argc)
			{ // valide le traitement 
				P_P  = true;
				path = argv[i+1]; 
			} 
			else 
			{ // signal l'erreur
				std::cerr << "Path .. option requires one argument." << std::endl;
				return EXIT_FAILURE ;
			}
		}
        
		if ((arg_PX == "-f") || (arg_PX == "-F") || (arg_PX == "--file"))
		{
			if (i + 1 < argc)
			{ // valide le traitement 
				P_E  = true;
				file = argv[i+1]; 
			} else
			{ // signal l'erreur
				std::cerr << "file.. option requires one argument." << std::endl;
				return EXIT_FAILURE ;
			}
		}
	}


	if ( P_P == false ||  P_E == false ) { show_usage(); return EXIT_FAILURE ; }
	

	fileCss	=path + file +".css";
	fileSrc	=path + file +".inc";

	ifstream fread(fileCss.c_str(), ios::in);  // on ouvre le fichier en lecture


/// test si possibilité d'ecrire le file.hpp
 
	if(!fread.fail()) 
	{       
		ofstream fwrite(fileSrc.c_str(), ios::out | ios::trunc);

		if(!fwrite) 
			{
				cerr <<"Impossible d'ouvrir le fichier !" <<fileSrc<< endl;
				return EXIT_FAILURE ;
			}




/// ecriture formaté du file.hpp pour intégrer dans votre source			
		fwrite<<"///  fichier : "<<fileCss<<endl;
		fwrite<<"///  " <<currentDateTime()<<endl;
		fwrite<<""<<endl;


		fwrite<<"const char*  buildcss ="<<endl;
/// lecture du fichier .css
		string xval="";
		while(getline(fread, contenu))
		{
			if ( xval.compare("") != 0) fwrite <<"\""<<xval<<"\"\\"<<endl;
			replace(contenu.begin(), contenu.end(), '"', '\'');
			xval = Trim(contenu);
		}
		fwrite <<"\""<<xval<<"\";"<<endl;
		fwrite<<"unsigned long lencss = strlen(buildcss);"<<endl;
		fwrite<<""<<endl;
		fwrite<<"/* Ouverture du fichier Css */"<<endl;
		fwrite<<"GtkCssProvider *css_provider = gtk_css_provider_new ();"<<endl;
		fwrite<<""<<endl;
		fwrite<<"gtk_css_provider_load_from_data (css_provider, buildcss,lencss,NULL);"<<endl;
		fwrite<<""<<endl;
		fwrite<<"gtk_style_context_add_provider_for_screen(gdk_screen_get_default(),\\"<<endl;
		fwrite<<"		GTK_STYLE_PROVIDER(css_provider),GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);"<<endl;
		/// fin de la fonction from_data
		fread.close(); 
		fwrite.close();
		
	}
	else
	{
		cerr <<"Impossible d'ouvrir le fichier !" <<fileCss<< endl;
		return EXIT_FAILURE ;
	}

return EXIT_SUCCESS;
}
