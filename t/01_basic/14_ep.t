package Template_Basic;
use strict;
use warnings;
use lib 'lib';
use Test::More;
use Test::Mojo;

    my $backup = $ENV{MOJO_MODE} || '';
    
	use Test::More tests => 3;
    
    {
        $ENV{MOJO_MODE} = 'production';
        my $t = Test::Mojo->new('SomeApp');
        $t->get_ok('/index.html')
			->status_is(200)
			->content_is("/14\n");
    }
    
	$ENV{MOJO_MODE} = $backup;

package SomeApp;
use strict;
use warnings;
use base 'Mojolicious';

sub startup {
    my $self = shift;
	$self->plugin(TusuEPRenderer => {
		document_root 	=> 't/public_html/14',
		renderer		=> 'tusu_ep',
	});
}

__END__
