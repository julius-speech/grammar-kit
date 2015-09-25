#!/usr/bin/perl
#
# dfa_clean.pl --- Clean up DFA, TERM and DICT
#   o Remove duplicated links in DFA
#   o Remove words not used in DFA
#
# usage: dfa_clean.pl input_basename output_basename
# 

$node_start = 0;
$node_end = -1;
$maxsym = -1;

$modified = 0;

if ($#ARGV != 1) {
    print "usage: dfa_clean.pl InputGramBase OutputGramBase\n";
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
$tnum = 0;
while(<D>) {
    @a = split;
    $symname[$a[0]] = $a[1];
    $symid{"$a[1]"} = $a[0];
    $tnum++;
}
close(D);

#### read DFA file
open(D, "${base}.dfa") || die "cannot open ${base}.dfa\n";
$dnum = 0;
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
    $from[$dnum] = $a[0];
    $sym[$dnum] = $a[1];
    $to[$dnum] = $a[2];
    $dnum++;
}
close(D);

printf("%s: %d nodes, %d arcs, %d terminal symbols, %d word entries\n",
       $base, $maxstate+1, $dnum, $tnum, $wnum);

#### remove duplicated links in DFA
$new_dnum = 0;
for($i=0;$i<$dnum;$i++) {
    $mode = 0;
    for($j=0;$j<$new_dnum;$j++) {
	$d = $idx[$j];
	if ($from[$i] == $from[$d] && $sym[$i] == $sym[$d] && $to[$i] == $to[$d]) {
	    $mode = 1;
	    last;
	}
    }
    if ($mode == 0) {
	$idx[$new_dnum] = $i;
	$new_dnum++;
    }
}
if ($new_dnum != $dnum) {
    printf("- there are %d duplicated arcs: removed\n", $dnum - $new_dnum);
    $modified = 1;
}

#### check TERM usage in DFA
$new_tnum = 0;
for($i=0;$i<$new_dnum;$i++) {
    $s = $sym[$idx[$i]];
    $mode = 0;
    for($j=0;$j<$new_tnum;$j++) {
	$d = $tidx[$j];
	if ($d == $s) {
	    $mode = 1;
	    last;
	}
    }
    if ($mode == 0) {
	$tidx[$new_tnum] = $s;
	$new_tnum++;
    }
}
if ($new_tnum != $tnum) {
    printf("- %d terminal symbols does not appear in DFA: removed\n", $tnum - $new_tnum);
    $modified = 1;
}

#### make old->new term map
for($i=0;$i<=$maxsym;$i++) {
    $newterm[$i] = -1;
}
for($i=0;$i<$new_tnum;$i++) {
    $newterm[$tidx[$i]] = $i;
}

#### rename symbol ID in DFA and output
open(D, ">${outbase}.dfa") || die "cannot open ${outbase}.dfa for writing";
for($i=0;$i<$new_dnum;$i++) {
    $j = $idx[$i];
    if ($newterm[$sym[$j]] == -1) {
	die "InternalError!\n";
    }
    printf D ("%d %d %d 0 0\n", $from[$j], $newterm[$sym[$j]], $to[$j]);
}
printf D ("%d -1 -1 1 0\n", $node_end);
close(D);

#### output TERM
open(D, ">${outbase}.term") || die "cannot open ${outbase}.term for writing";
for($i=0;$i<$new_tnum;$i++) {
    printf D ("%d %s\n", $i, $symname[$tidx[$i]]);
}
close(D);

### update DICT
open(D, ">${outbase}.dict") || die "cannot open ${outbase}.dict for writing";
$new_wnum=0;
for($i=0;$i<$wnum;$i++) {
    next if ($newterm[$wstr[$i]] == -1);
    printf D ("%d\t\[%s\]\t%s\n", $newterm[$wstr[$i]], $outstr[$i], $pron[$i]);
    $new_wnum++;
}
if ($new_wnum != $wnum) {
    printf("- %d word entries removed since not appear in DFA: removed\n", $wnum - $new_wnum);
    $modified = 1;
}
close(D);

if ($modified == 1) {
    printf("%s: %d nodes, %d arcs, %d terminal symbols, %d word entries\n",
	   $outbase, $maxstate+1, $new_dnum, $new_tnum, $new_wnum);
} else {
    printf("No data to clean.  The input and output are idential.\n");
}
