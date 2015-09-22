LIBMAJOR := 1
LIBMINOR := 0
LIBPATCH := 0

# Nom de l'exécutable
NAME ?= arithmetique
LINKERNAME ?= $(NAME)_library

LIBSTATIC := lib$(LINKERNAME).a
LINKERFILENAME := lib$(LINKERNAME).so
SONAME := $(LINKERFILENAME).$(LIBMAJOR)
REALNAME := $(SONAME).$(LIBMINOR).$(LIBPATCH)

# Compiler, linker, archiver, etc.
CC ?= gcc
# Options de compilation et linker pour le programme
#	Voir 6.7 de la documentation officielle de GNU make
#	pour le mot clef 'override'
override CFLAGS += -Wall
override LDFLAGS += -L.
# Options de compilation et linker pour la bibliothèque
override libCFLAGS += -fPIC -Wall -shared
# Liste de fichiers objets nécessaires pour le programme final
OBJS = main.o
# Liste de fichiers objets nécessaires pour la bibliothèque
libOBJS = add.o sous.o mult.o div.o

###########
# TARGETS #
###########

all: $(NAME).static $(NAME).shared

# Dépendances aux fichiers d'en-têtes, de déclaration des fonctions
$(libOBJS) $(OBJS): fonctions.h

# Construction de libraries shared et static
libs: $(LIBSTATIC) $(LINKERFILENAME) $(SONAME) $(REALNAME)
$(libOBJS): CFLAGS=$(libCFLAGS)
$(LINKERFILENAME) $(SONAME): $(REALNAME)
#	Voir 10.2 de la documentation officielle de GNU make
#	pour l'usage des variables automatiques telles que $@ et $^
$(REALNAME): $(libOBJS)
	$(CC) $(libCFLAGS) -Wl,-soname,$(SONAME) -o $@ $^
	ln -sf $@ $(SONAME)
	ln -sf $@ $(LINKERFILENAME)
$(LIBSTATIC): $(LIBSTATIC)($(libOBJS))

# Construction de programmes shared et static
#	Voir 4.4.6 de la documentation officielle de GNU make
# 	pour l'usage du pré-requis -lTRUC
$(NAME).shared: $(OBJS) -l$(LINKERNAME) $(LINKERFILENAME) $(SONAME) $(REALNAME)
	$(CC) -o $@ $^
$(NAME).static: $(OBJS) $(LIBSTATIC)
	$(CC) -o $@ $^

# Règles d'exécution des programmes shared et static
run: $(NAME).shared
	LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ./$(NAME).shared
runShared: run
runStatic: $(NAME).static
	./$(NAME).static

# Règles de nettoyage
clean: cleanLIB cleanOBJS
	-rm $(NAME).*
cleanLIB:
	-rm $(LIBSTATIC) $(LINKERFILENAME) $(SONAME) $(REALNAME)
cleanOBJS:
	-rm $(libOBJS) $(OBJS)
