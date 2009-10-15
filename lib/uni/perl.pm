package uni::perl;

#use strict;
#use warnings;
use 5.010;
BEGIN {
	${^WARNING_BITS} ^= ${^WARNING_BITS} ^ "\xfc\x3f\xf3\x00\x0f\xf3\xcf\xc0\xf3\xfc\x33\x03";
	$^H |= 0x00000602;
}
m{
use strict;
use warnings;
}x;
use mro ();

=head1 NAME

uni::perl - all modern features + unicode support in one pragma

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

There is most commonly used pragmas, such as L<strict>, L<feature>, L<warnings>, L<utf8>, L<open>, L<mro>. Also almost every modern program uses Encode and Carp

    use uni::perl;

    # is the same as

    use strict;
    use feature qw(say state switch);
    no warnings;
    use warnings qw(FATAL closed threads internal debugging pack substr malloc
                    unopened portable prototype inplace io pipe unpack regexp
                    deprecated exiting glob digit printf utf8 layer
                    reserved parenthesis taint closure semicolon);
    no warnings qw(exec newline);
    use utf8;
    use open (:utf8 :std);
    use mro 'c3';

=cut

# paste this into perl to find bitmask

# no warnings;
# use warnings qw(FATAL closed threads internal debugging pack substr malloc unopened portable prototype
#                 inplace io pipe unpack regexp deprecated exiting glob digit printf
#                 utf8 layer reserved parenthesis taint closure semicolon);
# no warnings qw(exec newline);
# BEGIN { warn join "", map "\\x$_", unpack "(H2)*", ${^WARNING_BITS}; exit 0 };

BEGIN {
	for my $sub (qw(carp croak confess)) {
		no strict 'refs';
		*$sub = sub {
			my $caller = caller;
			local *__ANON__ = $caller .'::'. $sub;
			require Carp;
			*{ $caller.'::'.$sub } = \&{ 'Carp::'.$sub };
			goto &{ 'Carp::'.$sub };
		};
	}
}

sub import {
	my $me = shift;
	my $caller = caller;
	${^WARNING_BITS} ^= ${^WARNING_BITS} ^ "\xfc\x3f\xf3\x00\x0f\xf3\xcf\xc0\xf3\xfc\x33\x03";
	
	$^H |=
		  0x00000602 # strict
		| 0x00800000 # utf8
	;

	# use feature
	$^H{feature_switch} =
	$^H{feature_say}    =
	$^H{feature_state}  = 1;

	# use mro 'c3';
	mro::set_mro($caller, 'c3');
	
	#use open (:utf8 :std);
	${^OPEN} = ":utf8\0:utf8";
	binmode(STDIN,   ":utf8");
	binmode(STDOUT,  ":utf8");
	binmode(STDERR,  ":utf8");
	
	for my $sub (qw(carp croak confess)) {
		no strict 'refs';
		*{ $caller .'::'. $sub } = \&$sub;
	}
	while (@_) {
		my $feature = shift;
		if ($feature =~ s/^://) {
			my $package = $me. '::'. $feature;
			eval "require $package; 1" or croak( "$@" );
			$package->load( $caller );
		}
	}
}

=head1 AUTHOR

Mons Anderson, C<< <mons at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-uni-perl at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=uni-perl>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mons Anderson, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of uni::perl
