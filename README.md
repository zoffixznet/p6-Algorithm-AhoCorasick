NAME
====

Algorithm::AhoCorasick - efficient search for multiple strings

SYNOPSIS
========

    use Algorithm::AhoCorasick;
    my $aho-corasick = Algorithm::AhoCorasick.new(keywords => ['corasick','sick','algorithm','happy']);
    my $matched = $aho-corasick.match('aho-corasick was invented in 1975'); # set("corasick","sick")

DESCRIPTION
===========

Algorithm::AhoCorasick is a implmentation of the Aho-Corasick algorithm (1975). It constructs a finite state machine from a list of keywords in the offline process. After the above preparation, it locate elements of a finite set of strings within an input text in the online process.

CONSTRUCTOR
-----------

  * Algorithm::AchoCorasick.new(keywords => item(@keyword-list))

Constructs a new finite state machine from a list of keywords.

METHODS
-------

  * my $matched = $aho-corasick.match($text)

Returns elements of a finite set of strings within an input text.

AUTHOR
======

okaoka <mnfrf593@yahoo.co.jp>

COPYRIGHT AND LICENSE
=====================

Copyright 2016 okaoka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

The algorithm is from Alfred V. Aho and Margaret J. Corasick, Efficient string matching: an aid to bibliographic search, CACM, 18(6):333-340, June 1975.
