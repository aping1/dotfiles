
function find_dupes () 
{  
    shasum5.18 -a 256 */**/*.{csr,key,json,out,pem,crt} | grep -f <(shasum -a 256 */**/*.{csr,key,json,out,pem,crt} | awk '{ print $1}' | uniq -d ; echo -e '$' ) 
}

## Print a horizontal rule
function rule () {
	printf -v _hr "%*s" $(tput cols) && echo ${_hr// /${1--}}
}
