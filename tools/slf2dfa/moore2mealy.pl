#!/usr/bin/perl

while(<>) {
    if (/N=([0-9]+)[ \t]+L=([0-9]+)/) {
	$nnum = $1;
	$lnum = $2;
    }
    if (/I=([0-9]+)[ \t]+W=(.+)$/) {
	$node[$1] = $2;
    }
    if (/J=([0-9]+)[ \t]+S=([0-9]+)[ \t]+E=([0-9]+)/) {
	$link_from[$1] = $2;
	$link_to[$1] = $3;
    }
}

for($l=0;$l<$lnum;$l++) {
    $new_node[$l] = "$link_from[$l]-$link_to[$l]";
    $revlink{"$new_node[$l]"} = $l;
}
$new_nnum = $lnum;

$new_lnum = 0;
for($n=0;$n<$nnum;$n++) {
    @left = ();
    @right = ();
    for($l=0;$l<$lnum;$l++) {
	if ($link_from[$l] == $n) {
	    push(@right, $l);
	}
	if ($link_to[$l] == $n) {
	    push(@left, $l);
	}
    }
    if ($#left == -1) {
	$new_node[$new_nnum] = "!START";
	push(@left, $new_nnum);
	$new_nnum++;
    }
    if ($#right == -1) {
	$new_node[$new_nnum] = "!END";
	push(@right, $new_nnum);
	$new_nnum++;
    }
    foreach $l (@left) {
	foreach $r (@right) {
	    $new_link_from[$new_lnum] = $l;
	    $new_link_to[$new_lnum] = $r;
	    $new_link_word[$new_lnum] = $node[$n];
	    $new_lnum++;
	}
    }
}

printf("N=%d\tL=%d\n", $new_nnum, $new_lnum);

for($n=0;$n<$new_nnum;$n++) {
    printf("I=%d\tW=%s\n", $n, $new_node[$n]);
}
for($l=0;$l<$new_lnum;$l++) {
    printf("J=%d\tS=%d\tE=%d\tW=%s\n",
	   $l, $new_link_from[$l], $new_link_to[$l], $new_link_word[$l]);
}

