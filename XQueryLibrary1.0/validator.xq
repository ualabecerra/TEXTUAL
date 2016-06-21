module namespace val = "validator";
import module namespace xsv = "xs_validator" at "XMLSchema_Validator.xq";
import module namespace m = 'xQueryX.main';
declare namespace xqx="http://www.w3.org/2005/XQueryX";


declare function val:val_query($schema,$query)
{
let $sch := doc($schema)
let $paths := xsv:xpath_query($query)
return

(xsv:validation(<xs:complexType><xs:sequence>{$sch/xs:schema/xs:element}</xs:sequence></xs:complexType>,$sch,<p></p>,$paths)[1]/text(),'&#xa;')  

};

declare function val:val_input($schema,$query)
{
let $sch := doc($schema)
let $paths := xsv:xpath_query($query)
return
(xsv:validation(<xs:complexType><xs:sequence>{$sch/xs:schema/xs:element}</xs:sequence></xs:complexType>,$sch,<p></p>,$paths)[1]/text(),'&#xa;')  

};

declare function val:val_output($schema,$query)
{
let $sch := doc($schema)
let $paths := xsv:xpath_query($query)
return
(xsv:validation($sch/xs:schema/xs:element/xs:complexType,$sch,<p></p>,$paths)[1]/text(),'&#xa;')  

};

declare function val:val_input_output($schema1,$schema2,$query)
{
let $sch1 := doc($schema1)
let $sch2 := doc($schema2)
let $paths := xsv:xpath_query($query)
let $var1 := (m:CodetoXQueryX($query)//xqx:paramList/xqx:param/xqx:varName)[1]/text()
let $var2 := (m:CodetoXQueryX($query)//xqx:paramList/xqx:param/xqx:varName)[2]/text()
return
 
(  
xsv:validation(<xs:complexType><xs:sequence>{$sch1/xs:schema/xs:element}</xs:sequence></xs:complexType>,$sch1,<p></p>,$paths[.//xqx:name=$var1])
union
xsv:validation($sch2/xs:schema/xs:element/xs:complexType,$sch2,<p></p>,$paths[.//xqx:name=$var2])
)[1]/text(),'&#xa;'

};

 
 