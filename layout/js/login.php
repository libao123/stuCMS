<?php
	
	require './config.php';
	
	$num = $_POST['phone'];

	$sql ="select * from login";

	$res = $pdo->query($sql);
	$arr=$res->fetchAll(PDO::FETCH_ASSOC);
	
	$flag=0;
	foreach($arr as $key=>$val){
		if($val['phone']==$num){
			$flag=1;
			break;
		}else{
			$flag=0;
		}
	}
	echo $flag;
