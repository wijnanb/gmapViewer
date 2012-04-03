<?php
require_once("db_connection.php");
require_once("RestUtils.php");
require_once("RestRequest.php");

$request = RestUtils::processRequest();

$db_connection = connect_db();

switch($request->getMethod())
{
	case 'get':
		// GET ALL MARKERS
		$query = "SELECT * FROM markers ORDER BY id";
		$result = mysql_query($query);

		$output = new StdClass();
		$output->markers = array();
		while( $row = mysql_fetch_object($result) ) {
			array_push( $output->markers, $row );
		}

		RestUtils::sendResponse(200, json_encode($output), 'application/json');
		break;
	
	case 'post':
		// INSERT NEW MARKER
		$data = $request->getRequestVars();

		$name = mysql_real_escape_string( isset($data['name'])?$data['name']:""  );
		$title = mysql_real_escape_string( isset($data['title'])?$data['title']:"" );
		$description = mysql_real_escape_string( isset($data['description'])?$data['description']:"" );
		$longitude = mysql_real_escape_string( isset($data['longitude'])?$data['longitude']:"" );
		$latitude = mysql_real_escape_string( isset($data['latitude'])?$data['latitude']:"" );
		$markerIcon = mysql_real_escape_string( isset($data['markerIcon'])?$data['markerIcon']:"" );

		$query = "INSERT INTO markers SET
				  name='$name',
				  title='$title',
				  description='$description',
				  longitude='$longitude',
				  latitude='$latitude',
				  markerIcon='$markerIcon'";
		$result = mysql_query($query);
		$insert_id = mysql_insert_id();

		$output = new StdClass();
		$output->result = "inserted";
		$output->id = $insert_id;

		RestUtils::sendResponse(201, json_encode($output), 'application/json');
		break;

	case 'put':
		// UPDATE MARKER
		$data = $request->getRequestVars();

		$marker_id = mysql_real_escape_string( isset($data['marker_id'])?$data['marker_id']:"" );
		$name = mysql_real_escape_string( isset($data['name'])?$data['name']:""  );
		$title = mysql_real_escape_string( isset($data['title'])?$data['title']:"" );
		$description = mysql_real_escape_string( isset($data['description'])?$data['description']:"" );
		$longitude = mysql_real_escape_string( isset($data['longitude'])?$data['longitude']:"" );
		$latitude = mysql_real_escape_string( isset($data['latitude'])?$data['latitude']:"" );
		$markerIcon = mysql_real_escape_string( isset($data['markerIcon'])?$data['markerIcon']:"" );

		$query = "UPDATE markers SET
				  name='$name',
				  title='$title',
				  description='$description',
				  longitude='$longitude',
				  latitude='$latitude',
				  markerIcon='$markerIcon'
				  WHERE id=$marker_id";
		$result = mysql_query($query);
		$output = new StdClass();
		$output->result = "updated";
		$output->id = $marker_id;

		RestUtils::sendResponse(200, json_encode($output), 'application/json');
		break;

	case 'delete':
		$output = new StdClass();

		if ($id = $request->getId()) {
			$marker_id = mysql_real_escape_string( $id );

			$query = "DELETE FROM markers WHERE id=$marker_id";
			$result = mysql_query($query);

			$output->result = "deleted";
			$output->id = $id;
			RestUtils::sendResponse(200, json_encode($output), 'application/json');
		} else {
			$output->result = "error";
			$output->message = "id not specified";
			RestUtils::sendResponse(400, json_encode($output), 'application/json');
		}
		break;
}

close_db($db_connection);

?>