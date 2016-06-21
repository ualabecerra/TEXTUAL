import module namespace tc = "test_cases" at "tc5.xq";

declare function tc:q1($file)
{
<bib>
 {
  for $b in $file/bib/book
  where $b/publisher = "Addison-Wesley" and $b/@year > 1991
  return
    <book year="{ $b/@year }">
     { $b/title }
    </book>
 }
</bib> 
};

declare function tc:i1($bib)
{
   every $b in $bib/bib/book satisfies $b/@year >1991 (:and $b/publisher = "Addison-Wesley":)
};

declare function tc:o1($bib)
{
  every $b in $bib/book satisfies $b/@year>1991
};

declare function tc:io1($bibi,$bibo)
{
every $bi in $bibi/bib/book satisfies some $bo in $bibo/book satisfies $bo/title=$bi/title 
};

declare function tc:ni1($bib)
{
 not(  every $b in $bib/bib/book satisfies $b/@year >1991 (:and $b/publisher = "Addison-Wesley":) )
};

declare function tc:no1($bib)
{
 not ( every $b in $bib/book satisfies $b/@year>1991 )
};

declare function tc:nio1($bibi,$bibo)
{
not (every $bi in $bibi/bib/book satisfies some $bo in $bibo/book satisfies $bo/title=$bi/title )
};

tc:tester(doc("schemai_q1.xsd"),"tc:q1","tc:i1","tc:o1","tc:io1",1,())
