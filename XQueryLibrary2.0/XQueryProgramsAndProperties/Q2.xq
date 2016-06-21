import module namespace tc = "test_cases" at "tc5.xq";

declare function tc:q2($file)
{
 <results> 
 { 
  for $b in $file/bib/book
  for $t in $b/title
 for $a in $b/author 
 return 
 <result> 
 { $t }
{ $a } 
 </result>
 }
 </results> 
};


declare function tc:i2($file)
{
  true()
};

declare function tc:o2($results)
{
every $result in $results/result satisfies $result/title and $result/author
};

declare function tc:io2($file,$results)
{
every $bi in $file/bib/book satisfies some $bo in $results/result satisfies $bo/title=$bi/author
};

declare function tc:ni2($file)
{
 not (true())
};

declare function tc:no2($results)
{
not (every $result in $results/result satisfies $result/title and $result/author)
};

declare function tc:nio2($file,$results)
{
not (every $bi in $file/bib/book satisfies some $bo in $results/result satisfies $bo/title=$bi/author)
};

tc:tester(doc("schemai_q2.xsd"),"tc:q2","tc:i2","tc:o2","tc:io2",5,())

