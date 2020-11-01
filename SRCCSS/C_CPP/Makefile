# définition des cibles particulières
.PHONY: all mrproper build install clean 

# désactivation des règles implicites
.SUFFIXES:
# nom de l'executable :
EXEC = srccss



# Adresse des sources, des objets et des includes :
SRCDIR = $(CURDIR)/src/
OBJDIR = $(CURDIR)/obj/
BINDIR = $(CURDIR)/bin/



INCLUDES = \
 -I$(SRCDIR)

OBJ = $(OBJDIR)$(EXEC).o  
EXECUTABLE = $(BINDIR)$(EXEC)
INSTALLDIR=$(HOME)/T_LIB/

 
# choix du compilateur :
CXX = g++
# options compilations :
CPPFLAGS=  -Wall -fexpensive-optimizations -O2 -Os -pedantic-errors  -Wextra -std=c++17  -fexceptions -Wparentheses -ftree-coalesce-vars  -fstack-protector

LDFLAGS=    -no-pie
INCLIB= 





# -------------------------------------------------------------------
#  compilation
# -------------------------------------------------------------------
# compilation obj :  ex  #@echo "$(OBJCPP)"



# regle edition de liens  
all: $(OBJ)
	$(CXX)  $(OBJ) -o $(EXECUTABLE)   $(LDFLAGS) -s $(INCLIB)  
 
# regle de compilation des sources objet
$(OBJDIR)%.o: $(SRCDIR)%.cpp
	$(CXX)  $(CPPFLAGS) $(INCLUDES)  -o $@ -c $< 


# pour effacer tous les objets :
clean: 
	rm -rf  $(OBJDIR)*.o

	
clean_a: 
	rm -rf  $(OBJDIR)*.o


clean_b:  
	rm -rf  $(OBJDIR)*.o

# pour effacer tous les objet et les executables :
mrproper: clean_a   
	rm -rf $(EXECUTABLE)

# efface objet(s) et affiche la taille de l'objet résultant
build: clean_b
	 du -sh $(EXECUTABLE)
install:
	rm -rf $(INSTALLDIR)$(EXEC)
	cp $(EXECUTABLE) $(INSTALLDIR)
