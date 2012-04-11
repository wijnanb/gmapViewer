<?php
require_once("db_connection.php");
require_once("RestUtils.php");
require_once("RestRequest.php");
require_once("Logging.php");

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
		if ($error = mysql_error()) {
			$output->result = "error";
			$output->error = mysql_error();
		} else {
			$output->content = array();
			while( $row = mysql_fetch_object($result) ) {
				array_push( $output->content, $row );
			}
		}

		RestUtils::sendResponse(200, json_encode($output), 'application/json');
		break;
	
	case 'post':
		// INSERT NEW CONTENT
		$data = $request->getRequestVars();

		$marker_id = mysql_real_escape_string( isset($data['marker_id'])? stripslashes($data['marker_id']):""  );
		$contentType = mysql_real_escape_string( isset($data['contentType'])? stripslashes($data['contentType']):""  );
		$url = mysql_real_escape_string( isset($data['url'])? stripslashes($data['url']):"" );
		$title = mysql_real_escape_string( isset($data['title'])? stripslashes($data['title']):"" );
		$description = mysql_real_escape_string( isset($data['description'])? stripslashes($data['description']):"" );
		$author = mysql_real_escape_string( isset($data['author'])? stripslashes($data['author']):"" );
		$publish = mysql_real_escape_string( isset($data['publish'])? stripslashes($data['publish']):"" );
		$category = mysql_real_escape_string( isset($data['category'])? stripslashes($data['category']):"" );


		$query = "INSERT INTO content SET
				  marker_id=$marker_id,
				  contentType='$contentType',
				  url='$url',
				  title='$title',
				  description='$description',
				  author='$author',
				  publish='$publish',
				  category='$category'";
		$result = mysql_query($query);
		$insert_id = mysql_insert_id();

		$output = new StdClass();
		if ($error = mysql_error()) {
			$output->result = "error";
			$output->error = mysql_error();
		} else {
			$output->result = "inserted content";
			$output->id = $insert_id;
		}

		$logging = new Logging();
		$logging->log($query);

		RestUtils::sendResponse(201, json_encode($output), 'application/json');
		break;

	case 'put':
		// UPDATE CONTENT
		$data = $request->getRequestVars();

		$content_id = mysql_real_escape_string( isset($data['content_id'])? stripslashes($data['content_id']):""  );
		$marker_id = mysql_real_escape_string( isset($data['marker_id'])? stripslashes($data['marker_id']):""  );
		$contentType = mysql_real_escape_string( isset($data['contentType'])? stripslashes($data['contentType']):""  );
		$url = mysql_real_escape_string( isset($data['url'])? stripslashes($data['url']):"" );
		$title = mysql_real_escape_string( isset($data['title'])? stripslashes($data['title']):"" );
		$description = mysql_real_escape_string( isset($data['description'])? stripslashes($data['description']):"" );
		$author = mysql_real_escape_string( isset($data['author'])? stripslashes($data['author']):"" );
		$publish = mysql_real_escape_string( isset($data['publish'])? stripslashes($data['publish']):"" );
		$category = mysql_real_escape_string( isset($data['category'])? stripslashes($data['category']):"" );

		$query = "UPDATE content SET
				  marker_id=$marker_id,
				  contentType='$contentType',
				  url='$url',
				  title='$title',
				  description='$description',
				  author='$author',
				  publish='$publish',
				  category='$category'
				  WHERE id=$content_id";
		$result = mysql_query($query);

		$output = new StdClass();
		if ($error = mysql_error()) {
			$output->result = "error";
			$output->error = mysql_error();
		} else {
			$output->result = "updated content";
			$output->id = $content_id;
		}
		
		$logging = new Logging();
		$logging->log($query);

		RestUtils::sendResponse(200, json_encode($output), 'application/json');
		break;

	case 'delete':
		$output = new StdClass();

		if ($id = $request->getId()) {
			$content_id = mysql_real_escape_string( $id );

			$query = "DELETE FROM content WHERE id=$content_id";
			$result = mysql_query($query);

			if ($error = mysql_error()) {
				$output->result = "error";
				$output->error = mysql_error();
			} else {
				$output->result = "deleted content";
				$output->id = $id;
			}
			
			$logging = new Logging();
			$logging->log($query);

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