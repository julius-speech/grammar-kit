#!/usr/bin/perl
#
# usage: dfa_make_category.pl input_basename output_basename
# 

$node_start = 0;
$node_end = -1;
$maxsym = -1;

if ($#ARGV != 1) {
    print "usage: dfa_make_category.pl InputGramBase OutputGramBase\n";
    exit 1;
}

$base = shift;
$outbase = shift;

#### read DICT file
open(D, "${base}.dict") || die "cannot open ${base}.dict\n";
$wnum=0;
while(<D>) {
    @a = split;
    $wstr[$wnum] = shift(@a);
    if ($a[0] =~ /^\[([^\[\]]*)\]$/) {
	$outstr[$wnum] = $1;
	shift(@a);
    } else {
	$outstr[$wnum] = $wstr;
    }
    $pron[$wnum] = join(' ', @a);
    $wnum++;
}
close(D);

#### read TERM file
open(D, "${base}.term") || die "cannot open ${base}.term\n";
$tnum=0;
while(<D>) {
    @a = split;
    $symname[$a[0]] = $a[1];
    $symid{"$a[1]"} = $a[0];
    $tnum++;
}
close(D);

#### read DFA file
open(D, "${base}.dfa") || die "cannot open ${base}.dfa\n";
while(<D>) {
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
    if ($maxsym < $a[1]) {
	$maxsym = $a[1];
    }
    $from[$n] = $a[0];
    $sym[$n] = $a[1];
    $to[$n] = $a[2];
    $n++;
}
close(D);

printf("%s: %d nodes, %d arcs, %d terminal symbols, %d word entries\n",
       $base, $maxstate+1, $n, $tnum, $wnum);


#### count keta
$k=0;
$j=$maxstate;
while($j>0) {
    $j = int($j / 10);
    $k++;
}

#### make arcs description list
@arcs = ();
for($i=0;$i<$n;$i++) {
    $str = sprintf("%0${k}d-%0${k}d=%0${k}d", $from[$i], $to[$i], $sym[$i]);
    push(@arcs, $str);
}

#### make cluster
$num=0;
for($i=0;$i<=$maxstate;$i++) {
    for($j=0;$j<=$maxstate;$j++) {
	$str = sprintf("%0${k}d-%0${k}d=", $i, $j);
	@list = grep(/$str/, @arcs);
	if ($#list >= 1) {
	    $stateset[$num] = sprintf("%0${k}d-%0${k}d", $i, $j);
	    foreach $s (@list) {
		($c) = ($s =~ /=(.*)$/);
		$cluster[$num] .= ",$c";
	    }
	    $num++;
	}
    }
}

for($i=0;$i<$num;$i++) {
    print "between $stateset[$i]: labels=$cluster[$i]\n";
}

#### bundle to make a new category
$bnum = 0;
for($i=0;$i<$num;$i++) {
    if (! $cluster2bundle{"$cluster[$i]"}) {
	$cluster2bundle{"$cluster[$i]"} = "_CATEGORY_$bnum";
	$bnum++;
    }
}
foreach $i (keys %cluster2bundle) {
    printf STDERR ("NEW TERM: %s: %s\n", $cluster2bundle{$i}, $i);
}

#### add the new bundled clusters to term
for($i=0;$i<$bnum;$i++) {
    $newid = $maxsym + 1 + $i;
    $symname[$newid] = "_CATEGORY_$i";
    $symid{"_CATEGORY_$i"} = $newid;
}
$maxsym += $bnum;

#### replace DFA transition with the new clusters and output
open(D, ">${outbase}.dfa") || die "cannot open ${outbase}.dfa for writing";
$new_dnum = 0;
for($i=0;$i<$n;$i++) {
    $str = sprintf("%0${k}d-%0${k}d", $from[$i], $to[$i]);
    $mode = 0;
    for($j=0;$j<$num;$j++) {
	if ($stateset[$j] eq $str) {
	    if ($output[$j] == 0) {
		printf D ("%d %d %d 0 0\n", $from[$i], $symid{$cluster2bundle{"$cluster[$j]"}}, $to[$i]);
		$output[$j] = 1;
		$new_dnum++;
	    }
	    $mode = 1;
	}
    }
    if ($mode == 0) {
	printf D ("%d %d %d 0 0\n", $from[$i], $sym[$i], $to[$i]);
	$new_dnum++;
    }
}
printf D ("%d -1 -1 1 0\n", $node_end);
close(D);

### output new TERM
open(D, ">${outbase}.term") || die "cannot open ${outbase}.term for writing";
for($i=0;$i<=$maxsym;$i++) {
    print D "$i $symname[$i]\n";
}
close(D);

### generate a new WORDS in the category
$new_w_num = 0;
foreach $b (keys %cluster2bundle) {
    $j = $symid{$cluster2bundle{$b}};
    @clist = split(/,/, $b);
    shift @clist;
    foreach $c (@clist) {
	$wnum_l = $wnum;
	for($k=0;$k<$wnum_l;$k++) {
	    if ($wstr[$k] == $c) {
		$wstr[$wnum] = $j;
		$outstr[$wnum] = $outstr[$k];
		$pron[$wnum] = $pron[$k];
		$wnum++;
		$new_w_num++;
	    }
	}
    }
}

### output new DICT
open(D, ">${outbase}.dict") || die "cannot open ${outbase}.dict for writing";
for($i=0;$i<$wnum;$i++) {
    printf D ("%d\t\[%s\]\t%s\n", $wstr[$i], $outstr[$i], $pron[$i]);
}
close(D);

if ($bnum > 0) {
    printf("- %d new category candidates are found\n", $bnum);
    printf("- %d new terminal symboles are defined for the categories\n", $bnum);
    printf("- %d arcs are bundled by the category definition\n", $n - $new_dnum);
    printf("- %d words newly added for the new category\n", $new_w_num);
    printf("%s: %d nodes, %d arcs, %d terminal symbols, %d word entries\n",
	   $outbase, $maxstate+1, $new_dnum, $maxsym+1, $wnum);
} else {
    printf("No new catgegories found, output is the same as the input\n");
}
