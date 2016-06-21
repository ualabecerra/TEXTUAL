module namespace xsv = "xs_validator";

(: PENDING: TYPES, CARDINALITY, XML SCHEMAS FEATURES :)

import module namespace m = 'xQueryX.main';
declare namespace xqx="http://www.w3.org/2005/XQueryX";


declare function xsv:val_query($schema,$query)
{
let $sch := doc($schema)
let $paths := xsv:paths_query($query)[not(name(.)="binding")]
return

(xsv:validation(<xs:complexType><xs:sequence>{$sch/xs:schema/xs:element}</xs:sequence></xs:complexType>,$sch,<p></p>,$paths)[1]/text(),'&#xa;')

};

declare function xsv:val_input($schema,$query)
{
let $sch := doc($schema)
let $paths := xsv:paths_query($query)[not(name(.)="binding")]
return
(xsv:validation(<xs:complexType><xs:sequence>{$sch/xs:schema/xs:element}</xs:sequence></xs:complexType>,$sch,<p></p>,$paths)[1]/text(),'&#xa;')  

};

declare function xsv:val_output($schema,$query)
{
let $sch := doc($schema)
let $paths := xsv:paths_query($query)[not(name(.)="binding")]
return
(xsv:validation($sch/xs:schema/xs:element/xs:complexType,$sch,<p></p>,$paths)[1]/text(),'&#xa;')  

};

