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
    }
}

$new_nnum = 0;
for($n=0;$n<$nnum;$n++) {
    if ($node[$n] ne "!NULL") {
	$nindex[$n] = $new_nnum;
	$new_nnum++;
    } else {
	$nindex[$n] = -1;
    }
}

$new_lnum = 0;
for($n=0;$n<$nnum;$n++) {
    @list = ();
    &getlist($n);
    next if ($nindex[$n] == -1);
    foreach $l (@list) {
	if ($nindex[$l] != -1) {
	    $new_lnum++;
	}
    }
}

printf("N=%d\tL=%d\n", $new_nnum, $new_lnum);

for($n=0;$n<$nnum;$n++) {
    if ($nindex[$n] != -1) {
	printf("I=%d\tW=%s\n", $nindex[$n], $node[$n]);
    }
}

$new_lnum = 0;
for($n=0;$n<$nnum;$n++) {
    @list = ();
    &getlist($n);
    foreach $l (@list) {
	next if ($nindex[$n] == -1);
	next if ($nindex[$l] == -1);
	printf("J=%d\tS=%d\tE=%d\n", $new_lnum, $nindex[$n], $nindex[$l]);
	$new_lnum++;
    }
}

sub getlist {
    local($from) = @_;

    for($l=0;$l<$lnum;$l++) {
	if ($link_from[$l] == $from) {
	    if ($node[$link_to[$l]] eq "!NULL") {
		&getlist($link_to[$l]);
	    } else {
		push(@list, $link_to[$l]);
	    }
	}
    }
}
