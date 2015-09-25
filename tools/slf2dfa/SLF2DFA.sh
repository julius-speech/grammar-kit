#!/bin/sh
#
# usage: SLF2DFA.sh filename.slf
#
#  - file name should have ".slf" as suffix.
#  - you should define paths to determinization and minimization tools below.
#  - the perl scripts should exist at the same directory of this script:

# get directory name where this script exists
dir=`dirname $0`

# DFA determinization tool
#determinize_bin="/usr/local/julius/bin/dfa_determinize"
determinize_bin=$HOME/julius/bin/dfa_determinize

# DFA minimization tool
#minimize_bin="/usr/local/julius/bin/dfa_minimize"
minimize_bin=$HOME/julius/bin/dfa_minimize

######################################################################

base=$1

if test -z ${base}; then
   echo "SLF2DFA.sh --- Convert .slf/.htkdic to .dfa/.term/.dict"
   echo "usage: SLF2DFA.sh basename"
   exit
fi
if test ! -f ${base}.slf; then
   echo "\"$1.slf\" not exist, terminated"
   exit
fi
if test ! -f ${base}.htkdic; then
   echo "\"$1.htkdic\" not exist, terminated"
   exit
fi

echo ">> 1. remove NULL nodes"
${dir}/remove_null.pl ${base}.slf > _${base}-1-remove-null.slf
echo
echo ">> 2. convert from moore (output=node) to mealy (output=link)"
${dir}/moore2mealy.pl _${base}-1-remove-null.slf > _${base}-2-mealy.slf
echo
echo ">> 3. convert format to DFA"
${dir}/slf2dfa.pl _${base}-2-mealy.slf > _${base}-3-dfa.dfa 2> ${base}.term
echo
echo ">> 4. reverse the DFA for Julian"
${dir}/dfarev.pl _${base}-3-dfa.dfa | sort -n > _${base}-4-reversed.dfa
echo
echo ">> 5. determinize the DFA (non-deterministic links are generated at 2)"
${determinize_bin} _${base}-4-reversed.dfa | sort -n > _${base}-5-determinized.dfa
echo
echo ">> 6. minimize the DFA"
${minimize_bin} _${base}-5-determinized.dfa | sort -n > _${base}-6-final.dfa
cp _${base}-6-final.dfa ${base}.dfa
echo
echo ">> 7. convert dict, extracting needed words"
${dir}/dict2dict.pl ${base}.term ${base}.htkdic > ${base}.dict
echo

#### rest are optimization for Julian grammar

mv ${base}.dfa _${base}.dfa
mv ${base}.term _${base}.term
mv ${base}.dict _${base}.dict

echo ">> 8. auto-create word categories from the transition patterns"
${dir}/dfa_make_category.pl _${base} _${base}_tmp
echo
echo ">> 9. remove the entries that becomes redundant by the category creation"
${dir}/dfa_clean.pl _${base}_tmp ${base}
echo
echo ALL PROCESS FINISHED
echo converted files are: ${base}.dfa, ${base}.term, ${base}.dict
