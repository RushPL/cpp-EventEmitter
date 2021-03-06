#!/usr/bin/perl

my $macro_mode = 0;
$/ = undef;
my $input = <>;
$input =~ s#/\*[^*]*\*+([^/*][^*]*\*+)*/|("(\\.|[^"\\])*"|'(\\.|[^'\\])*'|.[^/"'\\]*)#defined $2 ? $2 : ""#gse;
@lines = split(/\n/, $input);

#print STDERR @lines;

for my $line(@lines) {
	if($line =~ /\/\/\#\/\/$/) {
		print "\n";
		next;
	}

	$line =~ s/__EVENTEMITTER_SANE_HPP/"__EVENTEMITTER_HPP"/exg;
	$line =~ s/(\w+)Example(\w+)/"__EVENTEMITTER_CONCAT(".$1.",__EVENTEMITTER_CONCAT(name, ".$2."))"/exg;	
	$line =~ s/Example(\w+)/"__EVENTEMITTER_CONCAT(frontname,".$1.")"/exg;
	$line =~ s/(\w+)Example/"__EVENTEMITTER_CONCAT(".$1.",name)"/exg;

	$line =~ s/EventEmitter::DeferredBaseExample::runDeferredExample/EventEmitter::DeferredBase::runDeferred/g;
	$line =~ s/EventEmitter::DeferredBaseExample/EventEmitter::DeferredBase/g;

	if($line =~ /^(.*)\/\/_\/\/$/) {
		$macro_mode = 0;
		print $1 . " \n";
		next;
	}

	if($line =~ /^(.*)\/\/\^\/\/$/) {
		print $1 . " \\\n";
		$macro_mode = 1;
		next;
	}
	elsif($macro_mode) {
		$line =~ s/(\/\/.*$)/ /g;
		print $line . " \\\n";
		next;
	}

	print $line . "\n";
}