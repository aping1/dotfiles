#!/bin/awk -f
{ if ( $1 ~ /^ *[[:digit:]]+[*]? */ ) { $1="" }; gsub(/\\n/,RS);print;} 
