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

		$base_api = "base_api.xml";
		$xml = simplexml_load_file($base_api);

		foreach ($markers as $marker) {
			$item = $xml->Content->addChild("Source");
			$item->addAttribute("id", $marker->id);
			$item->addChild("name", $marker->name);
			$item->addChild("title", $marker->title);
			$item->addChild("description", $marker->description);
			$item->addChild("longitude", $marker->longitude);
			$item->addChild("latitude", $marker->latitude);
			$item->addChild("markerIcon", $marker->markerIcon);

			$concept = $item->addChild("concept");
			$constructie = $item->addChild("constructie");
			$resultaat = $item->addChild("resultaat");

			foreach ($marker->content as $content) {
				switch ( strtolower($content->category) ) {
					case "concept":
						$media = $concept->addChild(strtolower($content->contentType));
						break;
					case "constructie":
						$media = $constructie->addChild(strtolower($content->contentType));
						break;
					case "resultaat":
						$media = $resultaat->addChild(strtolower($content->contentType));
						break;
				}

				@$media->addChild("url",$content->url);
				$media->addChild("title",$content->title);
				$media->addChild("description",$content->description);
				$media->addChild("author",$content->author);
				$media->addChild("publish",$content->publish);
			}
		}

		RestUtils::sendResponse(200, $xml->asXML(), 'text/xml');
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