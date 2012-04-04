<?php
require_once("db_connection.php");
require_once("RestUtils.php");
require_once("RestRequest.php");

$request = RestUtils::processRequest();

$db_connection = connect_db();

switch($request->getMethod())
{
	case 'get':
		break;
	
	case 'post':
		// SAVE UPLOADED JPG IMAGE
		$data = $request->getRequestVars();

		$script_url = "http://".$_SERVER["HTTP_HOST"] . $_SERVER['REQUEST_URI'];
		$url_root = implode( "/", explode("/", $script_url,-1) ) . "/"; //drop last part of script URL
		$path = "uploads/";
		$filename = "IMG_" . date("Ymd_His") . ".jpg";

		$file = fopen( $path.$filename, 'wb' );
		fwrite( $file, $GLOBALS[ 'HTTP_RAW_POST_DATA' ] );
		fclose( $file );

		$url = $url_root . $path . $filename;

		$output = new StdClass();
		$output->result = "uploaded image";
		$output->url = $url;

		RestUtils::sendResponse(201, json_encode($output), 'application/json');
		break;

	case 'put':
		break;

	case 'delete':
		break;
}

close_db($db_connection);

?>