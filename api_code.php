
// the code  name connection.php


<?php
try{
    $connection =new PDO('mysql:host=localhost;dbname=flutter','root','');
    $connection->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
   // echo"ok connection";


}
catch(PDOException $exc){
    echo $exc->getMessage();
    die('could not connect');

}



?>

//the code name getData.php


<?php

require("connection.php");

$makeQuery = "SELECT * FROM lestChat";
$stamement = $connection->prepare($makeQuery);
$stamement->execute();
$myarray =array();
while($resultsFrom = $stamement ->fetch()){
    array_push(
        $myarray,array(
            "id"=>$resultsFrom['id'],
            "heading"=>$resultsFrom['heading'],
            "body"=>$resultsFrom['body']

        )
        );

}

echo json_encode($myarray);




?>



