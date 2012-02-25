package Template_Basic;
use strict;
use warnings;
use lib 'lib';
use Test::More;
use Test::Mojo;

	use Test::More tests => 4;
    
    {
        
        my $app = Test::App->new;
        $app->plugin(tusu => {document_root => $app->home->rel_dir('../public_html')});
        my $r = Tusu->new($app);
        $r->register($app, {document_root => $app->home->rel_dir('../public_html')});
        is(ref $r, 'Tusu');
        my $engine = $r->engine;
        is(ref $engine, 'Text::PSTemplate');
        is(ref $engine->get_plugin('Tusu::ComponentBase'), 'Tusu::ComponentBase');
        is(ref $engine->get_plugin('Tusu::Component::Mojolicious'), 'Tusu::Component::Mojolicious');
        my $a_plug = $engine->get_plugin('Tusu::Component::Mojolicious');
    }

package Test::App;
use Mojolicious::Lite;

__END__
