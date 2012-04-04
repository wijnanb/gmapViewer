<?php

$numCells = 8;
$url = 'xml_content.xml';

$marker_id = "27";


$xml = @simplexml_load_file($url);

$i=0;
$line = "";
$document = "";
foreach($xml->children() as $child) {
  $word = utf8_decode($child);
  $word = str_replace(array("\r\n", "\n", "\r"), '<br />', $word);

  $line .= $word . ";";
  $i++;

  if ($i>=($numCells)) {
  	$document .= $marker_id . ";" . $line . "\r\n";
  	$i = 0;
  	$line = "";
  }
}

echo $document;
?>