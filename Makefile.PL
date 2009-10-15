use inc::Module::Install;

name     'uni-perl';
all_from 'lib/uni/perl.pm';
version   my $v = '0.03';
author   'Mons Anderson <mons@cpan.org>';
license  'perl';

build_requires 'lib::abs';
build_requires 'Test::More';
build_requires 'Test::NoWarnings';

feature Charsets => [
	Encode => '2.37', # Use latest version, since we're modern
];
feature Dumper => [
	'Data::Dumper' => '2.1'
];
#requires 'Encode';

auto_install;

provides 'uni::perl' => {
	version => $v,
	file    => 'lib/uni/perl.pm',
};

WriteAll;

