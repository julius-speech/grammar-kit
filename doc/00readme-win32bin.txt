Windows binary package of Julius-4.2
=======================================

This archive contains Win32 binaries and documents of Julius rev. 4.2.
To know about this release, see "00readme-julius.txt" and "Release.txt".

From 4.1.3, Julius supports Microsoft Visual C++ 2008.  To compile on
MSVC, download the latest source archive (julius-x.x.x.tar.gz) from
the Web site, unpack and read the document "msvc/00README.txt".


Running environment
====================

The binaries included in this package are for Windows OS, including
2000, XP, Vista and 7.  To do a live recognition of microphone input,
your audio device should support 16kHz, 16bit, monoral recording.
Julius will use DirectSound API for recording.  You may need a direct
X runtime installed on your machine.

The binaries are compiled on cygwin-1.7.5, with "-mno-cygwin" option.

Perl is required to run grammar related tools.  They are tested on
cygwin, MinGW+MSYS and ActivePerl.


Julius and tools
=================

Binaries are located in bin/ :

    [Main]
    julius-*.exe    Julius

    [Tools]
    mkbingram.exe   convert 2-gram and reverse 3-gram to binary format
    mkbinhmm.exe    convert ascii hmmdefs to binary hmmdefs
    mkbinhmmlist.exe convert HMMList to binary file
    mkgshmm	    make GSHMM for Gaussian Mixture Selection
    mkss.exe	    compute noise spectrum from mic for spectral subtraction

    [Utilities]
    adinrec.exe	    record one sentence from microphone to a file
    adintool.exe    enhanced adinrec with segmentation and network support
    jcontrol.exe    sample client for Julius module mode
    jclient.pl	    sample client for Julius module mode in Perl.

    [Grammar construction tools]
    mkdfa.pl	      grammar compiler
    accept_check.exe  grammar accept check tool
    generate.exe      randam sentence generator for grammar
    generate-ngram.exe random sentence fenerator for N-gram
    yomi2voca.pl      convert Japanese Hiragana into phonemes
    dfa_minimize.exe  minimize DFA states
    dfa_determinize.exe determinize DFA states

    [Result scoring tools]
    scoring/	    Recognition result evaluation scripts


Documents
=================

    00readme.txt	 About this package
    00readme-julius.txt	 Julius readme
    LICENSE.txt		 Terms and conditions to use
    Release.txt	         Release notes and detailed changelog.
    Sample.jconf         Sample runtime config file for Julius.
    manuals/             Online manuals

You can get more documents, related information, and developer's forum
on the Julius Web page:

	 http://julius.sourceforge.jp/en/
	 http://julius.sourceforge.jp/forum/


JuliusLib
==========

From rev.4.0, the core engine part is modularized into a library
called "JuliusLib".  the header files are located in "include",
and pre-compiled static libraries are located in "lib".

Directory "julius-simple" contains a sample program to compile with
JuliusLib.  It is a simplified version of Julius to start recognition
according to the given command argument as same as Julius, and output
result to stdout.  It can be compiled by the following commands 
on cygwin or mingw environment.

      % cd julius-simple
      % make


Sample Plugins
===============

The "plugin-sample" directory contains sample codes for developing a
plugin for Julius.  The content is the same as the ones included in
the original source archive.  You can compile them by "make" under the
directory.  For further information, see the "00readme.txt" in the
directory and comments on the source codes.


Have a model?
===============

Julius needs both language model and acoustic model to run a 
speech recognizer.  Please consult the web page for availability.
