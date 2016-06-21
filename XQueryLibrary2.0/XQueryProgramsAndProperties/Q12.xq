import module namespace tc = "test_cases" at "tc5.xq";

declare function tc:q12($args)
{
<bib>
{
    for $book1 in $args/args/fst//book,
        $book2 in $args/args/snd//book
    let $aut1 := for $a in $book1/author 
                 order by $a/last, $a/first
                 return $a
    let $aut2 := for $a in $book2/author 
                 order by $a/last, $a/first
                 return $a
    where $book1 << $book2
    and not($book1/title = $book2/title)
    and deep-equal($aut1, $aut2) 
    return
        <book-pair>
            { $book1/title }
            { $book2/title }
        </book-pair>
}
</bib> 
};

declare function tc:i12($args)
{
  true()
};

declare function tc:o12($results)
{
 every $book in $results/book-pair satisfies count(distinct-values($book/title))=2
};

declare function tc:io12($args,$results)
{
  true()
};

declare function tc:ni12($args)
{
 not ( true())
};

declare function tc:no12($results)
{
not( every $book in $results/book-pair satisfies count(distinct-values($book/title))=2)
};

declare function tc:nio12($args,$results)
{
not (  true())
};

tc:tester(doc("schemai_q12.xsd"),"tc:q12","tc:i12","tc:o12","tc:nio12",5,())

