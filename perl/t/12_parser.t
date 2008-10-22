use strict;
use warnings;
use blib;
use Test::More tests => 7;

use_ok('Mail::SPF_XS');

my $srv = new Mail::SPF_XS::Server({ debug => 0 });

my %records = (
	'a%%b%%c%'		=> 'a%b%c%',
	'%%'			=> '%',
	'foo'	=> 'foo',
);

for (keys %records) {
	my $exp = $srv->expand($_);
	is($exp, $records{$_}, "Expanded $_");

	my $rec = $srv->compile("v=spf1 macro=$_");

	my $str = $rec->string;
	is($str, "v=spf1 macro=$_", "Stringified the record");

	my $value = $rec->modifier('macro');
	is($value, $records{$_}, "Parsed $_");

#	$rec = $srv->compile("v=spf1 macro=$_ -all");
#	$value = $rec->modifier('macro');
#	is($value, $records{$_}, "Parsed $_ -all");
}
