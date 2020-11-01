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


/*  const cssString = # note: big font selected intentionally
    """treeview{background-color: rgba(0,255,255,1.0); font-size:30pt} treeview:selected{background-color:
    rgba(255,255,0,1.0); color: rgba(0,0,255,1.0);}"""
  var provider  = newCssProvider()
  discard provider.loadFromData(cssString)
  addProviderForScreen(getDefaultScreen(), provider, STYLE_PROVIDER_PRIORITY_APPLICATION)
*/
/// ecriture formaté du file.hpp pour intégrer dans votre source			
		fwrite<<"#  fichier : "<<fileCss<<endl;
		fwrite<<"#  " <<currentDateTime()<<endl;
		fwrite<<""<<endl;


		fwrite<<"const cssString =\"";
/// lecture du fichier .css

		while(getline(fread, contenu))
		{
			replace(contenu.begin(), contenu.end(), '"', '\'');
			fwrite <<Trim(contenu);
		}
		fwrite <<"\""<<endl;
		fwrite<<""<<endl;
		fwrite<<"# Ouverture du fichier Css"<<endl;
		fwrite<<"var provider = newCssProvider()"<<endl;
		fwrite<<""<<endl;
		fwrite<<"discard provider.loadFromData(cssString)"<<endl;
		fwrite<<""<<endl;
		fwrite<<"addProviderForScreen(getDefaultScreen(), provider, STYLE_PROVIDER_PRIORITY_APPLICATION)"<<endl;

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
