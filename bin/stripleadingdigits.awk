#!/bin/awk -f
BEGIN { if ( $1 ~ /^\ *\d\+\*?/ ) { $1="" }}
{ print;} 
