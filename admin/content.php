<?php
require_once("db_connection.php");
require_once("RestUtils.php");
require_once("RestRequest.php");

$request = RestUtils::processRequest();

$db_connection = connect_db();

switch($request->getMethod())
{
	case 'get':
		// GET CONTENT FOR MARKER_ID

		$marker_id = mysql_real_escape_string( $request->getId() );

		$query = "SELECT * FROM content WHERE marker_id=$marker_id ORDER BY id";
		$result = mysql_query($query);

		$output = new StdClass();
		$output->content = array();
		while( $row = mysql_fetch_object($result) ) {
			array_push( $output->content, $row );
		}

		RestUtils::sendResponse(200, json_encode($output), 'application/json');
		break;
	
	case 'post':
		RestUtils::sendResponse(201, "New marker created with id:<id>");
		break;
}

close_db($db_connection);

?>