#!/usr/bin/env perl

use Test::More tests => 9;
use Test::NoWarnings;
use lib::abs '../lib';
use uni::perl;

my $char = "а";
ok(utf8::is_utf8($char), 'utf8 works');
eval q{ $zzz; };
like($@, qr/Global symbol "\$zzz" requires explicit package/, 'strict works');
{
	my $warn;
	local $SIG{__WARN__} = sub { $warn = 1; };
	sprintf "%s",undef;
	ok !$warn, 'warnings undef ok';
	eval { print SOMEFILE ''; };
	like $@, qr/unopened filehandle/, 'warnings fatal ok';
}

eval q{ say "# say() should be available"; };
is( $@, '', 'say() should be available' );

eval q{ state $x };
is( $@, '', 'state should be available' );

eval q{ given($_) { default {} } };
is( $@, '', 'switch should be available' );

eval<<'END_CLASSES';
package A; $A::VERSION = 1;
package B; @B::ISA = 'A';
package C; @C::ISA = 'A';
package D;
use uni::perl;
@D::ISA = qw( B C );
END_CLASSES
;
package main;

is_deeply( mro::get_linear_isa( 'D' ), [qw( D B C A )], 'mro should use C3' );
