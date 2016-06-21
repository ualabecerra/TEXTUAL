import module namespace tc = "test_cases" at "tc5.xq";

declare function tc:q4($args)
{
<results>
  {
    let $a := $args/args/fst//author
    for $last in distinct-values($a/last),
        $first in distinct-values($a[last=$last]/first)
    order by $last, $first
    return
        <result>
            <author>
               <last>{ $last }</last>
               <first>{ $first }</first>
            </author>
            {
                for $b in $args/args/snd/bib/book
                where some $ba in $b/author 
                      satisfies ($ba/last = $last and $ba/first=$first)
                return $b/title
            }
        </result>
  }
</results>
};

declare function tc:i4($args)
{
  true() 
};

declare function tc:o4($results)
{
 count($results/result/author)>=0
};

declare function tc:io4($args,$results)
{
  every $item in $results/result/title satisfies some $title in $args/args/snd/bib/book/title satisfies $title=$item
};

declare function tc:ni4($args)
{
 not(  true()) 
};

declare function tc:no4($results)
{
 not (count($results/result/author)>=0)
};

declare function tc:nio4($args,$results)
{
not(  every $item in $results/result/title satisfies some $title in $args/args/snd/bib/book/title satisfies $title=$item)
};


tc:tester(doc("schemai_q4.xsd"),"tc:q4","tc:i4","tc:no4","tc:io4”,5,())