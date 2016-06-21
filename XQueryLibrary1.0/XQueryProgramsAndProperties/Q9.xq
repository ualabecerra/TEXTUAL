import module namespace tc = "test_cases" at "tc3.xq";

declare function tc:q9($file)
{
<results>
  {
    for $t in $file//(chapter | section)/title
    where contains($t/text(), "XML")
    return $t
  }
</results>
};

declare function tc:i9($file)
{
  true()
};

declare function tc:o9($results)
{
every $result in $results satisfies contains($result/text(),'XML')
};

declare function tc:io9($file,$results)
{
every $title in $results satisfies some $f in $file//(chapter | section)/title satisfies not($title/text()=$f/text())
};

declare function tc:ni9($file)
{
 not( true())
};

declare function tc:no9($results)
{
not (every $result in $results satisfies contains($result/text(),'XML'))
};

declare function tc:nio9($file,$results)
{
not (every $title in $results satisfies some $f in $file//(chapter | section)/title satisfies not($title/text()=$f/text()))
};


tc:tester(doc("/Users/antoniobecerra/Desktop/testing-antonio/schemai_q9.xsd"),
"tc:q9","tc:i9","tc:o9","tc:nio9",5)