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

use Test::More tests => 6;

    my $tusu = plugin TusuRenderer => {
        components => {
            'SomeComponent' => undef,
        },
        document_root => 't/public_html',
    };
    
    my $r = app->routes;
    $r->route('/07/some_component/index2.html')->to(cb => sub {
        $tusu->bootstrap($_[0], 'SomeComponent', 'get');
    });
    
    my $t = Test::Mojo->new;
    $t->get_ok('/')->status_is(200)->content_is('default');
    $t->get_ok('/07/some_component/index2.html')->status_is(200)->content_is('index2');

    $ENV{MOJO_MODE} = $backup;

package SomeComponent;
use strict;
use warnings;
use base 'Tusu::ComponentBase';

    sub get {
        
        my ($self) = @_;
        $self->controller->render(handler => 'tusu', template => '07/some_component/index2.html');
    }

__END__
