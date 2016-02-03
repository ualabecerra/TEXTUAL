import module namespace tc = "test_cases" at "tc3.xq";

declare function tc:q3($file)
{
<results>
{
    for $b in $file/bib/book
    return
        <result>
            { $b/title }
            { $b/author  }
        </result>
}
</results> 
};

declare function tc:i3($file)
{
  every $book in $file/bib/book satisfies not($book/author)
};

declare function tc:o3($results)
{
  every $result in $results/result satisfies $result/title and $result/author
};

declare function tc:io3($file,$results)
{
  true()
};

declare function tc:ni3($file)
{
 not( every $book in $file/bib/book satisfies not($book/author) )
};

declare function tc:no3($results)
{
 not( every $result in $results/result satisfies $result/title and $result/author)
};

declare function tc:nio3($file,$results)
{
 not( true())
};

tc:tester(doc("/Users/antoniobecerra/Desktop/testing-antonio/schemai_q3.xsd"),
"tc:q3","tc:i3","tc:o3","tc:nio3",5)
