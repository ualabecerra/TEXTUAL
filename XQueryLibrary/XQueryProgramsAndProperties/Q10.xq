import module namespace tc = "test_cases" at "tc3.xq";
 
declare function tc:q10($file)
{
<results>
  {
    let $doc := $file
    for $t in distinct-values($doc//book/title)
    let $p := $doc//book[title = $t]/price
    return
      <minprice title="{ $t }">
        <price>{ min($p) }</price>
      </minprice>
  }
</results> 
};

declare function tc:i10($file)
{
  true()
};

declare function tc:o10($results)
{
count($results)>count(distinct-values($results/@title)) 
};

declare function tc:io10($file,$results)
{
 $results/minprice/price = min(let $books := $file//book
 where $books/title = $results/minprice/@title
 return $books/price)
};
 
declare function tc:ni10($file)
{
 not( true())
};

declare function tc:no10($results)
{
not(count($results)>count(distinct-values($results/@title)) )
};

declare function tc:nio10($file,$results)
{
not( $results/minprice/price = min(let $books := $file//book
 where $books/title = $results/minprice/@title
 return $books/price))
};


tc:tester(doc("/Users/antoniobecerra/Desktop/testing-antonio/schemai_q10.xsd"),
"tc:q10","tc:i10","tc:o10","tc:nio10",5)

 