module namespace tc = "test_cases";

(: ELEMENTS, SEQUENCES AND ATTRIBUTES :)

declare function tc:elements($schema)
{
  $schema/xs:schema/xs:element union $schema/xs:schema/xs:element//xs:element
};

declare function tc:sequences($schema)
{
  $schema/xs:schema/xs:element//xs:sequence
};

declare function tc:attributes($schema)
{
  $schema/xs:schema/xs:element//xs:attribute
};


declare function tc:elems_or_seqs($schema)
{
  $schema/xs:schema/xs:element union $schema/xs:schema/xs:element//(xs:element|xs:sequence)
};

(: DELETE REF :)

declare function tc:delete_ref($schema)
{
copy $new := $schema
modify(
delete node tc:elements($new)[@ref]
)
return $new
};

(: INSERT OCCURS:)

declare function tc:insert_Occurs($schema)
{
let $new2 :=
(copy $new := $schema
modify(
for $min in tc:elems_or_seqs($new)[not(@minOccurs)]
return
insert node attribute minOccurs {'1'} into $min 
)
return 
$new
)
return
copy $new3 := $new2
modify
(
for $min in tc:elems_or_seqs($new3)[not(@maxOccurs)]
return
insert node attribute maxOccurs {'1'} into $min 
)
return $new3
};

(:UNFOLD:)

