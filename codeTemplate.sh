#!/bin/bash
# C/C++ and Fortran (F90+) Code template maker
# Written by Mark Herndon
#
# usage:
# ./codeTemplate.sh [-c|-cpp|-f90] [name] [description] -o [outputfile]
# 

# Handle error cases first -- could do this along the way
if [[ -z "$1" ]]; then
    echo "error: no arguments provided"
    echo "usage: ./codeTemplate.sh [-c|-cpp|-f90] [name] [description] -o [outputfile]"
    exit 1;
fi

if [[ -z "$2" ]]; then
    echo "error: no author name provided"
    echo "usage: ./codeTemplate.sh [-c|-cpp|-f90] [name] [description] -o [outputfile]"
    exit 1;
fi

if [[ -z "$3" ]] || [[ "$3" == "-o" ]]; then
	echo "error: no code description provided"
    echo "usage: ./codeTemplate.sh [-c|-cpp|-f90] [name] [description] -o [outputfile]"
	exit 1;
fi

if  [[ "$4" == "-o" ]] && [[ -z "$5" ]]; then 
	echo "error: no object file named"
    echo "usage: ./codeTemplate.sh [-c|-cpp|-f90] [name] [description] -o [outputfile]"
	exit 1
fi

if [[ ! -z "$4" ]] && [[ "$4" != "-o" ]]; then
	echo "error: use '-o' flag to specify object file"
    echo "usage: ./codeTemplate.sh [-c|-cpp|-f90] [name] [description] -o [outputfile]"
	exit 1
fi

# Subsection determines fileType [-c|-cpp] and sets variable accordingly
if [[ "$1" == "-c" ]] ; then
    fileType=c
fi
if [[ "$1" == "-cpp" ]] ; then
    fileType=cpp
fi
if [[ "$1" == "-f90" ]] ; then
    fileType=f90
fi

# Test if no -c or -cpp is specified
if [[ "$1" != "-c" ]] && [[ "$1" != "-cpp" ]] && [[ "$1" != "-f90" ]]; then
    echo "Failure -- specify c, cpp or f90 fileType"
    exit 1
fi

## Subsection determine [name] and [description]
authName=$2
Date=$(date +"%D")
codeDescription=$3
if [[ $4 == -o ]] && [[ -z "$5" ]]; then
    echo "Object file name not provided"
    exit 1
fi

objFile=$5

if [[ -f "$objFile" ]]; then
	echo "$objFile exists. Would you like to replace it? (y/n)"
	read answer
	if [[ "$answer" == "n" ]]; then
		exit 1
	fi
	if [[ "$answer" == "y" ]]; then
		rm $objFile
	fi
fi 

if [[ "$fileType" == "c" ]]; then 
	cat > $objFile <<-ENDOFMESSAGE
	/*	
	    Author: $authName
	    Date: $Date
	    Description: $codeDescription
	*/
	
	#include <stdio.h>
	#include <stdlib.h>
	
	int main(int argc, char** argv)
	{
	    //TODO: Main code
	    return 0;
	}
ENDOFMESSAGE

fi
if [[ "$fileType" == "cpp" ]]; then 
	cat > $objFile <<-ENDOFMESSAGE
	/*
	    Author: $authName
	    Date: $Date
	    Description: $codeDescription
	*/
	
	#include <iostream>
	#include <stdlib.h>
	using namespace std;
	
	int main(int argc, char** argv)
	{
	    //TODO: Main code
	    return 0;
	}
	ENDOFMESSAGE

fi

if [[ "$fileType" == "f90" ]]; then
	echo "Is this is a Fortran module file? (y/n)"
	read mod
	if [[ "$mod" == "n" ]]; then 
		cat > $objFile <<-ENDOFMESSAGE
	!======================================================================
	!	Author: $authName
	!	Date: $Date
	!	Description: $codeDescription
	!======================================================================
	PROGRAM ${objFile%.f90}
	    IMPLICIT NONE
	
	    !!TODO: Main code
	
	END PROGRAM ${objFile%.f90}
	!======================================================================
	ENDOFMESSAGE
	fi
	
	if [[ "$mod" == "y" ]]; then 
		cat > $objFile <<-ENDOFMESSAGE
	!======================================================================
	!	Author: $authName
	!	Date: $Date
	!	Description: $codeDescription
	!======================================================================
	MODULE ${objFile%.f90}
	    IMPLICIT NONE
	
	    !!TODO: VARIABLE AND INTERFACE DECLARATIONS

		CONTAINS
		
		!! SUBROUTINES AND FUNCTIONS


	END MODULE ${objFile%.f90}
	!======================================================================
	ENDOFMESSAGE
	fi
fi	


exit 0
