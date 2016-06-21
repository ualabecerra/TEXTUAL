import module namespace tc = "test_cases" at "tc5.xq";


declare function tc:q8($file)
{
for $b in $file//book
let $e := $b/*[contains(string(.), "Suciu") 
               and ends-with(local-name(.), "or")]
where exists($e)
return
    <book>
        { $b/title }
        { $e }
    </book> 
};

declare function tc:i8($file)
{
  true()
};

declare function tc:o8($books)
{
every $book in $books satisfies 
        every $item in $book/* satisfies contains(string($item),"Suciu") or name($item)="title"
};

 

declare function tc:io8($file,$books)
{
  true()
};

declare function tc:ni8($file)
{
 not ( true())
};

declare function tc:no8($books)
{
not (every $book in $books satisfies 
        every $item in $book/* satisfies contains(string($item),"Suciu") or name($item)="title" )
};

declare function tc:nio8($file,$books)
{
  not (true())
};

tc:tester(doc("schemai_q8.xsd"),"tc:q8","tc:i8","tc:o8","tc:nio8",5,())
 