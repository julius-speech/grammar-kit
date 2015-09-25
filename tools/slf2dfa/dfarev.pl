#!/usr/bin/perl

$node_start = 0;
$node_end = -1;

while(<>) {
    @a = split;
    $a[3] = "0x" . $a[3];
    if ($a[1] == -1 || $a[2] == -1 || ($a[3] & 1) != 0) {
	if ($node_end == -1) {
	    $node_end = $a[0];
	} else {
	    die "More than one accept node!\n";
	}
    }
    next if ($a[1] == -1 || $a[2] == -1);
    if ($maxstate < $a[0]) {
	$maxstate = $a[0];
    }
    if ($maxstate < $a[2]) {
	$maxstate = $a[2];
    }
    $from[$n] = $a[0];
    $sym[$n] = $a[1];
    $to[$n] = $a[2];
    $n++;
}
for($i=0;$i<$n;$i++) {
    if ($from[$i] == $node_end) {
	$from[$i] = $node_start;
    } elsif ($from[$i] == $node_start) {
	$from[$i] = $node_end;
    }
    if ($to[$i] == $node_end) {
	$to[$i] = $node_start;
    } elsif ($to[$i] == $node_start) {
	$to[$i] = $node_end;
    }
}

for($i=0;$i<$n;$i++) {
    printf("%d %d %d 0 0\n", $to[$i], $sym[$i], $from[$i]);
}
printf("%d -1 -1 1 0\n", $node_end);
