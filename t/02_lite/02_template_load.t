package Template_Basic;
use strict;
use warnings;
use lib 'lib';

    my $backup;
    BEGIN { $ENV{MOJO_NO_IPV6} = $ENV{MOJO_POLL} = 1 }
    BEGIN { $backup = $ENV{MOJO_MODE} || ''; $ENV{MOJO_MODE} = 'development' }

use Test::More;
use Test::Mojo;
use Mojolicious::Lite;
    
use Test::More tests => 9;

    my $tusu = plugin 'tusu' => {document_root => 't/public_html'};
    
    my $t = Test::Mojo->new;
    $t->get_ok('/')
        ->status_is(200)
        ->content_is('default');
    $t->get_ok('/02/')
        ->status_is(200)
        ->content_is('default');
    $t->get_ok('/02/02_02.html')
        ->status_is(200)
        ->content_is('ok02_02');

    $ENV{MOJO_MODE} = $backup;
