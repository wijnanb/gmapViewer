<?php

function connect_db() {
	$db_user = "";
	$db_password = "";
	$db_server = "localhost";
	$db_database = "z33admin";

	$db_connection = mysql_connect($db_server, $db_user, $db_password);
	mysql_select_db($db_database);
	mysql_set_charset('utf8',$db_connection); 

	return $db_connection;
}


function close_db($db_connection) {
	mysql_close($db_connection);
}
?>