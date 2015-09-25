#!/usr/bin/perl

while(<>) {
    if (/N=([0-9]+)[ \t]+L=([0-9]+)/) {
	$nnum = $1;
	$lnum = $2;
    }
    if (/I=([0-9]+)[ \t]+W=([^ \t\n]+)/) {
	$node[$1] = $2;
    }
    if (/J=([0-9]+)[ \t]+S=([0-9]+)[ \t]+E=([0-9]+)/) {
	$link_from[$1] = $2;
	$link_to[$1] = $3;
	$link_word[$1] = "";
    }
    if (/J=([0-9]+)[ \t]+S=([0-9]+)[ \t]+E=([0-9]+)[ \t]+W=([^ \t\n]+)/) {
	$link_from[$1] = $2;
	$link_to[$1] = $3;
	$link_word[$1] = $4;
    }
}

for($n=0;$n<$nnum;$n++) {
    if ($node[$n] eq "!START") {
	$start_node = $n;
    }
    if ($node[$n] eq "!END") {
	$end_node = $n;
    }
}
for($l=0;$l<$lnum;$l++) {
    if ($link_from[$l] == 0) {
	$link_from[$l] = $start_node;
    } elsif ($link_from[$l] == $start_node) {
	$link_from[$l] = 0;
    }
    if ($link_to[$l] == 0) {
	$link_to[$l] = $start_node;
    } elsif ($link_to[$l] == $start_node) {
	$link_to[$l] = 0;
    }
}

$symnum = 0;
for($l=0;$l<$lnum;$l++) {
    $symid = -1;
    for($i=0;$i<$symnum;$i++) {
	if ($sym[$i] eq $link_word[$l]) {
	    $symid = $i;
	}
    }
    if ($symid == -1) {
	$sym[$symnum] = $link_word[$l];
	$symid = $symnum;
	$symnum++;
    }
    printf("%d %d %d 0 0\n", $link_from[$l], $symid, $link_to[$l]);
}
printf("%d -1 -1 1 0\n", $end_node);
for($i=0;$i<$symnum;$i++) {
    printf STDERR ("%d %s\n", $i, $sym[$i]);
}
