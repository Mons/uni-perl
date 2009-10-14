#!/usr/bin/env perl

use Test::More tests => 6;
use Test::NoWarnings;
use lib::abs '../lib';
use uni::perl ':ru';

ok defined &cp1251::encode, 'have encode';
ok defined &cp1251::decode, 'have decode';

my $tr = koi8r::decode(cp1251::encode("это тест"));
is ($tr,"ЩРН РЕЯР", 'translate ok');

my $file = do {open my $f, "<", lib::abs::path('data/file'); <$f> };
$tr = koi8r::decode(cp1251::encode($file));
is ($tr,"ЩРН РЕЯР", 'file open ok');

my $file = do {open my $f, "<:raw", lib::abs::path('data/file'); <$f> };
ok !utf8::is_utf8($file), ':raw works';
