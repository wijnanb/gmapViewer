<?php
require_once("db_connection.php");
require_once("RestUtils.php");
require_once("RestRequest.php");

$request = RestUtils::processRequest();

$db_connection = connect_db();

switch($request->getMethod())
{
	case 'get':
		// GET ALL THE CONTENT AS ONE XML
		$query = "SELECT * FROM markers ORDER BY id";
		$result = mysql_query($query);
		if (mysql_error()) echo mysql_error() . "\r\n";

		$markers = array();
		while( $row = mysql_fetch_object($result) ) {
			$marker_id = $row->id;

			$row->content = array();

			$query_content = "SELECT * FROM content WHERE marker_id=$marker_id ORDER BY id";
			$result_content = mysql_query($query_content);

			if (mysql_error()) echo mysql_error() . "\r\n";

			while( $row_content = mysql_fetch_object($result_content) ) {
				array_push( $row->content, $row_content );
			}

			array_push( $markers, $row );
		}

		$output = "";

		foreach ($markers as $marker) {

			$split = explode("/",$marker->markerIcon);
			$filename = $split[ sizeOf($split)-1 ];
			$url = str_replace(" ", "%20", $marker->markerIcon);
			$output .= "curl -o \"$filename\" \"" . $url . "\";\r\n";

			foreach ($marker->content as $content) {
				if ( strtolower($content->contentType) == "image" ) {
					$split = explode("/",$content->url);
					$filename = $split[ sizeOf($split)-1 ];
					$url = str_replace(" ", "%20", $content->url);
					$output .= "curl -o \"$filename\" \"" . $url . "\";\r\n";
				}
			}
		}

		RestUtils::sendResponse(200, $output, 'text/plain');
		break;
	
	case 'post':
		break;

	case 'put':
		break;

	case 'delete':
		break;
}

close_db($db_connection);

?>