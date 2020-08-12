function shift(n  , k, fs) { 
  if (n == "") { 
    n = 1 
  } else if (n < 0) { 
    exit 33 
  } 
  fs = (FS == " " ? "[ \t]+" : FS) 
  if (FS == " ") sub(/^[ \t]*/, "") 
  while (n-- > 0) { 
    if (match(substr($0, k), fs) > 0) { 
      k += RSTART + RLENGTH 
    } else { 
      k += length 
      break 
    } 
  } 
  $0 = substr($0, k) 
}
BEGIN{ shift()
    a=sprintf("%s %d", $0,FS)
    print a
}
