<?php
define('DAYS', 7);
if ($argc > 1) {
    $url = realpath($argv[1]);
    if (!is_readable($url) || !is_file($url)) {
        exit('file not readable');
    }
    fwrite($stderr, 'Using '.$url. "\n");
} else {
    $url = 'http://feeds.pinboard.in/json/v1/u:winks/';
    $stderr = fopen('php://stderr', 'w');
    fwrite($stderr, 'Using '.$url. "\n");
}
$source = file_get_contents($url);

$json = json_decode($source, true);

$tsMonday = strtotime("last Sunday");
$oneDay =  60 * 60 * 24;
$oneWeek = $oneDay * DAYS;
$dMonday = date("Y-m-d", $tsMonday+$oneDay);
echo $dMonday . PHP_EOL;
$tsLastMonday = $tsMonday-$oneWeek+$oneDay;
$dLastMonday = date("Y-m-d", $tsLastMonday);
echo $dLastMonday . PHP_EOL;

foreach ($json as $item) {
    if ($item['dt'] < $dLastMonday || $item['dt'] > $dMonday) {
        continue;
    }
    #printf('%s' . PHP_EOL, $item['dt']);
    $slug = strtolower(preg_replace('([^A-Za-z0-9]+)','', $item['d']));
    printf("### %s\n", implode('/', $item['t']));
    printf(" - [%s][%s]\n\n[%s]: %s\n\n", $item['d'], $slug, $slug, $item['u']);
}
printf('Items: %d' . PHP_EOL, count($json));
