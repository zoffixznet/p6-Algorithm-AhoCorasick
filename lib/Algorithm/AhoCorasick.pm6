use v6;
use Algorithm::AhoCorasick::Node;
unit class Algorithm::AhoCorasick;

has $!root;
has $.keywords is required;

method !build-automata() {
    $!root = Algorithm::AhoCorasick::Node.new();
    for @$!keywords -> $keyword {
    	my $current-node = $!root;
    	loop (my $i = 0; $i < $keyword.chars; $i++) {
    	    my $edge-character = $keyword.substr($i,1);
    	    if not ($current-node.transitions{$edge-character}:exists) {
    		$current-node.transitions{$edge-character} = Algorithm::AhoCorasick::Node.new();
    	    }
    	    $current-node = $current-node.transitions{$edge-character};
    	}
    	$current-node.matched-string = set($keyword);
    }
    my @queue;
    @queue.push: $!root;
    while (@queue.elems > 0) {
	my $current-node = @queue.shift;
	for $current-node.transitions.keys -> $edge-character {
	    my $next-node = $current-node.transitions{$edge-character};
	    @queue.push($next-node);

	    my $r = $current-node.failure;
	    while (defined($r) && not $r.transitions{$edge-character}:exists) {
		$r = $r.failure;
	    }

	    if (not defined($r)) {
		$next-node.failure = $!root;
	    }
	    else {
		$next-node.failure = $r.transitions{$edge-character};
		$next-node.matched-string = $next-node.matched-string (|) $next-node.failure.matched-string;
	    }
	}
    }
    $!root.failure = $!root;
}

method match($text) {
    my Set $matched;
    my $state = $!root;
    loop (my $i = 0; $i < $text.chars; $i++) {
	my $trans = Mu;
	my $edge-character = $text.substr($i,1);
	while (defined($state)) {
	    $trans = $state.transitions{$edge-character};
	    if ($state === $!root || defined($trans)) {
		last;
	    }
	    $state = $state.failure;
	}

	if (defined($trans)) {
	    $state = $trans;
	}
	$matched = $matched (|) $state.matched-string;
    }
    return $matched;
}

submethod BUILD (:$keywords) {
    $!keywords := $keywords;
    self!build-automata();
}

=begin pod

=head1 NAME

Algorithm::AhoCorasick - efficient search for multiple strings

=head1 SYNOPSIS

       use Algorithm::AhoCorasick;
       my $aho-corasick = Algorithm::AhoCorasick.new(keywords => ['corasick','sick','algorithm','happy']);
       my $matched = $aho-corasick.match('aho-corasick was invented in 1975'); # set("corasick","sick")

=head1 DESCRIPTION

Algorithm::AhoCorasick is a implmentation of the Aho-Corasick algorithm (1975).
It constructs a finite state machine from a list of keywords in the offline process.
After the above preparation, it locate elements of a finite set of strings within an input text in the online process.

=head2 CONSTRUCTOR

=item Algorithm::AchoCorasick.new(keywords => item(@keyword-list))

Constructs a new finite state machine from a list of keywords.

=head2 METHODS

=item my $matched = $aho-corasick.match($text)

Returns elements of a finite set of strings within an input text.

=head1 AUTHOR

okaoka <mnfrf593@yahoo.co.jp>

=head1 COPYRIGHT AND LICENSE

Copyright 2016 okaoka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

The algorithm is from Alfred V. Aho and Margaret J. Corasick, Efficient string matching: an aid to bibliographic search, CACM, 18(6):333-340, June 1975.

=end pod
