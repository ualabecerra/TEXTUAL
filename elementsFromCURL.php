 <?php 
 
  $url = $_POST['url'];
  $option = $_POST['option'];

  if ($option == 0)   
    $fields = array('content' => urldecode($_POST['schema']));
  else if ($option == 1) 
  	$fields = array('program' => urldecode($_POST['program']),
  	                      'input' => urldecode($_POST['input']),
  	                      'output' => urldecode($_POST['output']),
  	                      'inputoutput' => urldecode($_POST['inputoutput']),
  	                      'depth' => urldecode($_POST['depth']));
  else if ($option == 2) 
  	$fields = array('content' => urldecode($_POST['schema']),
  	                'program' => urldecode($_POST['program']));
  else if ($option == 3)
       $fields = array('input' => urldecode($_POST['inputSchema']),
                       'output' => urldecode($_POST['outputSchema']),
  	                   'program' => urldecode($_POST['program']));
  	                
  $ch = curl_init();

  curl_setopt( $ch, CURLOPT_URL, $url);
  curl_setopt( $ch, CURLOPT_POST, true);
  curl_setopt( $ch, CURLOPT_HTTPHEADER, array('Authorization: Basic ' . base64_encode("$userBaseX:$passwordBaseX")));
  curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
  curl_setopt( $ch, CURLOPT_POSTFIELDS, $fields);
   
  $result = curl_exec($ch);
  
  curl_close($ch);
  
  echo $result; 
  
?>