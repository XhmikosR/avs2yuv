#******************************************************************************
#*
#*  makefile.mak
#*    makefile for building with WDK
#*
#*  Copyright (C) 2011-2012 XhmikosR
#*
#*  This program is free software: you can redistribute it and/or modify
#*  it under the terms of the GNU General Public License as published by
#*  the Free Software Foundation, either version 3 of the License, or
#*  (at your option) any later version.
#*
#*  This program is distributed in the hope that it will be useful,
#*  but WITHOUT ANY WARRANTY; without even the implied warranty of
#*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#*  GNU General Public License for more details.
#*
#*  You should have received a copy of the GNU General Public License
#*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#*
#*
#*  Use build_wdk.bat and set there your WDK directory.
#*
#******************************************************************************


# Remove the .SILENT directive in order to display all the commands
.SILENT:


CC = cl.exe
LD = link.exe
RC = rc.exe


SRC       = .
BINDIR    = WDK
OBJDIR    = $(BINDIR)\obj
EXE       = $(BINDIR)\avs2yuv.exe

DEFINES   = /D "_WINDOWS" /D "NDEBUG" /D "WIN32" /D "_WIN32_WINNT=0x0500"
CPPFLAGS  = /nologo /c /Fo"$(OBJDIR)/" /W3 /EHsc /MD /O2 /GL /MP $(DEFINES)
LDFLAGS   = /NOLOGO /WX /INCREMENTAL:NO /RELEASE /OPT:REF /OPT:ICF /SUBSYSTEM:CONSOLE \
            /MACHINE:X86 /LTCG msvcrt_win2000.obj
RFLAGS    = /l 0x0409 /d "WIN32" /d "NDEBUG"


# Targets
BUILD:	CHECKDIRS $(EXE)

CHECKDIRS:
	IF NOT EXIST "$(OBJDIR)" MD "$(OBJDIR)"

CLEAN:
	ECHO Cleaning... & ECHO.
	IF EXIST "$(EXE)"                DEL "$(EXE)"
	IF EXIST "$(OBJDIR)\*.obj"       DEL "$(OBJDIR)\*.obj"
	IF EXIST "$(OBJDIR)\avs2yuv.res" DEL "$(OBJDIR)\avs2yuv.res"
	-IF EXIST "$(OBJDIR)"            RD /Q "$(OBJDIR)"
	-IF EXIST "$(BINDIR)"            RD /Q "$(BINDIR)"

REBUILD:	CLEAN BUILD


# Object files
OBJECTS= \
    $(OBJDIR)\avs2yuv.obj \
    $(OBJDIR)\avs2yuv.res


# Batch rule
{$(SRC)\}.cpp{$(OBJDIR)}.obj::
    $(CC) $(CPPFLAGS) /Tp $<


# Commands
$(EXE): $(OBJECTS)
	$(RC) $(RFLAGS) /fo"$(OBJDIR)\avs2yuv.res" "$(SRC)\avs2yuv.rc" >NUL
	$(LD) $(LDFLAGS) /OUT:"$(EXE)" $(OBJECTS)


# Dependencies
$(OBJDIR)\avs2yuv.obj: \
    $(SRC)\avs2yuv.cpp \
    $(SRC)\avisynth.h \
    $(SRC)\internal.h

$(OBJDIR)\avs2yuv.res: \
    $(SRC)\avs2yuv.rc
