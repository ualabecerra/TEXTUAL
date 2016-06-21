module namespace xsv = "xs_validator";

(: PENDING: TYPES, CARDINALITY, XML SCHEMAS FEATURES :)

(: OR | AND UNION INTERSECTION EXCEPT :)

import module namespace m = 'xQueryX.main';
declare namespace xqx="http://www.w3.org/2005/XQueryX";


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

declare function xsv:xpath_query($file)
{
let $xqueryx := m:CodetoXQueryX($file)
return xsv:xpath($xqueryx//xqx:functionBody/*,())  
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


(: XPATH :)

(: XPATH OF XQUERYX :)

declare function xsv:xpath_set($Expr,$binding)
{
  if (empty($Expr)) then ()
  else xsv:xpath(head($Expr),$binding) union xsv:xpath_set(tail($Expr),$binding)
};

declare function xsv:xpath($Expr,$binding)
{      
      if (count($Expr)>=2) then 
                        xsv:xpath_set($Expr,$binding)
      else
      if (name($Expr)="xqx:flworExpr") then  xsv:xpath_flworExpr($Expr/*,$binding)
      else if (name($Expr)="xqx:quantifiedExpr") then xsv:xpath_quantifiedExpr($Expr,$binding)
      else if (name($Expr)="xqx:ifThenElseExpr") then xsv:xpath_ifThenElseExpr($Expr,$binding)        else if (name($Expr)="xqx:rootExpr") then <xqx:rootExpr/>
      else if (name($Expr)="xqx:orOp") then xsv:xpath_orOp($Expr,$binding)
      else if (name($Expr)="xqx:andOp") then xsv:xpath_andOp($Expr,$binding)
      else if (name($Expr)="xqx:varRef") then  xsv:xpath_varRef($Expr,$binding)  
      else if (name($Expr)="xqx:pathExpr") then  xsv:xpath_pathExpr($Expr,$binding) 
      else if (name($Expr)="xqx:integerConstantExpr") then () 
      else if (name($Expr)="xqx:decimalConstantExpr") then () 
      else if (name($Expr)="xqx:doubleConstantExpr") then () 
      else if (name($Expr)="xqx:stringConstantExpr") then () 
      else if (name($Expr)="xqx:sequenceExpr") then xsv:xpath_sequenceExpr($Expr/*,$binding)
      else if (name($Expr)="xqx:addOp") then xsv:xpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:substractOp") then xsv:xpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:multiplyOp") then xsv:xpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:divOp") then xsv:xpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:idivOp") then xsv:xpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:modOp") then xsv:xpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:unaryMinusOp") then xsv:xpath($Expr/xqx:operand/*,$binding)
      else if (name($Expr)="xqx:unaryPlusOp") then xsv:xpath($Expr/xqx:operand/*,$binding)
      else if (name($Expr)="xqx:eqOp") then xsv:xpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:neOp") then xsv:xpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:gtOp") then xsv:xpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:geOp") then xsv:xpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:ltOp") then xsv:xpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:leOp") then xsv:xpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:equalOp") then xsv:xpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:notEqualOp") then xsv:xpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:lessThanOp") then xsv:xpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:lessThanOrEqualOp") then xsv:xpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:greaterThanOp") then xsv:xpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:greaterThanOrEqualOp") then xsv:xpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:unionOp") then xsv:xpath_unionOp($Expr,$binding) 
      else if (name($Expr)="xqx:intersectOp") then xsv:xpath_intersectOp($Expr,$binding) 
      else if (name($Expr)="xqx:exceptOp") then xsv:xpath_exceptOp($Expr,$binding) 
      else if (name($Expr)="xqx:orderBySpec") then xsv:xpath($Expr/xqx:orderByExpr/*,$binding)
      else if (name($Expr)="xqx:elementConstructor") then xsv:xpath_elementConstructor($Expr,$binding) 
      else if (name($Expr)="xqx:functionCallExpr") then 
     xsv:xpath_functionCallExpr($Expr,$binding) 
      else if (name($Expr)="xqx:stepExpr") then xsv:xpath_stepExpr($Expr,$binding)
      else if (name($Expr)="xqx:rangeSequenceExpr") then 
      xsv:xpath_rangeSequenceExpr($Expr,$binding)
      else () 
       
};

(: XPATH OF A RANGE SEQUENCE EXPRESSION :)

declare function xsv:xpath_rangeSequenceExpr($Expr,$binding)
{
  xsv:xpath($Expr/xqx:startExpr/*,$binding) union xsv:xpath($Expr/xqx:endExpr/*,$binding)
};

(: XPATH OF AN ELEMENT CONSTRUCTOR :)

declare function xsv:xpath_elementConstructor($Expr,$binding)
{
   let $NExpr := (if (count($Expr/xqx:elementContent/*)<=1)
                  then xsv:xpath($Expr/xqx:elementContent/*,$binding)
                  else xsv:xpath_sequenceExpr($Expr/xqx:elementContent/*,$binding))
   return   
             $NExpr
            
};

(: FUNCTION CALL EXPR :)

declare function xsv:xpath_functionCallExpr($Expr,$binding)
{
  for $expr in $Expr/xqx:arguments/*
  return
  xsv:xpath($expr,$binding)
};

(: XPATH OF STEP EXPR :)  

declare function xsv:xpath_stepExpr($Expr,$binding)
{
  
  if ($Expr/xqx:filterExpr/xqx:varRef) 
  then 
    let $bd := xsv:binding($binding,$Expr/xqx:filterExpr/xqx:varRef)
    return 
    if (name($bd)="xqx:varRef") 
       then
       <xqx:stepExpr>{<xqx:filterExpr>{$bd}</xqx:filterExpr>}{xsv:predicates($Expr,$binding)}</xqx:stepExpr>   
       else $bd/* union xsv:predicates($Expr,$binding)
   
  else if ($Expr/xqx:filterExpr) then  
        
        <xqx:sequenceExpr>
        {xsv:lxpath($Expr/xqx:filterExpr/*,$binding)}
        </xqx:sequenceExpr>
        
       
       
   else  <xqx:stepExpr>
         {$Expr/*[not(name(.)="xqx:predicates")] union xsv:predicates($Expr,$binding)}
         </xqx:stepExpr>
};

(: PREDICATES :)

declare function xsv:predicates($Expr,$binding)
{
  if ($Expr/xqx:predicates) 
  then 
    let $pth := xsv:xpath($Expr/xqx:predicates/*,$binding)    
    return 
    <xqx:predicates>
    {xsv:xpath($pth,$binding)}  
    </xqx:predicates>
  else ()
};

(: XPATH OF BINARY OP :)

declare function xsv:xpath_binaryOp($Expr,$binding)
{
   
   
  xsv:xpath($Expr/xqx:firstOperand/*,$binding)
  union
  xsv:xpath($Expr/xqx:secondOperand/*,$binding) 
   
};

(: XPATH OF UNION OP :)

declare function xsv:xpath_unionOp($Expr,$binding)
{
   xsv:xpath($Expr/xqx:firstOperand/*,$binding)
   union
   xsv:xpath($Expr/xqx:secondOperand/*,$binding) 
};


(: XPATH OF INTERESECT OP :)

declare function xsv:xpath_intersectOp($Expr,$binding)
{
   xsv:xpath($Expr/xqx:firstOperand/*,$binding)
   union
  xsv:xpath($Expr/xqx:secondOperand/*,$binding) 
};

(: XPATH OF EXCEPT OP :)

declare function xsv:xpath_exceptOp($Expr,$binding)
{
   xsv:xpath($Expr/xqx:firstOperand/*,$binding)
   union
   xsv:xpath($Expr/xqx:secondOperand/*,$binding) 
};

(: XPATH OF FLOWR EXPR :)
 

declare function xsv:xpath_flworExpr($flworExpr,$binding)
{
        if (empty($flworExpr)) 
        then ()
        else
        if (name(head($flworExpr))="xqx:forClause") then 
          let $result := xsv:xpath_forClause(head($flworExpr),$binding) 
          return xsv:pth($result)   union xsv:xpath_flworExpr(tail($flworExpr),xsv:bd($result))
        else 
        if (name(head($flworExpr))="xqx:letClause") then
          let $result := xsv:xpath_letClause(head($flworExpr),$binding)
          return xsv:pth($result)  union xsv:xpath_flworExpr(tail($flworExpr),xsv:bd($result))
        else 
        if (name(head($flworExpr))="xqx:whereClause") then
          let $path := xsv:xpath_whereClause(head($flworExpr),$binding)
          return $path   union xsv:xpath_flworExpr(tail($flworExpr),$binding)
        else 
          let $path := xsv:xpath_returnClause(head($flworExpr),$binding)
          return $path   union xsv:xpath_flworExpr(tail($flworExpr),$binding)
};


(: XPATH OF IF THEN ELSE :)

declare function xsv:xpath_ifThenElseExpr($ifthenelse,$binding)
{ 
  let $path2 := xsv:xpath($ifthenelse/xqx:ifClause/*,$binding)
  let $path3 := xsv:xpath($ifthenelse/xqx:thenClause/*,$binding)
  let $path4 := xsv:xpath($ifthenelse/xqx:elseClause/*,$binding)
  return
   
  xsv:xpath($path2,$binding) union
  xsv:xpath($path3,$binding) union
  xsv:xpath($path4,$binding) 
};

(: XPATH OF OR EXPR :)

declare function xsv:xpath_orOp($or,$binding)
{
  let $path2 := xsv:xpath($or/xqx:firstOperand/*,$binding)
  let $path3 := xsv:xpath($or/xqx:secondOperand/*,$binding)
  return
   
  xsv:xpath($path2,$binding) union
  xsv:xpath($path3,$binding)
   
  
};

declare function xsv:xpath_andOp($or,$binding)
{
  let $path2 := xsv:xpath($or/xqx:firstOperand/*,$binding)
  let $path3 := xsv:xpath($or/xqx:secondOperand/*,$binding)
  return
   xsv:xpath($path2,$binding) union
  xsv:xpath($path3,$binding) 
};

(: XPATH OF VARIABLE :)

declare function xsv:xpath_varRef($var,$binding)
{
  if ($var/xqx:filterExpr) 
  then xsv:binding($binding,$var/xqx:filterExpr/xqx:varRef)
  else xsv:binding($binding,$var)
};

(: XPATH OF PATH EXPRESSION :)


declare function xsv:xpath_pathExpr($path,$binding)
{
 let $seq := xsv:xpath_sequenceExpr($path/*,$binding)
 return <xqx:pathExpr>{$seq}</xqx:pathExpr>
};


 

(: XPATH OF FOR CLAUSE:)

declare function xsv:xpath_forClause($forClause,$binding)
{  
  for $item in $forClause/xqx:forClauseItem
  let $lpaths := xsv:lxpath($item/xqx:forExpr/*,$binding)
  let $paths := xsv:xpath($item/xqx:forExpr/*,$binding)
  let $bds := (
  
  <binding>{$item/xqx:typedVariableBinding/xqx:varName 
      union $lpaths}</binding>)
  return  
      $paths union $bds union 
      $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)]
};

(: XPATH OF LET CLAUSE :) 

declare function xsv:xpath_letClause($letClause,$binding)
{
  for $item in $letClause/xqx:letClauseItem
  let $lpaths := xsv:lxpath($item/xqx:letExpr/*,$binding)
  let $paths := xsv:xpath($item/xqx:letExpr/*,$binding)
  let $bds := (
    
  <binding>{$item/xqx:typedVariableBinding/xqx:varName 
      union $lpaths}</binding>)
  return
        $paths union $bds union 
        $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)]
};


(: XPATH OF QUANTIFIED EXPRESSION :)

declare function xsv:xpath_quantifiedExpr($quantified,$binding)
{
  for $item in $quantified/xqx:quantifiedExprInClause
  let $lpaths := xsv:lxpath($item/xqx:sourceExpr/*,$binding)
  let $paths := xsv:xpath($item/xqx:sourceExpr/*,$binding)
  let $bds :=(
   
  <binding>{$item/xqx:typedVariableBinding/xqx:varName 
        union $lpaths}</binding>)
   return $paths union $bds union
            $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)] union xsv:xpath($quantified/xqx:predicateExpr/*,$bds union $binding) 
    
  
  
};

(: XPATH OF SEQUENCE OF EXPRS :)

declare function xsv:xpath_sequenceExpr($Expr,$binding)
{
  if (empty($Expr)) 
  then ()
  else let $head := head($Expr) 
       let $path := xsv:xpath($head,$binding) 
       return $path union xsv:xpath_sequenceExpr(tail($Expr),$binding)
};

 


(: XPATH OF WHERE CLAUSE:)

declare function xsv:xpath_whereClause($whereClause,$binding)
{
  xsv:xpath($whereClause/*,$binding)
};

(: XPATH OF RETURN CLAUSE :)

declare function xsv:xpath_returnClause($returnClause,$binding)
{
  xsv:xpath($returnClause/*,$binding)
};


(: lxpath :)

(: XPATH OF A QUERY :)

declare function xsv:lxpath_query($file)
{
let $xqueryx := m:CodetoXQueryX($file)
return xsv:lxpath($xqueryx//xqx:functionBody/*,())  
};

(: lxpath OF XQUERYX :)

declare function xsv:lxpath_set($Expr,$binding)
{
  if (empty($Expr)) then ()
  else xsv:lxpath(head($Expr),$binding) union xsv:lxpath_set(tail($Expr),$binding)
};

declare function xsv:lxpath($Expr,$binding)
{      
      if (count($Expr)>=2) then 
                        xsv:lxpath_set($Expr,$binding)
      else
      if (name($Expr)="xqx:flworExpr") then  xsv:lxpath_flworExpr($Expr/*,$binding)
      else if (name($Expr)="xqx:quantifiedExpr") then xsv:lxpath_quantifiedExpr($Expr,$binding)
      else if (name($Expr)="xqx:ifThenElseExpr") then xsv:lxpath_ifThenElseExpr($Expr,$binding)       else if (name($Expr)="xqx:rootExpr") then <xqx:rootExpr/>
      else if (name($Expr)="xqx:orOp") then xsv:lxpath_orOp($Expr,$binding)
      else if (name($Expr)="xqx:andOp") then xsv:lxpath_andOp($Expr,$binding)
      else if (name($Expr)="xqx:varRef") then  xsv:lxpath_varRef($Expr,$binding)  
      else if (name($Expr)="xqx:pathExpr") then  xsv:lxpath_pathExpr($Expr,$binding) 
      else if (name($Expr)="xqx:integerConstantExpr") then () 
      else if (name($Expr)="xqx:decimalConstantExpr") then () 
      else if (name($Expr)="xqx:doubleConstantExpr") then () 
      else if (name($Expr)="xqx:stringConstantExpr") then () 
      else if (name($Expr)="xqx:sequenceExpr") then 
      <xqx:pathExpr><xqx:sequenceExpr>{xsv:lxpath_sequenceExpr($Expr/*,$binding)}</xqx:sequenceExpr></xqx:pathExpr>
      else if (name($Expr)="xqx:addOp") then xsv:lxpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:substractOp") then xsv:lxpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:multiplyOp") then xsv:lxpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:divOp") then xsv:lxpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:idivOp") then xsv:lxpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:modOp") then xsv:lxpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:unaryMinusOp") then xsv:lxpath($Expr/xqx:operand/*,$binding)
      else if (name($Expr)="xqx:unaryPlusOp") then xsv:lxpath($Expr/xqx:operand/*,$binding)
      else if (name($Expr)="xqx:eqOp") then xsv:lxpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:neOp") then xsv:lxpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:gtOp") then xsv:lxpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:geOp") then xsv:lxpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:ltOp") then xsv:lxpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:leOp") then xsv:lxpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:equalOp") then xsv:lxpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:notEqualOp") then xsv:lxpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:lessThanOp") then xsv:lxpath_binaryOp($Expr,$binding)  
      else if (name($Expr)="xqx:lessThanOrEqualOp") then xsv:lxpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:greaterThanOp") then xsv:lxpath_binaryOp($Expr,$binding) 
      else if (name($Expr)="xqx:greaterThanOrEqualOp") then xsv:lxpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:andOp") then xsv:lxpath_binaryOp($Expr,$binding)
      else if (name($Expr)="xqx:unionOp") then xsv:lxpath_unionOp($Expr,$binding) 
      else if (name($Expr)="xqx:intersectOp") then xsv:lxpath_intersectOp($Expr,$binding) 
      else if (name($Expr)="xqx:exceptOp") then xsv:lxpath_exceptOp($Expr,$binding) 
      else if (name($Expr)="xqx:orderBySpec") then xsv:lxpath($Expr/xqx:orderByExpr/*,$binding)
      else if (name($Expr)="xqx:elementConstructor") then xsv:lxpath_elementConstructor($Expr,$binding) 
      else if (name($Expr)="xqx:functionCallExpr") then xsv:lxpath_functionCallExpr($Expr,$binding) 
      else if (name($Expr)="xqx:stepExpr") then xsv:lxpath_stepExpr($Expr,$binding)
      else if (name($Expr)="xqx:rangeSequenceExpr") then 
      xsv:lxpath_rangeSequenceExpr($Expr,$binding)
      else () 
       
};

(: lxpath OF A RANGE SEQUENCE EXPRESSION :)

declare function xsv:lxpath_rangeSequenceExpr($Expr,$binding)
{
  ()
   
};

(: lxpath OF AN ELEMENT CONSTRUCTOR :)

declare function xsv:lxpath_elementConstructor($Expr,$binding)
{
   let $NExpr := (if (count($Expr/xqx:elementContent/*)<=1)
                  then xsv:lxpath($Expr/xqx:elementContent/*,$binding)
                  else xsv:lxpath_sequenceExpr($Expr/xqx:elementContent/*,$binding))
   return  <xqx:pathExpr> 
           <xqx:elementConstructor>
           {$Expr/xqx:tagName}
           <xqx:elementContent>
           {$NExpr}
           </xqx:elementContent>
           </xqx:elementConstructor>
           </xqx:pathExpr>
   
           (:  $NExpr :)
            
};

(: FUNCTION CALL EXPR :)

declare function xsv:lxpath_functionCallExpr($Expr,$binding)
{
   
  ()
};

(: lxpath OF STEP EXPR :)  

declare function xsv:lxpath_stepExpr($Expr,$binding)
{
  
  if ($Expr/xqx:filterExpr/xqx:varRef) 
  then 
    let $bd := xsv:binding($binding,$Expr/xqx:filterExpr/xqx:varRef)
    return 
    if (name($bd)="xqx:varRef") 
       then
       <xqx:stepExpr>{<xqx:filterExpr>{$bd}</xqx:filterExpr>}{xsv:lpredicates($Expr,$binding)}</xqx:stepExpr>   
       else $bd/* union xsv:lpredicates($Expr,$binding)
    
    else if ($Expr/xqx:filterExpr) then  
        
        <xqx:sequenceExpr>
        {
        xsv:lxpath($Expr/xqx:filterExpr/*,$binding)
        }
        </xqx:sequenceExpr>
         
       
       
   else  <xqx:stepExpr>
         {$Expr/*[not(name(.)="xqx:predicates")] union xsv:lpredicates($Expr,$binding)}
         </xqx:stepExpr> 
  
  
};

(: PREDICATES :)

declare function xsv:lpredicates($Expr,$binding)
{
  if ($Expr/xqx:predicates) 
  then 
    let $pth := xsv:lxpath($Expr/xqx:predicates/*,$binding)    
    return 
    <xqx:predicates>
    {xsv:lxpath($pth,$binding)} 
    </xqx:predicates>
  else ()
};

(: lxpath OF BINARY OP :)

declare function xsv:lxpath_binaryOp($Expr,$binding)
{
   
  () 
  
};

(: lxpath OF UNION OP :)

declare function xsv:lxpath_unionOp($Expr,$binding)
{ 
  <xqx:pathExpr>
  <xqx:sequenceExpr> 
   
  {xsv:lxpath($Expr/xqx:firstOperand/*,$binding)}
   
  {xsv:lxpath($Expr/xqx:secondOperand/*,$binding)}
   
  </xqx:sequenceExpr>
  </xqx:pathExpr>
  
};


(: lxpath OF INTERESECT OP :)

declare function xsv:lxpath_intersectOp($Expr,$binding)
{
  <xqx:pathExpr>
  <xqx:sequenceExpr>
  {xsv:lxpath($Expr/xqx:firstOperand/*,$binding)}
   
  {xsv:lxpath($Expr/xqx:secondOperand/*,$binding)}
  </xqx:sequenceExpr>
  </xqx:pathExpr>
  
};

(: lxpath OF EXCEPT OP :)

declare function xsv:lxpath_exceptOp($Expr,$binding)
{
  <xqx:pathExpr>
  <xqx:sequenceExpr>
  {xsv:lxpath($Expr/xqx:firstOperand/*,$binding)}
  
  {xsv:lxpath($Expr/xqx:secondOperand/*,$binding)}
  </xqx:sequenceExpr>
  </xqx:pathExpr>
    
};

(: lxpath OF FLOWR EXPR :)
 

declare function xsv:lxpath_flworExpr($flworExpr,$binding)
{
        if (empty($flworExpr)) 
        then ()
        else
        if (name(head($flworExpr))="xqx:forClause") then 
          let $result := xsv:lxpath_forClause(head($flworExpr),$binding) 
          return xsv:pth($result) union xsv:lxpath_flworExpr(tail($flworExpr),
          xsv:bd($result))
        else 
        if (name(head($flworExpr))="xqx:letClause") then
          let $result := xsv:lxpath_letClause(head($flworExpr),$binding)
          return xsv:pth($result) union xsv:lxpath_flworExpr(tail($flworExpr),
          xsv:bd($result))
        else 
        if (name(head($flworExpr))="xqx:whereClause") then
          let $path := xsv:lxpath_whereClause(head($flworExpr),$binding)
          return $path union xsv:lxpath_flworExpr(tail($flworExpr),$binding)
        else 
          let $path := xsv:lxpath_returnClause(head($flworExpr),$binding)
          return $path union xsv:lxpath_flworExpr(tail($flworExpr),$binding)
};


(: lxpath OF IF THEN ELSE :)

declare function xsv:lxpath_ifThenElseExpr($ifthenelse,$binding)
{ 
  let $path2 := xsv:lxpath($ifthenelse/xqx:ifClause/*,$binding)
  let $path3 := xsv:lxpath($ifthenelse/xqx:thenClause/*,$binding)
  let $path4 := xsv:lxpath($ifthenelse/xqx:elseClause/*,$binding)
  return
   
   
  <xqx:pathExpr>
  <xqx:ifThenElseExpr>
  {
  xsv:lxpath($path3,$binding) union
  xsv:lxpath($path4,$binding) 
  }
  </xqx:ifThenElseExpr>
  </xqx:pathExpr> 
};

(: lxpath OF OR EXPR :)

declare function xsv:lxpath_orOp($or,$binding)
{
  <xqx:pathExpr>
  <xqx:sequenceExpr>
  {xsv:lxpath($or/xqx:firstOperand/*,$binding)}
  
  {xsv:lxpath($or/xqx:secondOperand/*,$binding)}
  </xqx:sequenceExpr>
  </xqx:pathExpr>
   
};

declare function xsv:lxpath_andOp($and,$binding)
{
  <xqx:pathExpr>
  <xqx:sequenceExpr>
  {xsv:lxpath($and/xqx:firstOperand/*,$binding)}
  
  {xsv:lxpath($and/xqx:secondOperand/*,$binding)}
  </xqx:sequenceExpr>
  </xqx:pathExpr>
    
};

(: lxpath OF VARIABLE :)

declare function xsv:lxpath_varRef($var,$binding)
{
  if ($var/xqx:filterExpr) 
  then xsv:binding($binding,$var/xqx:filterExpr/xqx:varRef)
  else xsv:binding($binding,$var)
};

(: lxpath OF PATH EXPRESSION :)


declare function xsv:lxpath_pathExpr($path,$binding)
{
 let $seq := xsv:lxpath_sequenceExpr($path/*,$binding)
 return <xqx:pathExpr>{$seq}</xqx:pathExpr>
};


 

(: lxpath OF FOR CLAUSE:)

declare function xsv:lxpath_forClause($forClause,$binding)
{
  for $item in $forClause/xqx:forClauseItem
  let $lpaths := xsv:lxpath($item/xqx:forExpr/*,$binding)
  return  
      
      <binding>{$item/xqx:typedVariableBinding/xqx:varName 
      union $lpaths}</binding> union 
      $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)]
};

(: lxpath OF LET CLAUSE :) 

declare function xsv:lxpath_letClause($letClause,$binding)
{
  for $item in $letClause/xqx:letClauseItem
  let $lpaths := xsv:lxpath($item/xqx:letExpr/*,$binding)
  return
         <binding>{$item/xqx:typedVariableBinding/xqx:varName 
        union $lpaths}</binding> union 
        $binding[not(xqx:varName=$item/xqx:typedVariableBinding/xqx:varName)]
};


(: lxpath OF QUANTIFIED EXPRESSION :)

declare function xsv:lxpath_quantifiedExpr($quantified,$binding)
{
  
  ()
   
  
};

(: lxpath OF SEQUENCE OF EXPRS :)

declare function xsv:lxpath_sequenceExpr($Expr,$binding)
{
  if (empty($Expr)) 
  then ()
  else let $head := head($Expr) 
       let $path := xsv:lxpath($head,$binding) 
       return $path union xsv:lxpath_sequenceExpr(tail($Expr),$binding)
};

 


(: lxpath OF WHERE CLAUSE:)

declare function xsv:lxpath_whereClause($whereClause,$binding)
{
  ()
  
};

(: lxpath OF RETURN CLAUSE :)

declare function xsv:lxpath_returnClause($returnClause,$binding)
{
  xsv:lxpath($returnClause/*,$binding)
};

(: VALIDATION OF AN SCHEMA:)

declare function xsv:validation($schema,$root,$parents,$paths)
{
  for $path in $paths 
  return
  if (name($path)="xqx:pathExpr")
  then  
  if ($path/xqx:ifThenElseExpr) then xsv:val_ifThenElseExpr($schema,$root,$parents,$path)
  else
  if ($path/xqx:sequenceExpr) then xsv:val_sequenceExpr($schema,$root,$parents,$path)
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
            if ($path/content/xqx:ifThenElseExpr) then 
            if 
            (some $item in $path/content/xqx:ifThenElseExpr/xqx:pathExpr
            satisfies
            empty(
            xsv:val_path($schema,$root,$parents,$item/xqx:stepExpr union 
            $path/tag union $path/root union
            $path/xqx:stepExpr,$item/xqx:stepExpr union
            $path/tag union $path/root union $path/xqx:stepExpr)
            ))
            then ()
            else 
            (: NEW :)
            if 
            (some $item in $path/content/xqx:ifThenElseExpr/xqx:varRef
            satisfies
            empty(
            xsv:val_path($schema,$root,$parents,$item/xqx:stepExpr union 
            $path/tag union $path/root union
            $path/xqx:stepExpr,$item/xqx:stepExpr union
            $path/tag union $path/root union $path/xqx:stepExpr)
            ))
            then ()
            else
<error>Schema Validation Error. Wrong path in if then else expression "{string-join($path//text()," ")}"</error> 
            else 
            if ($path/content/xqx:sequenceExpr) then
            if  
            (some $item in $path/content/xqx:sequenceExpr/xqx:pathExpr
            satisfies empty(xsv:val_path($schema,$root,$parents,
            $item/xqx:stepExpr union 
            $path/tag union $path/root union $path/xqx:stepExpr,
            $item/xqx:stepExpr union 
            $path/tag union $path/root union $path/xqx:stepExpr)))
            then ()
            else
            (: NEW :)
            if  
            (some $item in $path/content/xqx:sequenceExpr/xqx:varRef
            satisfies empty(xsv:val_path($schema,$root,$parents,
            $item/xqx:stepExpr union 
            $path/tag union $path/root union $path/xqx:stepExpr,
            $item/xqx:stepExpr union 
            $path/tag union $path/root union $path/xqx:stepExpr)))
            then ()
            else  
<error>Schema Validation Error. Wrong path in sequence expression "{string-join($path//text()," ")}"    </error> 
            else  
            xsv:val_content($schema,$root,$parents,$path)    
            
  
  else (: $path/xqx:stepExpr :)
          
          xsv:val_path($schema,$root,$parents,$path/*,$path/*)          
  else
  if (name($path)="xqx:filterExpr") 
  then xsv:validation($schema,$root,$parents,$path/*) 
  else  
  
   (: name($path)="xqx:stepExpr" :) 
  xsv:val_path($schema,$root,$parents,$path,$path)
 
};

 
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
 <error>Schema Validation Error. Wrong path in constructor expression "{string-join($path//text()," ")}"</error> 
};

(: IF THEN ELSE :)

declare function xsv:val_ifThenElseExpr($schema,$root,$parents,$path)
{
  if 
  (some $item in $path/xqx:ifThenElseExpr/xqx:pathExpr
  satisfies empty(xsv:validation($schema,$root,$parents,
          <xqx:pathExpr>{$item/* union $path/xqx:stepExpr}</xqx:pathExpr>)))
  then ()
  else
  if 
  (some $item in $path/xqx:ifThenElseExpr/xqx:varRef
   satisfies empty(xsv:validation($schema,$root,$parents,
         <xqx:pathExpr>{$item union $path/xqx:stepExpr}</xqx:pathExpr>)))
  then ()
  else 
<error>Schema Validation Error. Wrong path in if then else expression "{string-join($path//text()," ")}"</error> 
};

(: SEQUENCE :)

declare function xsv:val_sequenceExpr($schema,$root,$parents,$path)
{
  if (some $item in $path/xqx:sequenceExpr/xqx:pathExpr  
  satisfies empty(xsv:validation($schema,$root,$parents,
            <xqx:pathExpr>{$item/* union $path/xqx:stepExpr}</xqx:pathExpr>)))
  then ()
  else  
  if (some $item in $path/xqx:sequenceExpr/xqx:varRef  
  satisfies empty(xsv:validation($schema,$root,$parents,
            <xqx:pathExpr>{$item union $path/xqx:stepExpr}</xqx:pathExpr>)))
  then ()
  else 
    <error>Schema Validation Error. Wrong path in sequence expression "{string-join($path//text()," ")}"</error> 
};

(: ELEMENT CONSTRUCTOR :)

declare function xsv:val_elementConstructor($schema,$root,$parents,$path)
{
  xsv:validation($schema,$root,$parents,<xqx:pathExpr><content>{$path/xqx:elementConstructor}</content>{$path/xqx:stepExpr}</xqx:pathExpr>)
   
};


(: ANCESTOR :)

declare function xsv:val_ancestor($schema,$root,$parents,$path,$expr)
{
       let $head := head($path)
       return
       if (empty(xsv:val_parent($schema,$root,$parents,$path,$expr))) then ()
       else
       let $ancestor := head($parents)/* 
       return
       if (empty($ancestor)) then
     <error>Schema Validation Error. Wrong ancestor in path "{string-join($expr//text()," ")}".</error>
       else 
       xsv:val_ancestor($ancestor,$root,tail($parents),$path,$expr)      
};
 
(: DESCENDANT :)

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
   <error>Schema Validation Error. Wrong descendant in path "{string-join($expr//text()," ")}".</error>
};

(: SELF :)

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
 
(: ITEM :) 

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
      <error>Schema Validation Error. Wrong context in path "{string-join($expr//text()," ")}".</error>
   else
   ()
  
};

(: SIG OF AN SCHEMA :)

declare function xsv:sig($schema,$root)
{
  $schema/xs:sequence/xs:element/xs:complexType
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

(: CHILD :)

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
  <error>Schema Validation Error. Wrong child in path "{string-join($expr//text()," ")}"</error>
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

(: PARENT :)

declare function xsv:val_parent($schema,$root,$parents,$path,$expr)
{
   let $head := head($path)
   let $parent := head(tail($parents))/*
   return
   if (empty($parent)) then 
   <error>Schema Validation Error. Wrong parent in path "{string-join($expr//text()," ")}"</error>
   else    
                 xsv:val_item($parent,$head,$expr)
                 union
                 xsv:val_path(head($parents)/*,$root,tail($parents),tail($path),$expr) 
                 union 
                 xsv:validation(head($parents)/*,$root,tail($parents),$head/xqx:predicates/*)
                
};

(: ATTRIBUTE :)

declare function xsv:val_attribute($schema,$parents,$path,$expr)
{
  let $head := head($path)
  return
  if ($head/xqx:nameTest/text()=$schema/xs:attribute/@name 
        or $head/xqx:Wildcard 
        or $head/xqx:anyKindTest)
        then ()
        
         else 
 <error>Schema Validation Error. Wrong attribute in path "{string-join($expr//text()," ")}".</error>
};

(: VAL PATH :)

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
  let $newschema := 
            <xs:complexType>
            <xs:sequence>
            <xs:element name="{$head/text()}">
              {$schema}
           </xs:element> 
           </xs:sequence>
           </xs:complexType>
  return  xsv:val_path($newschema,$root,<p></p>,tail($path),$expr)
  else
  if (name($head)="root") then 
  let $parent := 
            <xs:complexType>
            <xs:sequence>
            <xs:element name="{$head/text()}">
              {$schema}
           </xs:element> 
           </xs:sequence>
           </xs:complexType>
  return xsv:val_path($schema,$root,<p>{$parent}</p>,tail($path),$expr)
  (: CONTENT :)
  else
  
  
  if ($head/xqx:filterExpr/xqx:varRef) 
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
  if ($head/xqx:filterExpr/xqx:contextItemExpr)
        then xsv:val_path($schema,$root,$parents,tail($path),$expr) union 
        xsv:validation($schema,$root,$parents,$head/xqx:predicates/*)  
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
      else () 
};




