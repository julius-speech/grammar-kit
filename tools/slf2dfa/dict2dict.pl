#!/usr/bin/perl
#
# convert HTK grammardict to Julian dict 
#

$term = shift;
open(D, "$term") || die "cannot open $term\n";
while(<D>) {
    @a = split;
    $symname[$a[0]] = $a[1];
    $symid{"$a[1]"} = $a[0];
}
close(D);

$num = 0;
while(<>) {
    @a = split;
    $wstr = shift(@a);
    if ($a[0] =~ /^\[([^\[\]]*)\]$/) {
	$outsym = $1;
	shift(@a);
    } else {
	$outsym = $wstr;
    }
    $pron = join(' ', @a);
    
    next if ($symid{"$wstr"} eq "") ;

    print $symid{"$wstr"} . "\t[". $outsym . "]\t" . $pron . "\n";
    $num++;
}

print STDERR "$num words in dict\n";
