package Template_Basic;
use strict;
use warnings;
use lib 'lib';
use Test::More;
use Test::Mojo;

	use Test::More tests => 1;
    
    {
        my $app = Test::App->new;
        $app->plugin(TusuRenderer => {
            document_root => $app->home->rel_dir('../public_html'),
        });
        my $r = Tusu->new($app);
        $r->register($app, {document_root => $app->home->rel_dir('../public_html')});
        is(ref $r, 'Tusu');
    }

package Test::App;
use Mojolicious::Lite;

__END__
