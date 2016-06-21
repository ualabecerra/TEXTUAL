import module namespace tc = "test_cases" at "tc5.xq";

declare function tc:q11($args)
{
<bib>
{
        for $b in $args/args/fst//book[author]
        return
            <book>
                { $b/title }
                { $b/author }
            </book>
}
{
        for $b in $args/args/snd//book[editor]
        return
          <reference>
            { $b/title }
            {$b/editor/affiliation}
          </reference>
}
</bib>
};

declare function tc:i11($args)
{
  true()
};

declare function tc:o11($results)
{
 every $book in $results/book satisfies $book/author
};

declare function tc:io11($args,$results)
{
  true()
};


declare function tc:ni11($args)
{
 not( true())
};

declare function tc:no11($results)
{
not ( every $book in $results/book satisfies $book/author)
};

declare function tc:nio11($args,$results)
{
not (  true())
};

tc:tester(doc("schemai_q11.xsd"),"tc:q11","tc:i11","tc:no11","tc:io11",5,())