declare function xsv:val_input_output($schema1,$schema2,$query)
{
let $sch1 := doc($schema1)
let $sch2 := doc($schema2)
let $paths := xsv:paths_query($query)[not(name(.)="binding")]
let $var1 := (m:CodetoXQueryX($query)//xqx:paramList/xqx:param/xqx:varName)[1]/text()
let $var2 := (m:CodetoXQueryX($query)//xqx:paramList/xqx:param/xqx:varName)[2]/text()
return
 
(  
xsv:validation(<xs:complexType><xs:sequence>{$sch1/xs:schema/xs:element}</xs:sequence></xs:complexType>,$sch1,<p></p>,$paths[.//xqx:name=$var1])
union
xsv:validation($sch2/xs:schema/xs:element/xs:complexType,$sch2,<p></p>,$paths[.//xqx:name=$var2])
)[1]/text(),'&#xa;'

};


declare function xsv:string-join2($paths)
{
  string-join($paths//text(),' ')
};


(: BINDING OF A VARIABLE :)

declare function xsv:binding($binding,$xpath)
{
                           if (empty($binding)) 
                           then $xpath
                           else
                             let $thisbinding:=$binding[xqx:varName/text()=$xpath/xqx:name]
                             return  
                             if (empty($thisbinding)) 
                             then $xpath
                             else xsv:path_binding($thisbinding)
                           

                            
};


(: PATH OF A BINDING :) 
 

declare function xsv:path_binding($binding)
{
   
  if ($binding/xqx:varRef) 
  then $binding/xqx:varRef
  else $binding/xqx:pathExpr
};

(: XPATH OF A QUERY :)

declare function xsv:paths_query($file)
{
let $xqueryx := m:CodetoXQueryX($file)
return

(xsv:paths($xqueryx//xqx:functionBody/*,())) 


};


(: SELECT BINDINGS :)

declare function xsv:bd($binding)
{
  $binding[name(.)="binding"]
};

(: SELECT PATHS :)

declare function xsv:pth($binding)
{
   
  $binding[name(.)="xqx:pathExpr" or name(.)="xqx:varRef"] 
  
};


(: PATHS :)

(: PATHS OF A SET OF EXPRESSIONS :)

declare function xsv:paths_set($Expr,$binding)
{
  if (empty($Expr)) then ()
  else xsv:paths(head($Expr),$binding) union xsv:paths_set(tail($Expr),$binding)
};

(: PATHS OF A XQUERY EXPR :)

declare function xsv:paths($Expr,$binding)
{      
      if (count($Expr)>=2) then 
                        xsv:paths_set($Expr,$binding) 
      else
      if (name($Expr)="xqx:flworExpr") then  xsv:paths_flworExpr($Expr/*,$binding)
      else if (name($Expr)="xqx:quantifiedExpr") then xsv:paths_quantifiedExpr($Expr,$binding)
      else if (name($Expr)="xqx:ifThenElseExpr") then xsv:paths_ifThenElseExpr($Expr,$binding)        
      else if (name($Expr)="xqx:rootExpr") then <xqx:rootExpr/>
      else if (name($Expr)="xqx:orOp") then xsv:paths_orOp($Expr,$binding)
      else if (name($Expr)="xqx:andOp") then xsv:paths_andOp($Expr,$binding)
      else if (name($Expr)="xqx:varRef") then  xsv:paths_varRef($Expr,$binding)  
      else if (name($Expr)="xqx:pathExpr") then  xsv:paths_pathExpr($Expr,$binding)  
      else if (name($Expr)="xqx:integerConstantExpr") then () 
      else if (name($Expr)="xqx:decimalConstantExpr") then () 
      else if (name($Expr)="xqx:doubleConstantExpr") then () 
      else if (name($Expr)="xqx:stringConstantExpr") then () 
      else if (name($Expr)="xqx:sequenceExpr") then xsv:paths_sequenceExpr($Expr/*,$binding)
      else if (name($Expr)="xqx:addOp") then xsv:paths_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:substractOp") then xsv:paths_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:multiplyOp") then xsv:paths_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:divOp") then xsv:paths_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:idivOp") then xsv:paths_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:modOp") then xsv:paths_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:unaryMinusOp") then xsv:paths($Expr/xqx:operand/*,$binding)
      else if (name($Expr)="xqx:unaryPlusOp") then xsv:paths($Expr/xqx:operand/*,$binding)
      else if (name($Expr)="xqx:eqOp") then xsv:paths_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:neOp") then xsv:paths_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:gtOp") then xsv:paths_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:geOp") then xsv:paths_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:ltOp") then xsv:paths_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:leOp") then xsv:paths_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:equalOp") then xsv:paths_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:notEqualOp") then xsv:paths_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:lessThanOp") then xsv:paths_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:lessThanOrEqualOp") then xsv:paths_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:greaterThanOp") then xsv:paths_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:greaterThanOrEqualOp") then xsv:paths_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:unionOp") then xsv:paths_unionOp($Expr,$binding) 
      else if (name($Expr)="xqx:intersectOp") then xsv:paths_intersectOp($Expr,$binding) 
      else if (name($Expr)="xqx:exceptOp") then xsv:paths_exceptOp($Expr,$binding) 
      else if (name($Expr)="xqx:orderBySpec") then xsv:paths($Expr/xqx:orderByExpr/*,$binding)
      else if (name($Expr)="xqx:elementConstructor") then xsv:paths_elementConstructor($Expr,$binding) 
      else if (name($Expr)="xqx:functionCallExpr") then xsv:paths_functionCallExpr($Expr,$binding) 
      else if (name($Expr)="xqx:stepExpr") then xsv:paths_stepExpr($Expr,$binding)
      
      else if (name($Expr)="") then ()
      
      (::)
      else if (name($Expr)="xqx:opath") then ()
      (::) 
      
      else error(QName('http://www.w3.org/2005/xqt-errors', "syntax"),"Syntax not supported")
       
       
};



(: PATHS OF AN ELEMENT CONSTRUCTOR :)

declare function xsv:paths_elementConstructor($Expr,$binding)
{
   let $NExpr := (if (count($Expr/xqx:elementContent/*)<=1)
                  then xsv:paths($Expr/xqx:elementContent/*,$binding)
                  else xsv:paths_sequenceExpr($Expr/xqx:elementContent/*,$binding))
   return $NExpr
            
};

(: PATHS OF FUNCTION CALL EXPR :)

declare function xsv:paths_functionCallExpr($Expr,$binding)
{
  for $expr in $Expr/xqx:arguments/*
  return
  xsv:paths($expr,$binding)
};

(: PATHS OF STEP EXPR :)  

declare function xsv:paths_stepExpr($Expr,$binding)
{
  
  if ($Expr/xqx:filterExpr/xqx:varRef) (: Var :)
  then 
    let $bd := xsv:binding($binding,$Expr/xqx:filterExpr/xqx:varRef)
    return 
    if (name($bd)="xqx:varRef") (: Bound to a variable :)
       then 
       <xqx:stepExpr>{<xqx:filterExpr>{$bd}</xqx:filterExpr>}
                         {xsv:predicates($Expr,$binding)}</xqx:stepExpr>   
                         
       else (: Not bound to a variable :)
       $bd/* union xsv:predicates($Expr,$binding) 
   
  
  (: . :)
  
  else if ($Expr/xqx:filterExpr/xqx:contextItemExpr) then ()
  
  (: No Tag :)
  
  else if ($Expr/xqx:filterExpr) then  
          
        <xqx:stepExpr>
        <xqx:paths>{ xsv:paths($Expr/xqx:filterExpr/*,$binding)}</xqx:paths>
        </xqx:stepExpr>
   
   (: Tag :)  
   else  
         <xqx:stepExpr> 
         {$Expr/*[not(name(.)="xqx:predicates")] union xsv:predicates($Expr,$binding)}
         </xqx:stepExpr>
        
};

(: PATHS OF PATH EXPRESSION :)


declare function xsv:paths_pathExpr($path,$binding)
{ 
 let $head := head($path/*)
 return
 if ($head/xqx:filterExpr/xqx:varRef)  then 
 <xqx:pathExpr>{xsv:paths($path/*,$binding)}</xqx:pathExpr>
 else
 (: . :)
 if ($head/xqx:filterExpr/xqx:contextItemExpr) then 
 <xqx:pathExpr>{xsv:paths(tail($path/*),$binding)}</xqx:pathExpr>

 else
 (<xqx:pathExpr>{xsv:paths($head,$binding)}</xqx:pathExpr>
  union
 <xqx:pathExpr>{xsv:opath($head,$binding),xsv:paths(tail($path/*),$binding)}</xqx:pathExpr>)
};


(: OPATH OF AN STEP EXPR :)  

declare function xsv:opath_stepExpr($Expr,$binding)
{
  
  if ($Expr/xqx:filterExpr/xqx:varRef) (: Var :)
  then 
    let $bd := xsv:binding($binding,$Expr/xqx:filterExpr/xqx:varRef)
    return 
    if (name($bd)="xqx:varRef") (: Bound to a variable :)
       then 
       <xqx:stepExpr>{<xqx:filterExpr>{$bd}</xqx:filterExpr>}
       {xsv:lpredicates($Expr,$binding)}</xqx:stepExpr>   
       else $bd/* union xsv:lpredicates($Expr,$binding)    
       
    (: . :)
    else if ($Expr/xqx:filterExpr/xqx:contextItemExpr) then ()
    
    (: No Tag :)      
    else if ($Expr/xqx:filterExpr) then  
    
       xsv:opath($Expr/xqx:filterExpr/*,$binding) 
        
  (: Tag :) 
   else  <xqx:stepExpr>
         {$Expr/*[not(name(.)="xqx:predicates")] union xsv:lpredicates($Expr,$binding)}
         </xqx:stepExpr>  
};

(: OPATH OF PATH EXPRESSION :)

declare function xsv:opath_pathExpr($path,$binding)
{
  let $seq := xsv:opath_sequenceExpr($path/*,$binding)
 return <xqx:pathExpr>{$seq}</xqx:pathExpr>
};

(: PATHS OF PREDICATES :)

declare function xsv:predicates($Expr,$binding)
{
  if ($Expr/xqx:predicates) 
  then 
    let $pth := xsv:paths($Expr/xqx:predicates/*,$binding)    
    return 
    <xqx:predicates>
     
    {xsv:paths($pth,$binding)} 
      
    </xqx:predicates>
  else ()
};

(: PATHS OF BINARY OP :)

declare function xsv:paths_binaryOp($Expr,$binding)
{
   
  xsv:paths($Expr/xqx:firstOperand/*,$binding)
  union
  xsv:paths($Expr/xqx:secondOperand/*,$binding)
   
   
};

(: PATHS OF UNION OP :)

declare function xsv:paths_unionOp($Expr,$binding)
{
    xsv:paths($Expr/xqx:firstOperand/*,$binding)
   union
   xsv:paths($Expr/xqx:secondOperand/*,$binding) 
    
};


(: PATHS OF INTERESECT OP :)

declare function xsv:paths_intersectOp($Expr,$binding)
{
    
   xsv:paths($Expr/xqx:firstOperand/*,$binding)
   union
  xsv:paths($Expr/xqx:secondOperand/*,$binding) 
  
};

(: PATHS OF EXCEPT OP :)

declare function xsv:paths_exceptOp($Expr,$binding)
{
    
   xsv:paths($Expr/xqx:firstOperand/*,$binding)
   union
   xsv:paths($Expr/xqx:secondOperand/*,$binding) 
   
};

(: PATHS OF FLOWR EXPR :)
 

declare function xsv:paths_flworExpr($flworExpr,$binding)
{
        if (empty($flworExpr)) 
        then ()
        else
        if (name(head($flworExpr))="xqx:forClause") then 
          let $result := xsv:paths_forClause(head($flworExpr),$binding) 
          return xsv:pth($result)   union xsv:paths_flworExpr(tail($flworExpr),xsv:bd($result))
        else 
        if (name(head($flworExpr))="xqx:letClause") then
          let $result := xsv:paths_letClause(head($flworExpr),$binding)
          return xsv:pth($result)  union xsv:paths_flworExpr(tail($flworExpr),xsv:bd($result))
        else 
        if (name(head($flworExpr))="xqx:whereClause") then
          let $path := xsv:paths_whereClause(head($flworExpr),$binding)
          return $path   union xsv:paths_flworExpr(tail($flworExpr),$binding)
        else 
          let $path := xsv:paths_returnClause(head($flworExpr),$binding)
          return $path   union xsv:paths_flworExpr(tail($flworExpr),$binding)
};


(: PATHS OF IF THEN ELSE :)

declare function xsv:paths_ifThenElseExpr($ifthenelse,$binding)
{ 
  let $path2 := xsv:paths($ifthenelse/xqx:ifClause/*,$binding)
  let $path3 := xsv:paths($ifthenelse/xqx:thenClause/*,$binding)
  let $path4 := xsv:paths($ifthenelse/xqx:elseClause/*,$binding)
  return
  
  xsv:paths($path2,$binding) union
  xsv:paths($path3,$binding) union
  xsv:paths($path4,$binding) 
   
};

(: PATHS OF OR EXPR :)

declare function xsv:paths_orOp($or,$binding)
{
  let $path2 := xsv:paths($or/xqx:firstOperand/*,$binding)
  let $path3 := xsv:paths($or/xqx:secondOperand/*,$binding)
  return
  
  xsv:paths($path2,$binding) union
  xsv:paths($path3,$binding)
   
   
  
};

(: PATHS OF AND EXPR :)

declare function xsv:paths_andOp($or,$binding)
{
  let $path2 := xsv:paths($or/xqx:firstOperand/*,$binding)
  let $path3 := xsv:paths($or/xqx:secondOperand/*,$binding)
  return
   
   xsv:paths($path2,$binding) union
  xsv:paths($path3,$binding) 
   
};

(: PATHS OF VARIABLE :)

declare function xsv:paths_varRef($var,$binding)
{
  if ($var/xqx:filterExpr) 
  then xsv:binding($binding,$var/xqx:filterExpr/xqx:varRef)
  else xsv:binding($binding,$var)
};


(: PATHS OF FOR CLAUSE:)

declare function xsv:paths_forClause($forClause,$binding)
{  
  for $item in $forClause/xqx:forClauseItem
  let $lpaths := xsv:opath($item/xqx:forExpr/*,$binding)
  let $paths := xsv:paths($item/xqx:forExpr/*,$binding)
  let $bds := (
  
  <binding>{$item/xqx:typedVariableBinding/xqx:varName 
      union $lpaths}</binding>)
  return  
      $paths union $bds union 
      $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)]
};

(: PATHS OF LET CLAUSE :) 

declare function xsv:paths_letClause($letClause,$binding)
{
  for $item in $letClause/xqx:letClauseItem
  let $lpaths := xsv:opath($item/xqx:letExpr/*,$binding)
  let $paths := xsv:paths($item/xqx:letExpr/*,$binding)
  let $bds := (
    
  <binding>{$item/xqx:typedVariableBinding/xqx:varName 
      union $lpaths}</binding>)
  return
        $paths union $bds union 
        $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)]
};


(: PATHS OF QUANTIFIED EXPRESSION :)

declare function xsv:paths_quantifiedExpr($quantified,$binding)
{
  for $item in $quantified/xqx:quantifiedExprInClause
  let $lpaths := xsv:opath($item/xqx:sourceExpr/*,$binding)
  let $paths := xsv:paths($item/xqx:sourceExpr/*,$binding)
  let $bds :=(
   
  <binding>{$item/xqx:typedVariableBinding/xqx:varName 
        union $lpaths}</binding>)
   return $paths union $bds union
            $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)] union xsv:paths($quantified/xqx:predicateExpr/*,$bds union $binding) 
     
};

 

(: PATHS OF SEQUENCE OF EXPRS :)

declare function xsv:paths_sequenceExpr($Expr,$binding)
{
  if (empty($Expr)) 
  then ()
  else let $head := head($Expr) 
       let $path := xsv:paths($head,$binding) 
       return $path union xsv:paths_sequenceExpr(tail($Expr),$binding)
};

 


(: PATHS OF WHERE CLAUSE:)

declare function xsv:paths_whereClause($whereClause,$binding)
{
  xsv:paths($whereClause/*,$binding)
};

(: PATHS OF RETURN CLAUSE :)

declare function xsv:paths_returnClause($returnClause,$binding)
{
  xsv:paths($returnClause/*,$binding)
};


(: OPATH :)

(: OPATH OF A QUERY :)

declare function xsv:opath_query($file)
{
let $xqueryx := m:CodetoXQueryX($file)
return xsv:opath($xqueryx//xqx:functionBody/*,())  
};

(: OPATHS OF A SET OF EXPR :)

declare function xsv:opath_set($Expr,$binding)
{
  if (empty($Expr)) then ()
  else xsv:opath(head($Expr),$binding) union xsv:opath_set(tail($Expr),$binding)
};

(: OPATH OF A XQUERY EXPRESSION :)

declare function xsv:opath($Expr,$binding)
{      
      if (count($Expr)>=2) then 
                        xsv:opath_set($Expr,$binding) 
                       
      else
      if (name($Expr)="xqx:flworExpr") then  xsv:opath_flworExpr($Expr/*,$binding)
      else if (name($Expr)="xqx:quantifiedExpr") then xsv:opath_quantifiedExpr($Expr,$binding)
      else if (name($Expr)="xqx:ifThenElseExpr") then xsv:opath_ifThenElseExpr($Expr,$binding)       
      else if (name($Expr)="xqx:rootExpr") then <xqx:rootExpr/>
      else if (name($Expr)="xqx:orOp") then xsv:opath_orOp($Expr,$binding)
      else if (name($Expr)="xqx:andOp") then xsv:opath_andOp($Expr,$binding)
      else if (name($Expr)="xqx:varRef") then  xsv:opath_varRef($Expr,$binding)  
      else if (name($Expr)="xqx:pathExpr") then  xsv:opath_pathExpr($Expr,$binding) 
      else if (name($Expr)="xqx:integerConstantExpr") then () 
      else if (name($Expr)="xqx:decimalConstantExpr") then () 
      else if (name($Expr)="xqx:doubleConstantExpr") then () 
      else if (name($Expr)="xqx:stringConstantExpr") then () 
      else if (name($Expr)="xqx:sequenceExpr") then xsv:opath_sequenceExpr($Expr/*,$binding)
      else if (name($Expr)="xqx:addOp") then xsv:opath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:substractOp") then xsv:opath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:multiplyOp") then xsv:opath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:divOp") then xsv:opath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:idivOp") then xsv:opath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:modOp") then xsv:opath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:unaryMinusOp") then xsv:opath($Expr/xqx:operand/*,$binding)
      else if (name($Expr)="xqx:unaryPlusOp") then xsv:opath($Expr/xqx:operand/*,$binding)
      else if (name($Expr)="xqx:eqOp") then xsv:opath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:neOp") then xsv:opath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:gtOp") then xsv:opath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:geOp") then xsv:opath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:ltOp") then xsv:opath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:leOp") then xsv:opath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:equalOp") then xsv:opath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:notEqualOp") then xsv:opath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:lessThanOp") then xsv:opath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:lessThanOrEqualOp") then xsv:opath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:greaterThanOp") then xsv:opath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:greaterThanOrEqualOp") then xsv:opath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:andOp") then xsv:opath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:unionOp") then xsv:opath_unionOp($Expr,$binding) 
      else if (name($Expr)="xqx:intersectOp") then xsv:opath_intersectOp($Expr,$binding) 
      else if (name($Expr)="xqx:exceptOp") then xsv:opath_exceptOp($Expr,$binding) 
      else if (name($Expr)="xqx:orderBySpec") then xsv:opath($Expr/xqx:orderByExpr/*,$binding)
      else if (name($Expr)="xqx:elementConstructor") then xsv:opath_elementConstructor($Expr,$binding) 
      else if (name($Expr)="xqx:functionCallExpr") then xsv:opath_functionCallExpr($Expr,$binding) 
      else if (name($Expr)="xqx:stepExpr") then xsv:opath_stepExpr($Expr,$binding)
      else if (name($Expr)="") then ()
      (::)
      else if (name($Expr)="xqx:opath") then ()
      (::)          
      else error(QName('http://www.w3.org/2005/xqt-errors', "syntax"),"Syntax not supported")
};





(: OPATH OF AN ELEMENT CONSTRUCTOR :)

declare function xsv:opath_elementConstructor($Expr,$binding)
{
   let $NExpr := (if (count($Expr/xqx:elementContent/*)<=1)
                  then xsv:opath($Expr/xqx:elementContent/*,$binding)
                  else xsv:opath_sequenceExpr($Expr/xqx:elementContent/*,$binding))
   return  <xqx:pathExpr> 
           <xqx:elementConstructor>
           {$Expr/xqx:tagName}
           <xqx:elementContent>
           {$NExpr}
           </xqx:elementContent>
           </xqx:elementConstructor>
           </xqx:pathExpr>
           
};

(: OPATH OF A FUNCTION CALL EXPR :)

declare function xsv:opath_functionCallExpr($Expr,$binding)
{
   ()
};


(: OPATH OF PREDICATES :)

declare function xsv:lpredicates($Expr,$binding)
{
  if ($Expr/xqx:predicates) 
  then 
    let $pth := xsv:opath($Expr/xqx:predicates/*,$binding)    
    return 
    <xqx:predicates>
    {xsv:opath($pth,$binding)} 
    </xqx:predicates>
  else ()
};

(: OPATH OF BINARY OP :)

declare function xsv:opath_binaryOp($Expr,$binding)
{
  ()  
};

(: OPATH OF UNION OP :)

declare function xsv:opath_unionOp($Expr,$binding)
{ 
   
  <xqx:opath>    
  {xsv:opath($Expr/xqx:firstOperand/*,$binding)}
  {xsv:opath($Expr/xqx:secondOperand/*,$binding)}
  </xqx:opath>
  
  
};


(: OPATH OF INTERESECT OP :)

declare function xsv:opath_intersectOp($Expr,$binding)
{
   
  <xqx:opath>
  {xsv:opath($Expr/xqx:firstOperand/*,$binding)}   
  {xsv:opath($Expr/xqx:secondOperand/*,$binding)}
  </xqx:opath>
   
  
};

(: OPATH OF EXCEPT OP :)

declare function xsv:opath_exceptOp($Expr,$binding)
{
   
  <xqx:opath>
  {xsv:opath($Expr/xqx:firstOperand/*,$binding)}  
  {xsv:opath($Expr/xqx:secondOperand/*,$binding)}
  </xqx:opath>
   
    
};

(: OPATH OF FLOWR EXPR :)
 

declare function xsv:opath_flworExpr($flworExpr,$binding)
{
        if (empty($flworExpr)) 
        then ()
        else
        if (name(head($flworExpr))="xqx:forClause") then 
          let $result := xsv:opath_forClause(head($flworExpr),$binding) 
          return xsv:pth($result) union xsv:opath_flworExpr(tail($flworExpr),
          xsv:bd($result))
        else 
        if (name(head($flworExpr))="xqx:letClause") then
          let $result := xsv:opath_letClause(head($flworExpr),$binding)
          return xsv:pth($result) union xsv:opath_flworExpr(tail($flworExpr),
          xsv:bd($result))
        else 
        if (name(head($flworExpr))="xqx:whereClause") then
          
           xsv:opath_flworExpr(tail($flworExpr),$binding)
        else 
          let $path := xsv:opath_returnClause(head($flworExpr),$binding)
          return $path union xsv:opath_flworExpr(tail($flworExpr),$binding)
};


(: OPATH OF IF THEN ELSE :)

declare function xsv:opath_ifThenElseExpr($ifthenelse,$binding)
{ 
  let $path2 := xsv:opath($ifthenelse/xqx:ifClause/*,$binding)
  let $path3 := xsv:opath($ifthenelse/xqx:thenClause/*,$binding)
  let $path4 := xsv:opath($ifthenelse/xqx:elseClause/*,$binding)
  return
   
  <xqx:opath>
  {
  xsv:opath($path3,$binding) union
  xsv:opath($path4,$binding) 
  }
  </xqx:opath>
  
};

(: OPATH OF OR EXPR :)

declare function xsv:opath_orOp($or,$binding)
{
   
  <xqx:opath>
  {xsv:opath($or/xqx:firstOperand/*,$binding)}
  {xsv:opath($or/xqx:secondOperand/*,$binding)}
  </xqx:opath>
   
   
};

(: OPATH OF AND EXPR :)

declare function xsv:opath_andOp($and,$binding)
{
   
  <xqx:opath>
  {xsv:opath($and/xqx:firstOperand/*,$binding)}
  {xsv:opath($and/xqx:secondOperand/*,$binding)}
  </xqx:opath>
   
    
};

(: OPATH OF VARIABLE :)

declare function xsv:opath_varRef($var,$binding)
{
  if ($var/xqx:filterExpr) 
  then xsv:binding($binding,$var/xqx:filterExpr/xqx:varRef)
  else xsv:binding($binding,$var)
};

(: OPATH OF FOR CLAUSE:)

declare function xsv:opath_forClause($forClause,$binding)
{
  for $item in $forClause/xqx:forClauseItem
  let $lpaths := xsv:opath($item/xqx:forExpr/*,$binding)
  return  
      
      <binding>{$item/xqx:typedVariableBinding/xqx:varName 
      union $lpaths}</binding> union 
      $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)]
};

(: OPATH OF LET CLAUSE :) 

declare function xsv:opath_letClause($letClause,$binding)
{
  for $item in $letClause/xqx:letClauseItem
  let $lpaths := xsv:opath($item/xqx:letExpr/*,$binding)
  return
         <binding>{$item/xqx:typedVariableBinding/xqx:varName 
        union $lpaths}</binding> union 
        $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)]
};


(: OPATH OF QUANTIFIED EXPRESSION :)


declare function xsv:opath_quantifiedExpr($quantified,$binding)
{
  ()
};


(: OPATH OF SEQUENCE OF EXPRS :)

declare function xsv:opath_sequenceExpr($Expr,$binding)
{
  if (empty($Expr)) 
  then ()
  else let $head := head($Expr) 
       let $path := xsv:opath($head,$binding) 
       return $path union xsv:opath_sequenceExpr(tail($Expr),$binding)
};


(: OPATH OF RETURN CLAUSE :)

declare function xsv:opath_returnClause($returnClause,$binding)
{
  xsv:opath($returnClause/*,$binding)
};

(: VALIDATION OF AN SCHEMA:)

declare function xsv:validation($schema,$root,$parents,$paths)
{
  for $path in $paths 
  return
  if ($path/xqx:opath) then xsv:val_opath($schema,$root,$parents,$path,$paths)
  else
  if ($path/xqx:elementConstructor) then  
                    xsv:val_elementConstructor($schema,$root,$parents,$path)
  else
  if ($path/content) then
            
            if ($path/content/xqx:varRef) then  
                xsv:val_path($schema,$root,$parents,$path/*,$path/*)
            else      
            if ($path/content/xqx:stepExpr) then 
                xsv:val_path($schema,$root,$parents,$path/*,$path/*)
            else 
            if ($path/content/xqx:opath) then
            if  
            (some $item in $path/content/xqx:opath/xqx:pathExpr
            satisfies empty(xsv:val_path($schema,$root,$parents,
            $item/xqx:stepExpr union 
            $path/tag union $path/root union
             $path/xqx:stepExpr,
            $item/xqx:stepExpr union 
            $path/tag union $path/root union $path/xqx:stepExpr)))
            then ()
            else
            if  
            (some $item in $path/content/xqx:opath/xqx:varRef
            satisfies empty(xsv:val_path($schema,$root,$parents,
            $item/xqx:stepExpr union 
            $path/tag union $path/root union $path/xqx:stepExpr,
            $item/xqx:stepExpr union 
            $path/tag union $path/root union $path/xqx:stepExpr)))
            then ()
            
            else  
<error>Schema Validation Error. Wrong path in expression "{xsv:string-join2($paths)}"    </error> 
            else  
            xsv:val_content($schema,$root,$parents,$path)    
            
  
  else  
  if ($path/xqx:pathExpr) then (: opath return a unique path :)
           
          
          xsv:validation($schema,$root,$parents,<xqx:pathExpr>{$path/xqx:pathExpr/* union $path/xqx:stepExpr}</xqx:pathExpr>
          )
  else  (: $path/xqx:stepExpr :)
          
          xsv:val_path($schema,$root,$parents,$path/*,$path/*)        
};

(: VAL OF CONTENT :)
 
declare function xsv:val_content($schema,$root,$parents,$path)
{
  if 
  (some $item in $path/content/xqx:elementConstructor/xqx:elementContent/xqx:pathExpr
  satisfies
  empty(xsv:validation($schema,$root,$parents,
          <xqx:pathExpr>
              <content>
                {$item/*}
              </content> 
                 {(if ($path/root) then  
                      (<tag>{$path/content/xqx:elementConstructor/xqx:tagName/text()}</tag>, 
                       $path/tag,$path/root)
                                   else 
                       <root>{$path/content/xqx:elementConstructor/xqx:tagName/text()}</root>)}
              {$path/xqx:stepExpr} 
          </xqx:pathExpr>)))
  then ()
  else 
  if (some $item in $path/content/xqx:elementConstructor/xqx:elementContent/xqx:varRef
     satisfies empty(xsv:validation($schema,$root,$parents,
          <xqx:pathExpr>
            <content>
              {$item}
            </content> 
                  {(if ($path/root) then  
                        (<tag>{$path/content/xqx:elementConstructor/xqx:tagName/text()}</tag>, 
                              $path/tag,$path/root)
                                    else 
                         <root>{$path/content/xqx:elementConstructor/xqx:tagName/text()}</root>)}
             {$path/xqx:stepExpr} 
          </xqx:pathExpr>)))

     then ()
     else 
 <error>Schema Validation Error. Wrong path in constructor expression "{xsv:string-join2($path)}"</error> 
};

(: VAL OF OPATH :) 

declare function xsv:val_opath($schema,$root,$parents,$path,$paths)
{
   
  if (some $item in $path/xqx:opath/xqx:pathExpr  
  satisfies empty(xsv:validation($schema,$root,$parents,
            <xqx:pathExpr>{$item/* union $path/xqx:stepExpr}</xqx:pathExpr>)))
  then ()
  else  
  if (some $item in $path/xqx:opath/xqx:varRef  
  satisfies empty(xsv:validation($schema,$root,$parents,
            <xqx:pathExpr>{$item union $path/xqx:stepExpr}</xqx:pathExpr>)))
  then ()
  else 
    <error>Schema Validation Error. Wrong path in sequence expression "{xsv:string-join2($paths)}"</error> 
};

(: VAL OF PATHS :)

declare function xsv:val_paths($schema,$root,$parents,$paths,$tail)
{
  if (every $item in $paths 
  satisfies empty(xsv:val_path($schema,$root,$parents,
            $item/* union $tail,$item/* union $tail))
            
            )
  then ()
  else  
    <error>Schema Validation Error. Wrong path in sequence expression "{xsv:string-join2($paths union $tail)}"</error> 
};

(: VAL OF ELEMENT CONSTRUCTOR :)

declare function xsv:val_elementConstructor($schema,$root,$parents,$path)
{
  
  
  xsv:validation($schema,$root,$parents,<xqx:pathExpr><content>{$path/xqx:elementConstructor}</content>{$path/xqx:stepExpr
    }</xqx:pathExpr>)
   
};


(: VAL OF ANCESTOR :)

declare function xsv:val_ancestor($schema,$root,$parents,$path,$expr)
{
       let $head := head($path)
       return
       if (empty(xsv:val_parent($schema,$root,$parents,$path,$expr))) then ()
       else
       let $ancestor := head($parents)/* 
       return
       if (empty($ancestor)) then
     <error>Schema Validation Error. Wrong ancestor in path "{xsv:string-join2($expr)}".</error>
       else 
       xsv:val_ancestor($ancestor,$root,tail($parents),$path,$expr)      
};
 
(: VAL OF DESCENDANT :)

declare function xsv:val_descendant($schema,$root,$parents,$path,$expr)
{
    let $head := head($path)
    return
    if (empty(xsv:val_child($schema,$root,$parents,$path,$expr))) then ()   
    else
    if (some $child in xsv:sig($schema,$root) satisfies
     not(empty($child)) and
     empty(xsv:val_descendant($child,$root,(<p>{$schema}</p>,$parents),$path,$expr)))
     then ()
     else     
   <error>Schema Validation Error. Wrong descendant in path "{xsv:string-join2($expr)}".</error>
};

(: VAL OF SELF :)

declare function xsv:val_self($schema,$root,$parents,$path,$expr)
{
  let $head := head($path)
  let $self := head($parents)/*
  return
     (xsv:val_item($self,$head,$expr) 
     union 
     xsv:val_path($schema,$root,$parents,tail($path),$expr) 
     union
     xsv:validation($schema,$root,$parents,$head/xqx:predicates/*))
};
 
(: VAL OF ITEM :) 

declare function xsv:val_item($schema,$item,$expr)
{  
 if ($item/xqx:textTest) then ()
   else if ($item/xqx:anyKindTest) then ()
     else if ($item/xqx:Wildcard) then () 
       else if ($item/xqx:nameTest)  
             then
                 if ((some $name in $schema/xs:sequence/xs:element/@name satisfies 
                 $name=$item/xqx:nameTest/text()) or 
                 (some $name in data($schema/xs:sequence/xs:element/@ref) satisfies 
                 $name=$item/xqx:nameTest/text()))
                    then ()
                    else  
      <error>Schema Validation Error. Wrong context in path "{xsv:string-join2($expr)}".</error>
   else
   ()
  
};

(: SIG OF AN SCHEMA :)

declare function xsv:sig($schema,$root)
{
  $schema/xs:sequence/xs:element/xs:complexType
  union
  $schema/xs:sequence/xs:element
  union
  (
  for $ref in data($schema/xs:sequence/xs:element/@ref)
  return
  $root/xs:schema/xs:complexType[@name=$ref]
  )
};

(: SIG BY NAME OF AN SCHEMA :)

declare function xsv:sig_name($schema,$root,$n)
{
  $schema/xs:sequence/xs:element[@name=$n]/xs:complexType
  union
  $root/xs:schema/xs:complexType[@name=$n] 
  
};

(: VAL OF CHILD :)

declare function xsv:val_child($schema,$root,$parents,$path,$expr)
{
      let $head := head($path) return  
          if ($head/xqx:Wildcard) then 
                      if (some $child in xsv:sig($schema,$root)
                      satisfies (not(empty($child))
                      and
                      empty(
                      xsv:val_path($child,$root,
                      (<p>{$schema}</p> union $parents),tail($path),$expr)
                      union 
                      xsv:validation($child,$root,
                      (<p>{$schema}</p> union $parents),$head/xqx:predicates/*)
                      )))
                    then ()
                    else  
  <error>Schema Validation Error. Wrong child in path "{xsv:string-join2($expr)}"</error>
          else 
          if ($head/xqx:textTest) then ()
          else if ($head/xqx:anyKindTest) then     
                  xsv:val_path($schema,$root,$parents,tail($path),$expr)
                  union 
                  xsv:validation($schema,$root,$parents,$head/xqx:predicates/*)
          else
                   
                  xsv:val_item($schema,$head,$expr)
                  union
                  xsv:val_path(
                  xsv:sig_name($schema,$root,$head/xqx:nameTest/text()),$root,
                  (<p>{$schema}</p>,$parents),tail($path),$expr)
                  union 
                  xsv:validation(xsv:sig_name($schema,$root,$head/xqx:nameTest/text()),$root,
                  (<p>{$schema}</p>,$parents),$head/xqx:predicates/*)
           
           
};

(: VAL OF PARENT :)

declare function xsv:val_parent($schema,$root,$parents,$path,$expr)
{
   let $head := head($path)
   let $parent := head(tail($parents))/*
   return
   if (empty($parent)) then 
   xsv:val_path(head($parents)/*,$root,tail($parents),tail($path),$expr)
   union 
   xsv:validation(head($parents)/*,$root,tail($parents),$head/xqx:predicates/*)
  
   
   else    
                 xsv:val_item($parent,$head,$expr)
                 union
                 xsv:val_path(head($parents)/*,$root,tail($parents),tail($path),$expr) 
                 union 
                 xsv:validation(head($parents)/*,$root,tail($parents),$head/xqx:predicates/*)
                
};

(: VAL OF ATTRIBUTE :)

declare function xsv:val_attribute($schema,$parents,$path,$expr)
{
  let $head := head($path)
  return
  if ($head/xqx:nameTest/text()=$schema/xs:attribute/@name 
        or $head/xqx:Wildcard 
        or $head/xqx:anyKindTest)
        then ()
        
         else 
 <error>Schema Validation Error. Wrong attribute in path "{xsv:string-join2($expr)}".</error>
};

(: VAL OF PATH :)

declare function xsv:val_path($schema,$root,$parents,$path,$expr)
{
  if (empty($path)) 
  then ()
  else 
  let $head := head($path)
  return 
  if (name($head)="xqx:varRef") then xsv:val_path($schema,$root,$parents,tail($path),$expr)
  else
  (: CONTENT :)
  if (name($head)="content") then  
            xsv:val_path($schema,$root,$parents,$head/* union tail($path),$expr)
  else
  if (name($head)="tag") then 
  let $newschema1 := 
            <xs:complexType>
            <xs:sequence>
            <xs:element name="{$head/text()}">
              {$schema}
           </xs:element> 
           </xs:sequence>
           </xs:complexType>
  let $newschema2 := 
            <xs:complexType>
            <xs:sequence>
            <xs:element name="{$head/text()}">
              {head($parents)/*}
           </xs:element> 
           </xs:sequence>
           </xs:complexType>
  return 
  if (empty(head($parents)/*)) then xsv:val_path($newschema1,$root,<p></p>,tail($path),$expr)
  else xsv:val_path($newschema2,$root,<p></p>,tail($path),$expr)
  else
  if (name($head)="root") then 
  let $parent1 := 
            <xs:complexType>
            <xs:sequence>
            <xs:element name="{$head/text()}">
              {$schema}
           </xs:element> 
           </xs:sequence>
           </xs:complexType>
  let $parent2 := 
            <xs:complexType>
            <xs:sequence>
            <xs:element name="{$head/text()}">
              {head($parents)/*}
           </xs:element> 
           </xs:sequence>
           </xs:complexType>
  return 
  if (empty(head($parents)/*)) then  
  xsv:val_path($schema,$root,<p>{$parent1}</p>,tail($path),$expr)
  else 
  xsv:val_path(head($parents)/*,$root,<p>{$parent2}</p>,tail($path),$expr)
  (: CONTENT :)
  else
  if ($head/xqx:paths) then 
                      xsv:val_paths($schema,$root,$parents,$head/xqx:paths/*,
                      tail($path))
                      
  else
  if ($head/xqx:filterExpr/xqx:varRef) 
  then xsv:val_path($schema,$root,$parents,tail($path),$expr) union
       xsv:validation($schema,$root,$parents,$head/xqx:predicates/*) 
  else
  if ($head/xqx:filterExpr/xqx:contextItemExpr) 
  then xsv:val_path($schema,$root,$parents,tail($path),$expr) union
       xsv:validation($schema,$root,$parents,$head/xqx:predicates/*) 
  
  
  else
  if ($head/xqx:xpathAxis="self")
  then xsv:val_self($schema,$root,$parents,$path,$expr)  
  else
  if ($head/xqx:xpathAxis="child") 
  then xsv:val_child($schema,$root,$parents,$path,$expr)   
  else 
  if ($head/xqx:xpathAxis="descendant")
  then xsv:val_descendant($schema,$root,$parents,$path,$expr)
  else
  if ($head/xqx:xpathAxis="descendant-or-self")  
        then let $desc :=
              xsv:val_descendant($schema,$root,$parents,$path,$expr)
              return  
              if (not(empty($desc))) then xsv:val_self($schema,$root,$parents,$path,$expr)
              else ()
               
  else
  if ($head/xqx:xpathAxis="ancestor")
  then xsv:val_ancestor($schema,$root,$parents,$path,$expr)
  else
  if ($head/xqx:xpathAxis="ancestor-or-self")  
        then  let $desc := xsv:val_ancestor($schema,$root,$parents,$path,$expr)
              return
              if (not(empty($desc))) then xsv:val_self($schema,$root,$parents,$path,$expr)
              else ()    
           
  else  
  if  ($head/xqx:xpathAxis="parent")
        then
        xsv:val_parent($schema,$root,$parents,$path,$expr)
        
  else 
  if ($head/xqx:xpathAxis="attribute") 
    then
      xsv:val_attribute($schema,$parents,$path,$expr) 
              
  else
  if (name($head)="xqx:rootExpr")
      then 
      xsv:val_path(<xs:complexType><xs:sequence>{$root/xs:schema/xs:element}</xs:sequence>
      </xs:complexType>,$root,<p></p>,tail($path),$expr) 
  else
  if (name($head)="xqx:name") then () 
     
      
      else 
       error(QName('http://www.w3.org/2005/xqt-errors', 'syntax'),name($head))};




