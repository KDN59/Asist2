<?php
// php script for env.html & getSensors.py
// for debug
ini_set('display_errors',1);
error_reporting(E_ALL);

date_default_timezone_set("Europe/Istanbul");
$filename = 'Kalkan_log.txt'; // log file

// get the req parameter from URL
$msg = $_REQUEST['msg'];

// Show the msg, if the code string is empty
if (empty($msg)) {
     echo "Nothing to write";
} else {
    if($msg == 'clean'){
        file_put_contents($filename, "False"."\n");
    } else if($msg == 'status') {
        if(file_exists($filename)) {
            $pr_modify = fgets(fopen($filename, 'r')); // read first line
            echo $pr_modify;
        }
    } else if($msg == 'log') {
        // read log file as array of strings
        $txt_array = explode("\n", file_get_contents($filename));
        // send log without first line
        for ($i = 1; $i < count($txt_array); $i++) {
            echo $txt_array[$i]."<br>";
        }
        // set pr_modify to False
        $txt_array[0] = 'False';
        file_put_contents($filename, implode("\n", $txt_array));
    } else {
        echo $msg;
        // programatically set permissions
         if(!file_exists($filename)){
            file_put_contents($filename, "True"."\n");
            chmod($filename, 0777);
         }
        // add timestamp to $msg
        file_put_contents($filename, date("d/M/Y h:i:s A  ").$msg."\n", FILE_APPEND);
        // set pr_modify to True
        $txt_array = explode("\n", file_get_contents($filename));
        $txt_array[0] = 'True';
        file_put_contents($filename, implode("\n", $txt_array));
    }
}

?>