declare function tc:unfold($schema,$u)
{
let $ref := tc:elements($schema)/@ref
for $i in $u to count($ref)
return
let $pos := $schema/xs:schema/xs:complexType[@name=$ref[$i]]
return
copy $new := $schema
modify
(
let $elem := tc:elements($new)[@ref=$ref[$i]]
return
replace node $elem with element {"xs:element"} {
  $pos/@name,$elem/@minOccurs,$elem/@maxOccurs,<xs:complexType>{$pos/*}</xs:complexType>}
)
return $new

};

(: LESSOCCURS :)

declare function tc:lessOccurs($min,$max)
{
if ($max=-1) then true()
else $min<$max
};

(: INDEX-OF-NODE :) 
 
declare function tc:index-of-node
  ( $nodes as node()* ,
    $nodeToFind as node() )  as xs:integer* {

  for $seq in (1 to count($nodes))
  return $seq[$nodes[$seq] is $nodeToFind]
 } ;

(: PATH-TO-NODE-WITH-POS :)

declare function tc:path-to-node-with-pos
  ( $node as node()? )  as xs:string {

string-join(
  for $ancestor in $node/ancestor-or-self::*
  let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
  return concat(name($ancestor),
   if (count($sibsOfSameName) <= 1)
   then ''
   else concat(
      '[',tc:index-of-node($sibsOfSameName,$ancestor),']'))
 , '/')
 } ;
 
(: PATH-TO-NODE :)

declare function tc:path-to-node
  ( $nodes as node()* )  as xs:string* {

$nodes/string-join(ancestor-or-self::*/name(.), '/')
 } ;
 
(: GETTYPES :)

declare function tc:getTypes($structure)
{
  for $type in $structure//@type return <type>{tc:path-to-node-with-pos($type)}</type>
};

(:GETTYPESNAME:)

declare function tc:getTypesName($structure)
{
  for $type in $structure//@type return <type>{data($type)}</type>
};

(: GETVALUES :)

declare function tc:getValues($schema,$type)
{ 
  for $value in data($schema/xs:simpleType[@name=$type]/xs:restriction/xs:enumeration/@value)
  return
  <value>{$value}</value>
};

(: GETVAL :)

declare function tc:getVal($schema,$types)
{
 for $type in $types return 
 let $values := tc:getValues($schema,$type/text())
 return
 if  (empty($values)) then 
 if ($type/text()="xs:string") then <values><value>default</value></values>
 else if ($type/text()="xs:decimal") then <values><value>0</value></values>
 else if ($type/text()="xs:date") then <values><value>2000-01-01</value></values>
 else if ($type/text()="xs:negativeInteger") then <values><value>-1</value></values>
 else if ($type/text()="xs:positiveInteger") then <values><value>1</value></values>
 else <values><value>0</value></values>
 else <values>{$values}</values>
};

(: SIMPLETYPESCHEMA :)

declare function tc:simpleTypeSchema($schema)
{
  $schema/xs:simpleType
};

(: NAMESIMPLETYPE :)

declare function tc:nameSimpleType($simpletype)
{
  $simpletype/@name
};

(: BASESIMPLETYPE :)

declare function tc:baseSimpleType($simpletype)
{
  $simpletype/xs:restriction/@base
};

(: VALUESSIMPLETYPE :)

declare function tc:valuesSimpleType($simpletype)
{
  $simpletype/xs:restriction/xs:enumeration/@value
};

(: ELEMENTSCHEMA :)

declare function tc:elementSchema($schema)
{
  $schema/xs:element
};

(: NAMEELEMENT :)

declare function tc:nameElement($element)
{
  $element/@name
};

(: TYPEELEMENT :)

declare function tc:typeElement($element)
{
  $element/@type
};

(: MINOCCURSELEMENT :)

declare function tc:minOccursElement($element)
{
  if ($element/@minOccurs) then $element/@minOccurs else 1 

};

(: MAXOCCURSELEMENT :)

declare function tc:maxOccursElement($element)
{
  
  if ($element/@maxOccurs="unbounded") then -1
  else $element/@maxOccurs
  
};

(: COMPLEXTYPEELEMENT :)

declare function tc:complexTypeElement($element)
{
 $element/xs:complexType
};

(: SEQUENCECOMPLEXTYPE :)

declare function tc:sequenceComplexType($complexType)
{
  $complexType/xs:sequence
};

(: ATTRIBUTECOMPLEXTYPE :)

declare function tc:attributeComplexType($complexType)
{
  $complexType/xs:attribute
};

(: MINOCCURSSEQUENCE :)

declare function tc:minOccursSequence($sequence)
{
  if ($sequence/@minOccurs) then $sequence/@minOccurs else 1
};

(: MAXOCCURSSEQUENCE :)

declare function tc:maxOccursSequence($sequence)
{
  
  
  if ($sequence/@maxOccurs="unbounded") then -1 else $sequence/@maxOccurs
  
};

(: ELEMENTSSEQUENCE :)

declare function tc:elementsSequence($sequence)
{
  $sequence/xs:element
};

(: NAMEATTRIBUTE :)

declare function tc:nameAttribute($attribute)
{
  $attribute/@name
};

(: TYPEATTRIBUTE :)

declare function tc:typeAttribute($attribute)
{
  $attribute/@type
};

(: USEATTRIBUTE :)

declare function tc:useAttribute($attribute)
{
  $attribute/@use
};


(: SKELETOM :)

declare function tc:skeleton($elements)
{
   (for $element in $elements[not(@ref)]
   
   for $i in 1 to tc:minOccursElement($element)  
   return
   if ($element/xs:complexType) then 
     element {tc:nameElement($element)}{
         let $complexType := tc:complexTypeElement($element)
         return
          (
         let $attributes := tc:attributeComplexType($complexType)
         for $attribute in $attributes[not(@use="optional")]
         return element {tc:nameAttribute($attribute)}
         {
         attribute {"type"}{tc:typeAttribute($attribute)},
         attribute {"attribute"}{"yes"}}
         )
         union
         (
         let $sequence := tc:sequenceComplexType($complexType)
         for $j in 1 to tc:minOccursSequence($sequence) 
         return tc:skeleton(tc:elementsSequence($sequence)) 
         )
         
        
       }
   else  element{tc:nameElement($element)}{tc:typeElement($element), attribute {"attribute"}{"no"}} 
 )
   

};

 

(: POPULATE :)

declare function tc:populate($structure,$types,$values)
{
for $t in  tc:populate_set($structure,$types,$values) 
return
copy $ta := $t
modify (delete node $ta//*[@attribute="yes"])
return $ta
};

(: POPULATESET :)

declare function tc:populate_set($trees,$types,$values)
{
  if (empty($types)) then $trees
  else let $strees := (
       for $value in head($values)/value
       return
       tc:populate_trees($trees,head($types)/text(),$value/text()))
       return tc:populate_set($strees,tail($types),tail($values))
};

(: POPULATETREES :)

declare function tc:populate_trees($trees,$type,$value)
{
   for $tree in $trees return tc:populate_tree($tree,$type,$value)
   
};

(: POPULATETREE :)

declare function tc:populate_tree($tree,$type,$value)
{
let $pos := $tree//*[tc:path-to-node-with-pos(.)=$type]
return
if ($pos/@attribute="no")
then
copy $new := $tree
modify(
  replace node $new//*[tc:path-to-node-with-pos(.)=$type] with element {name($pos)} {$value}
)
return $new
else
copy $new := $tree
modify(
  let $parent := $new//*[tc:path-to-node-with-pos(.)=$type]/..
  return
  replace node $parent  with element {name($parent)} {attribute {name($pos)} {$value}, $parent/@*, $parent/* }
)
return $new

};


(: INCREASE :)


declare function tc:increase($schema,$u)
{
tc:increase_element($schema,$u) union tc:increase_attribute($schema,$u) union tc:increase_sequence($schema,$u) union tc:unfold($schema,$u)
};

(: INCREASE_ELEMENT :)

declare function tc:increase_element($schema,$u)
{
let $ies :=(
for $i in $u to count(tc:elements($schema))
let $min := tc:minOccursElement(tc:elements($schema)[$i]) 
let $max := tc:maxOccursElement(tc:elements($schema)[$i])
where tc:lessOccurs($min,$max) and (tc:elements($schema)[$i])[not(@ref)]
return $i)
for $k in $ies 
return
copy $new := $schema
modify(
 let $x := tc:minOccursElement(tc:elements($new)[$k])
 return
 replace value of node $x with $x+1
)
return $new

};

(: INCREASE_ATTRIBUTE :)

declare function tc:increase_attribute($schema,$u)
{
  let $ies :=(
for $i in $u to count(tc:attributes($schema))
where tc:attributes($schema)[$i]/@use="optional"
return $i)
for $k in $ies 
return
copy $new := $schema
modify(
 let $x := tc:attributes($new)[$k]/@use
 return
 replace value of node $x with "required"
)
return $new  
};

(: INCREASE_SEQUENCE :)

declare function tc:increase_sequence($schema,$u)
{
  let $ies :=(
for $i in $u to count(tc:sequences($schema))
let $min := tc:minOccursSequence(tc:sequences($schema)[$i])
let $max := tc:maxOccursSequence(tc:sequences($schema)[$i])
where tc:lessOccurs($min,$max)
return $i)
for $k in $ies 
return
copy $new := $schema
modify(
 let $x := tc:minOccursSequence(tc:sequences($new)[$k])
 return
 replace value of node $x with $x+1
)
return $new
};


declare function tc:test_cases_property($schema,$i,$property)
{
for $sch in tc:generate_schemas(tc:insert_Occurs($schema),$i)
let $structure := tc:skeleton($sch/xs:schema/xs:element)
let $examples := tc:populate($structure,tc:getTypes($structure),tc:getVal($sch/xs:schema,tc:getTypesName($structure)))
for $example in $examples
return $example
};


(: TEST_CASES :)

declare function tc:test_cases($schema,$i)
{
for $sch in tc:generate_schemas(tc:insert_Occurs($schema),$i)
let $structure := tc:skeleton($sch/xs:schema/xs:element)
let $examples := tc:populate($structure,tc:getTypes($structure),tc:getVal($sch/xs:schema,tc:getTypesName($structure)))
for $example in $examples
return $example 
}; 

(: GENERATE_SCHEMAS :)

declare function tc:generate_schemas($schema,$i)
{
if ($i=0) then $schema
          else let $count := count($schema)
          let $new := (for $k in 1 to $count return tc:increase($schema[$k],$k))
          return $schema union tc:generate_schemas($new,$i - 1)               
};


(: TESTER: MAIN FUNCTION :)

declare function tc:tester($schema as node()*,$query as xs:string,$pinput as xs:string,$poutput as xs:string,$pin-out as xs:string,$i as xs:integer)
{
  tc:tester_loop($schema,$query,$pinput,$poutput,$pin-out,0,$i,0,0)
};

(: TESTER_LOOP :)

declare function tc:tester_loop($schema as node()*,$query as xs:string,$pinput as xs:string,$poutput as xs:string,$pin-out as xs:string,$k as xs:integer, $i as xs:integer,$tests as xs:integer,$empties as xs:integer)
{
if ($k>$i) then
  if ($tests=$empties) then tc:show_unable()
  else tc:show_passed($tests,$empties)
else 
tc:tester_schema($schema,$schema,$query,$pinput,$poutput,$pin-out,$k,$i,$tests,$empties)
}; 

(: TESTER_SCHEMA :)

declare function tc:tester_schema($schemas as node()*,$all as node()*,$query as xs:string,$pinput as xs:string, $poutput as xs:string,$pin-out as xs:string,$k as xs:integer,$i as xs:integer,$tests as xs:integer,$empties as xs:integer)
{
  if (empty($schemas)) then let $new := tc:new_schemas($all)
                        return
                        tc:tester_loop($new,$query,$pinput,$poutput,$pin-out,$k + 1,$i,$tests,$empties)
                       else 
                       let $sc := head($schemas)
                       let $structure := tc:skeleton($sc/xs:schema/xs:element)
                       let $examples := 
                       tc:populate($structure,tc:getTypes($structure),
                       tc:getVal($sc/xs:schema,tc:getTypesName($structure)))
                       
                       let $fpinput:=function-lookup(xs:QName($pinput),1)
                       let $fpin-out := function-lookup(xs:QName($pin-out),2)
                       let $fpoutput:=function-lookup(xs:QName($poutput),1)
                       let $fquery := function-lookup(xs:QName($query),1)
                       let $total := count($examples) return
                       if (not($total=0)) then
                       
                       (: INPUT PROPERTY :)
                       let $input := (for $valid in $examples 
                       where $fpinput(<root>{$valid}</root>) return
                       <root>{$valid}</root>)
                       (:let $vinput := count($input)
                       return:)
                       (:if ($vinput=0) then tc:show_fail_pre() 
                       else
                       :)
                       (: OUTPUT PROPERTY :)
                       let $output := (for $valid in $input
                       let $result := $fquery($valid)
                       where  not($fpoutput($result)) return 
                       if (empty($result)) then <empty/> else $valid)
                       
                       let $outputnoempty := $output[not(name(.)="empty")]
                       
                       
                       (: INPUT-OUTPUT PROPERTY :)
                       
                       let $in-out := (for $valid in $input
                       let $result := $fquery($valid)
                       where not($fpin-out($valid,$result)) return 
                       if (empty($result)) then <empty/> else $valid)
                       
                       let $in-outnoempty := $in-out[not(name(.)="empty")]
                       
                       let $falseoutput := count($outputnoempty)+count($in-outnoempty)
                       
                       (: EMPTY RESULTS SATISFYING OUTPUT PROPERTIES:)
                       
                       let $newempties :=  count($output[name(.)="empty"])+$empties
                       let $newtests := $tests + count($input)
                       
                       return 
                       if ($falseoutput=0) then
                       tc:tester_schema(tail($schemas),$all,$query,$pinput,$poutput,$pin-out,$k,$i,
                       $newtests,$newempties)
                      
                       else 
                       if (count($outputnoempty)>0) then
                       tc:show_falsifiable_output($newtests,$outputnoempty)
                       else  
                       tc:show_falsifiable_input_output($newtests,$in-outnoempty)
                       else if ($tests=$empties) then tc:show_unable()
                                     else tc:show_passed($tests,$empties)
             
};


declare function tc:show_fail_pre()
{
<Text>
Input property cannot be satisfied.
</Text>/text()
};


(: SHOW_PASSED :)

declare function tc:show_passed($tests,$empties)
{
<Text>
Ok: passed {$tests} tests.
Trivial: {$empties} tests.
</Text>/text() 
};

(: SHOW_UNABLE :)

declare function tc:show_unable()
{
<Text>
Unable to test the property.
</Text>/text() 
};

(: SHOW_FALSIFIABLE :)

declare function tc:show_falsifiable_output($tests,$counter)
{
<Text>
Output Property Falsifiable after {$tests} tests.
Counterexamples:
{for $c in $counter/* return $c}
</Text>/(text() | *) 
};

declare function tc:show_falsifiable_input_output($tests,$counter)
{
<Text>
Input-Output Property Falsifiable after {$tests} tests.
Counterexamples:
{for $c in $counter/* return $c}
</Text>/(text() | *) 
};

(: SHOW_FAIL_PROPERTY:)

declare function tc:show_fail_property($property)
{
<Text>
The property: {$property} does not exists.
</Text> 
};

(: NEW_SCHEMAS :)

declare function tc:new_schemas($schema)
{
let $count := count($schema)
let $new := (for $k in 1 to $count return tc:increase($schema[$k],$k))
return $new              
};




