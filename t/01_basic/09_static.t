package Template_Basic;
use strict;
use warnings;
use lib 'lib';
use Test::More;
use Test::Mojo;

    my $backup = $ENV{MOJO_MODE} || '';

	use Test::More tests => 24;
    
    {
        $ENV{MOJO_MODE} = 'production';
        my $t = Test::Mojo->new('SomeApp');
        $t->get_ok('/09/img/a.gif')
			->status_is(200)
			->header_is('Content-Type', 'image/gif')
			->content_like(qr/GIF89a/);
        $t->get_ok('/09/img/not_found.gif')
			->status_is(404)
			->text_like('title', qr{Page not found}i);
    }
    
    {
        $ENV{MOJO_MODE} = 'production';
        my $t = Test::Mojo->new('SomeApp2');
        $t->get_ok('/09/img/a.gif')
			->status_is(200)
			->header_is('Content-Type', 'image/gif')
			->content_like(qr/GIF89a/);
        $t->get_ok('/09/img/')
			->status_is(200)
			->header_is('Content-Type', 'image/gif')
			->content_like(qr/GIF89a/);
    }
    
    {
        $ENV{MOJO_MODE} = 'production';
        my $t = Test::Mojo->new('SomeApp2');
        $t->get_ok('/mojolicious-pinstripe.gif')
			->status_is(200)
			->header_is('Content-Type', 'image/gif');
        $t->get_ok('/mojolicious-noraptor.png')
			->status_is(200)
			->header_is('Content-Type', 'image/png');
        $t->get_ok('/js/lang-proto.js')
			->status_is(200)
			->header_is('Content-Type', 'application/x-javascript');
    }
    
	$ENV{MOJO_MODE} = $backup;

package SomeApp;
use strict;
use warnings;
use base 'Mojolicious';

sub startup {
    my $self = shift;
    my $tusu = $self->plugin(TusuRenderer => {
		document_root => $self->home->rel_dir('../public_html')
	});
}

package SomeApp2;
use strict;
use warnings;
use base 'Mojolicious';

sub startup {
    my $self = shift;
    my $tusu = $self->plugin(TusuRenderer => {
		document_root => $self->home->rel_dir('../public_html'),
		directory_index => ['a.gif'],
	});
}

__END__
