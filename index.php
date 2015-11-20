
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="author" content="jalmen Jesús Manuel Almendros-Jiménez abecerra Antonio Becerra-Terón">
	<meta name="keywords" content="TEXTUAL, XQuery, testing, XML, test-case generation">
	<title>TEXTUAL</title>
	<link type="text/css" href="auxJavaScript/jquery-ui-1.8.18.custom.css" rel="stylesheet" />	
<link rel="stylesheet" href="CodeMirror/lib/codemirror.css">
<script src="CodeMirror/lib/codemirror.js"></script>
<script src="CodeMirror/mode/xml/xml.js"></script>
<script src="CodeMirror/mode/xquery/xquery.js"></script>
<script src="CodeMirror/addon/selection/active-line.js"></script>
	<script type="text/javascript" src="auxJavaScript/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="auxJavaScript/jquery-ui-1.8.18.custom.min.js"></script>
    <script type="text/javascript">
			$(function(){
	
				// Tabs
				$('#tabs').tabs();
				
				//hover states on the static widgets
				/* $('#dialog_link, ul#icons li').hover(
					function() { $(this).addClass('ui-state-hover'); }, 
					function() { $(this).removeClass('ui-state-hover'); }
				); */
				
				$('#foto').css("height",$('#header').css("height"))
				

			});
		</script>
		<style type="text/css">
			/*demo page css*/
			a{ text-decoration: none; color:#0066CC; }
			body{ background: #f6f6f6; font-size: 100%; font-family: "Trebuchet MS", "Lucida sans", Arial; margin: 30px; width: 900px; }
			/* h1{ border-bottom: solid black 1px; font-weight: 400; } */
			h1{ font-weight: 600; font-size: xx-large; margin-bottom: -10px;}
			code {font-weight:600; font-size:large;}
			h3{ background: #f6f6f6; font-weight: 400; margin-top: 2em;}
			h4{ font-weight:400; text-decoration: underline;}
			#foto{ float: left; height: 6em; margin-top:.5em; }
			#fotog{ height: 87%; }
			#foto-right{ padding-left: 2em; }
			#affiliation{ height: 237px; padding-left: 235px; padding-top: 100px; }
			#cuerpo{ clear: both; margin-top: 3%; }
			.title{ color: #990000; }
			.titulo1{ display: block; font-size: 220%; color: brown; margin-bottom: .5em; }
			.titulo2{ display: block; font-size: 120%; margin-bottom: .25em; }
			.titulo3 { margin-top: 1em; display: block; font-size: 120%; font-style: italic; }
			.titulo4{ font-size: 100%; text-decoration: underline; }
			.flotante1{ float: left; width: 320px; margin: 10px; }
			.flotante2{ float: left; width: 350px; margin: 10px; }
			.noitems{ list-style-type: none; }
		</style>	
		<style type="text/css">
		#flickr_badge_source_txt {padding:0; font: 11px Arial, Helvetica, Sans serif; color:#666666;}
		#flickr_badge_icon {display:block !important; margin:0 !important; border: 1px solid rgb(0, 0, 0) !important;}
		#flickr_icon_td {padding:0 5px 0 0 !important;}
		.flickr_badge_image {text-align:center !important;}
		.flickr_badge_image img {border: 1px solid black !important;}
		#flickr_www {display:block; padding:0 10px 0 10px !important; font: 11px Arial, Helvetica, Sans serif !important; color:#3993ff !important;}
		#flickr_badge_uber_wrapper a:hover,
		#flickr_badge_uber_wrapper a:link,
		#flickr_badge_uber_wrapper a:active,
		#flickr_badge_uber_wrapper a:visited {text-decoration:none !important; background:inherit !important;color:#3993ff;}
		#flickr_badge_wrapper {}
		#flickr_badge_source {padding:0 !important; font: 11px Arial, Helvetica, Sans serif !important; color:#666666 !important;}
		</style>
</head>
<body>
		<div class="ui-widget">
			<div id="header" class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;"> 
				<div id="foto-right">
				<h1>TEXTUAL: TEsting of Xml applicaTions UAL</h1>
				<ul class="noitems">	
					<li><span style="font-size:x-large">Testing of XQuery Programs<br>
						by <a href="http://dblp.uni-trier.de/pers/hd/a/Almendros=Jim=eacute=nez:Jes=uacute=s_Manuel">Jesús M. Almendros-Jiménez</a>
							and <a href="http://dblp.uni-trier.de/pers/hd/b/Becerra=Ter=oacute=n:Antonio">Antonio Becerra-Terón</a>
						</span>
					</li>
				</ul>
				</div>
			</div>
		</div>
<div id="cuerpo">

		<!-- Tabs -->
		<div id="tabs">
			<ul>
				<li><a href="#tabs-1">Home</a></li>
				<li><a href="#tabs-2">Web Interface</a></li>
			</ul>
			<div id="tabs-1">
			
			<p>
			The goal of the project is the testing of XQuery programs. A tool called (<code>TEXTUAL</code>) 
			has been implemented in order to test XQuery programs. The tool is based on the ideas shown in the following papers:
                        <ul class="noitems">
                                <li>Jesús Manuel Almendros-Jiménez, Antonio Becerra Terón. <br/>
                                	<span class="title">
                                	XQuery Testing from XML Schema Based Random Test Cases</span>. <br>
                                	<em>Proceedings of DEXA (2) 2015, pp. 268-282</em>
                                    <a href="./Papers/Dexa2015.pdf">PDF</a>
                                </li>
                                   <li>Jesús Manuel Almendros-Jiménez, Antonio Becerra Terón. <br/>
                                	<span class="title">
                                	Automatic Validation of XQuery Programs</span>. <br>
                                	<em>Proceedings of iiWAS 2015</em>
                                    <a href="./Papers/iiWAS2015.pdf">PDF</a>
                                </li>

                        </ul>
			</p>

			<p>It takes the following inputs:
			<ul>
				<li>an XML Schema (you can choose one of the
				list, edit it or write down a new one), 
				e.g., <code>schema01.xsd</code>,</li>
				<li>an XQuery program to be tested</li>
				<li>an input property, e.g., an XQuery function representing the input property to be tested w.r.t. the above query, e.g., 
					<code>$book/price < 100</code>, 
				</li>
				<li>an output property, e.g., a XQuery function representing the output property to be tested w.r.t. the above query, e.g., 
					<code>every $result in $results/* satisfies contains($result/text(),"XML")</code>, 
				</li>
				<li>an input-output property, e.g., a XQuery function representing the input-output property to be tested w.r.t. 
					the above query, e.g., 
					<code>every $title in $results/* satisfies every $f in $file//(chapter | section)/title satisfies 
not($title/text()=$f/text())</code>, and
				</li>
				<li>a number of steps in test case generation, e.g., <code>2</code></li>
			
			<p>Check the web interface in the next tab.</p>
			
			<p>Please let me know if you have any question or comment to 
				<code>jalmen@ual.es</code>.</p>
				
			</div><!-- end tabs-1 -->
			
			<div id="tabs-2">
<table>
<tr>
<td valign="top">
    <table>
    <tr>
    <td><b>XML Schema</b>
    </td>
    </tr>
    <tr>
    <td>   
    <textarea cols="90" rows=10 id="schema"></textarea>
    </td>
    </tr>
    </table>
</td>
<td valign="top">	
    <table>
    <tr>
	<td><b>Choose an XML Schema</b>
    </td>
    </tr>
    <tr>
    <td>
    <select name = 'database' id = 'database' onclick ="databaseListing()" onchange="loadDatabase()">
      <option selected value='none'>select a schema
      <option>schema_q1</option>
      <option>schema_q2</option>
      <option>schema_q3</option>
      <option>schema_q6</option>
      <option>schema_q7</option>
      <option>schema_q8</option>
      <option>schema_q9</option>
      <option>schema_q10</option>
    </select>
    </td>
    </tr>
    <tr>
	<td><b>Choose an example</b>
    </td>
    </tr>
    <tr>
    <td>
    <select name="examples" id="examples" onchange="loadCode()">
    <option selected value='none'>select an example
    <option value='ex08'>example08
    <option value='ex09'>example09
    </select>
    <!-- <button onclick="loadTRS()">load</button> -->
    <button onclick="removeAll()">clear</button>
    <br>
    </td>
    </tr>
    </table>
    <table>
    <tr>
    <td>
    <br><br><br><button onclick="dtdValidator()">DTD XML Schema Validation</button>
    </td>
    </tr>	
    <tr>
    <td>
    <textarea cols="30" rows=5 id="DTDSchema"></textarea>
    </td>
    </tr>
    </table>
</td>
</tr>
<td>
<table>
<tr>
<td><b>XQuery Program</b></td>
</tr>
<tr>
<td>
<textarea id="program"></textarea>
</td>
</tr>
</table>
</td>
<td>
 <table>
    <tr>
    <td>
    <br><br><br><button onclick="schemaProgramValidator()">XML Schema Program Validation</button>
    </td>
    </tr>	
    <tr>
    <td>
    <textarea cols="25" rows=2 id="XMLSchemaPorgramValidator"></textarea>
    </td>
    </tr>
    </table>
</td>
<tr>
<td>
<table>
	<tr><td><b>Generated test cases</b></td></tr>
	<tr><td><textarea cols="90" rows="10" id="result"></textarea></td></tr>
</table>
</td>
<td valign="top"> <table>
	 <tr><td align="center"><b>Steps</b></td><td><input type="text" id="depth" size=6></td>
	 	<td><button onclick="runningTesting()"><b>TEST</b></button></td></tr>
	   </table> 
	</td>
</tr>
<script>
	$(document).ready(function () {
  //called when key is pressed in textbox
  $("#depth").keypress(function (e) {
     //if the letter is not digit then display error and don't type anything
     if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
         return false;
    }
   });
});
</script>
</td>
<tr>
<td>
	<table>
<tr>
<td><b>Input Property</b></td>
</tr>
<tr>
<td>
<textarea id="input"></textarea>
</td>
</tr>
</table>
</td>
<td>
	    <table>
    <tr>
    <td>
    <br><br><br><button onclick="schemaInputValidator()">XML Schema Input Validation</button>
    </td>
    </tr>	
    <tr>
    <td>
    <textarea cols="25" rows=2 id="XMLSchemaInputValidator"></textarea>
    </td>
    </tr>
    </table>
</td>
</tr>
<tr>
<td>
		<table>
<tr>
<td><b>Output Property</b></td>
</tr>
<tr>
<td>
<textarea id="output"></textarea>
</td>
</tr>
</table>
</td>
<td>
	    <table>
    <tr>
    <td>
    <br><br><br><button onclick="schemaOutputValidator()">XML Schema Output Validation</button>
    </td>
    </tr>	
    <tr>
    <td>
    <textarea cols="25" rows=2 id="XMLSchemaOutputValidator"></textarea>
    </td>
    </tr>
    </table>
</td>
</tr>
<tr>
<td>
		<table>
<tr>
<td><b>Input-Output Property</b></td>
</tr>
<tr>
<td>
<textarea id="inputoutput"></textarea>
</td>
</tr>
</table>
</td>
<td>
	    <table>
    <tr>
    <td>
    <br><br><br><button onclick="schemaInputOutputValidator()">XML Schema Input Output Validation</button>
    </td>
    </tr>	
    <tr>
    <td>
    <textarea cols="25" rows=2 id="XMLSchemaInputOutputValidator"></textarea>
    </td>
    </tr>
    </table>
</td>
</tr>
</table>


			
			</div> <!--  end tabs-2 -->

		</div> <!-- end div tabs -->
</div> <!--  end div cuerpo -->

<script>
var editor1 = CodeMirror.fromTextArea(document.getElementById("schema"), {
  mode: "application/xml",
  styleActiveLine: true,
  lineNumbers: true,
  lineWrapping: true
});
  
  editor1.setSize(600,300);

var editor2 = CodeMirror.fromTextArea(document.getElementById("program"), {
  mode: "application/xquery",
  styleActiveLine: true,
  lineNumbers: true,
  lineWrapping: true
});

 editor2.setSize(600,150);

var editor3 = CodeMirror.fromTextArea(document.getElementById("input"), {
  mode: "application/xquery",
  styleActiveLine: true,
  lineNumbers: true,
  lineWrapping: true
});

 editor3.setSize(600,150);

var editor4 = CodeMirror.fromTextArea(document.getElementById("output"), {
  mode: "application/xquery",
  styleActiveLine: true,
  lineNumbers: true,
  lineWrapping: true
});

 editor4.setSize(600,150);

var editor5 = CodeMirror.fromTextArea(document.getElementById("inputoutput"), {
  mode: "application/xquery",
  styleActiveLine: true,
  lineNumbers: true,
  lineWrapping: true
  
});
 
 editor5.setSize(600,150);
 
 var editor6 = CodeMirror.fromTextArea(document.getElementById("DTDSchema"), {
  mode: "application/xmly",
  styleActiveLine: true,
  lineNumbers: false,
  lineWrapping: true
  
});

 editor6.setSize(220,100);
 
 var editor7 = CodeMirror.fromTextArea(document.getElementById("XMLSchemaPorgramValidator"), {
  mode: "application/xml",
  styleActiveLine: true,
  lineNumbers: false,
  lineWrapping: true
  
});

 editor7.setSize(220,100);
 
  var editor8 = CodeMirror.fromTextArea(document.getElementById("result"), {
  mode: "application/xml",
  styleActiveLine: true,
  lineNumbers: true,
  lineWrapping: true  
});

editor8.setSize(600,150);

  var editor9 = CodeMirror.fromTextArea(document.getElementById("XMLSchemaInputValidator"), {
  mode: "application/xml",
  styleActiveLine: true,
  lineNumbers: false,
  lineWrapping: true  
});

editor9.setSize(220,100);

  var editor10 = CodeMirror.fromTextArea(document.getElementById("XMLSchemaOutputValidator"), {
  mode: "application/xml",
  styleActiveLine: true,
  lineNumbers: false,
  lineWrapping: true  
});

editor10.setSize(220,100);


  var editor11 = CodeMirror.fromTextArea(document.getElementById("XMLSchemaInputOutputValidator"), {
  mode: "application/xml",
  styleActiveLine: true,
  lineNumbers: false,
  lineWrapping: true  
});

editor11.setSize(220,100);

 
</script>

<script language="JavaScript" type="text/javascript">

function removeAll() {
	editor1.getDoc().setValue("");
	editor2.getDoc().setValue("");
	editor3.getDoc().setValue("");
	editor4.getDoc().setValue("");
	editor5.getDoc().setValue("");
	editor6.getDoc().setValue("");
	editor7.getDoc().setValue("");
	$('#depth').val("");
	editor8.getDoc().setValue("");
}

 function databaseListing(){
      
	  var url = 'http://textualtesting.cloudapp.net:8984/rest/appSetup/appSetup.xml';
	  	  
	    $.ajax({
        url: 'elementsFromAPI.php',
        type: 'GET',
        data: {url:url},
        dataType: 'text',
        success: actualizar
      })
      function actualizar(datos){

  		var XML = datos; 
        
        var xmlDoc = $.parseXML( XML );
        var $xml = $( xmlDoc );
        var $database = $xml.find('database');
        var $selection = $('#database');
        
        $selection.empty();
        
        $('#database').append(
    		$('<option selected value/>')
        	.text("select a schema")
        	.val(0)
        ); 
        
        $database.each(function(){
         var $elem = $(this);
         var $databaseName = $elem.find('name').text();	
         $('#database').append(
    		$('<option />')
        	.text($databaseName)
        	.val($databaseName)
        );      	
        }
        )
       }      
    }

function loadDatabase(){
   
   var url; 
   
   if ($('#database').val() != 0)
   {
     url = 'http://textualtesting.cloudapp.net:8984/rest/' + $('#database').val() +'/' +  $('#database').val() + '.xsd';
 
     $.ajax({
          url: 'elementsFromAPI.php',
          type: 'GET',
          data: {url:url},
          dataType: 'text',
          success: actualizar
      }) 
      function actualizar(datos){ 
  		editor1.getDoc().setValue(datos);
      }
   }
}


function loadCode() {
   
   var cadena;
   
   var url; 
   
   if ($('#examples').val() =='ex08') {
   	    cadena = "declare function tc:q($file)\n{\n for $b in $file//book \n let $e := $b/*[contains(string(.), 'Suciu') and ends-with(local-name(.), 'or')] where exists($e)\n return\n <book>\n { $b/title } \n { $e }\n </book>\n };";
   	    editor2.getDoc().setValue(cadena);
        cadena = "declare function tc:i($file)\n{\n  true() \n};"; 
        editor3.getDoc().setValue(cadena);
        cadena = "declare function tc:o($books)\n{\n every $book in $books satisfies \n every $item in $book/* satisfies contains(string($item),'Suciu') or name($item)='title'\n};";
        editor4.getDoc().setValue(cadena);
        cadena = "declare function tc:io($file,$books)\n{\n  true() \n};";
        editor5.getDoc().setValue(cadena);
        $('#depth').val(1);        
      }
      else 
         if ($('#examples').val() =='ex09') {
   	  	    cadena = "declare function tc:q($file)\n{\n<results>\n{\n for $t in $file//(chapter|section)/title \n where contains($t/text(), 'XML')\n return $t \n}\n<\/results>\n};";
            editor2.getDoc().setValue(cadena);
            cadena = "declare function tc:i($file)\n{\n true()\n};"; 
            editor3.getDoc().setValue(cadena);
            cadena = "declare function tc:o($results)\n{\n every $result in $results/* satisfies contains($result/text(),'XML')\n};"; 
            editor4.getDoc().setValue(cadena);
            cadena = "declare function tc:io($file,$results)\n{\n every $title in $results/* satisfies every $f in $file//(chapter | section)/title satisfies not($title/text()=$f/text())\n};"; 
            editor5.getDoc().setValue(cadena);
            $('#depth').val(5);        
      }      
}
</script>

<script language="JavaScript" type="text/javascript">

function runningTesting(){
	
	var text = editor1.getValue();  
	var program = editor2.getValue();
	var input = editor3.getValue();
	var output = editor4.getValue();
	var inputoutput = editor5.getValue();
	var depth = $('#depth').val();
	    
    if (text == ""){
    	alert('XML Schema is blank');
    } else if (program == ""){
         	alert('Program is blank');
         } else if (input == ""){
         		   alert('Input Property is blank');
         		} else if (output == ""){
         				alert('Output Property  is blank');
         			} else if (inputoutput == ""){
         			 		alert('Input Output Property is blank');
         			 	} else if (depth == ""){
         			 			alert('Depth is blank');
         			 		} 
     else {
         			 		
         		
    // Drop database

    var url = 'http://textualtesting.cloudapp.net:8984/rest?run=droppingDatabase.xq'; 

    // Create database

    var url = 'http://textualtesting.cloudapp.net:8984/rest?run=creatingDatabase.xq&textArea=' + encodeURIComponent(text); 
    
    // Cambiar para que sea síncrono
      
     createDatabase(url); 
 
     // Run Test Cases

      var url = 'http://textualtesting.cloudapp.net:8984/rest?run=runningXQueryEval.xq&program=' + encodeURIComponent(program) + '&input=' + 
                encodeURIComponent(input) + '&output=' + encodeURIComponent(output) + '&inputoutput=' + encodeURIComponent(inputoutput) +
                '&depth=' + encodeURIComponent(depth); 

      runTest(url);
     }
}

  function createDatabase(url) {
    $.ajax({
      url: 'elementsFromAPI.php',
      type: 'GET',
      data: {url:url},
      dataType: 'text',
      async: false,
    })
 }
 
   function runTest(url) {
    $.ajax({
      url: 'elementsFromAPI.php',
      type: 'GET',
      data: {url:url},
      dataType: 'text',
      success: actualizar
    }
    )
      function actualizar(datos){
  		editor8.getDoc().setValue(datos);;
    }
  }
  
</script>

<script>
	
function dtdValidator(){
	
    var text = editor1.getValue();  
    
    if (text != "")
    {
      
      var url = 'http://textualtesting.cloudapp.net:8984/rest?run=dtdValidation.xq&textArea=' + encodeURIComponent(text); 

      $.ajax({
      url: 'elementsFromAPI.php',
          type: 'GET',
          data: {url:url},
          dataType: 'text',
          success: actualizar
      }) 
      function actualizar(datos){ 
  		editor6.getDoc().setValue(datos);
      }
   }
   else {
   	alert('XML Schema is blank');
   }
}	
	
</script>

</body>
</html>
