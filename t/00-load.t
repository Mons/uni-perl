#!/usr/bin/env perl

use Test::More tests => 1;
use lib::abs '../lib';

BEGIN {
	use_ok( 'uni::perl' );
}

diag( "Testing uni::perl $uni::perl::VERSION, Perl $], $^X" );
