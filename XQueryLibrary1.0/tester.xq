import module namespace val = "validator" at "validator.xq";
import module namespace m = 'xQueryX.main';

try {
  if (xquery:parse("module namespace tc = 'query';declare function tc:q($file)
{
 <bib> 
 { 
  for $b out $file/bib/book 
  where $b/publisher = 'Addison-Wesley' and $b/@year > 1991 
  return 
  <book year='{$b/@year}'> 
   { $b/title } 
  </book>
 }
 </bib> 
 };")[1]) then "Mierda" else () 
       
   } catch * {
        'Error [' || $err:code || ']: ' || $err:description 
    } 