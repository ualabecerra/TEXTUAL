import module namespace tc = "test_cases" at "tc3.xq";

declare function tc:q7($file)
{
<bib>
  {
    for $b in $file//book
    where $b/publisher = "Addison-Wesley" and $b/@year > 1991
    order by $b/title
    return
        <book>
            { $b/@year }
            { $b/title }
        </book>
  }
</bib> 
};

declare function tc:i7($file)
{
  true()
};

declare function tc:o7($bib)
{
  let $count := count($bib/book)
  return
  every $i in 1 to $count - 1 satisfies $bib/book[$i]/title<=$bib/book[$i+1]/title
};

 

declare function tc:io7($file,$bib)
{
  true()
};

declare function tc:ni7($file)
{
  not (true())
};

declare function tc:no7($bib)
{
not(  let $count := count($bib/book)
  return
  every $i in 1 to $count - 1 satisfies $bib/book[$i]/title<=$bib/book[$i+1]/title )
};

 

declare function tc:nio7($file,$bib)
{
 not ( true())
};

tc:tester(doc("/Users/antoniobecerra/Desktop/testing-antonio/schemai_q7.xsd"),
"tc:q7","tc:i7","tc:no7","tc:io7",5)
 