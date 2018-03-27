<?php
	require './config.php';
	
	$num = $_POST['phone'];
	$pass= $_POST['pass'];

	$sql ="select * from login";
	$res = $pdo->query($sql);
	$arr=$res->fetchAll(PDO::FETCH_ASSOC);
	// var_dump($arr);
	$flag=0;
	foreach($arr as $key=>$val){
		if($val['phone']==$num&&$val['pass']== $pass){
			$flag=1;
			break;
		}else{
			$flag=0;
		}
	}
	echo $flag;