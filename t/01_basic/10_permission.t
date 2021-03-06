package Template_Basic;
use strict;
use warnings;
use lib 'lib';
use Test::More;
use Test::Mojo;
    
    BEGIN {
        chmod(0755, 't/public_html/10/permission_ok');
        chmod(0744, 't/public_html/10/permission_ng');
        chmod(0755, 't/public_html/10/permission_ok/permission_ok.html');
        chmod(0700, 't/public_html/10/permission_ok/permission_ng.html');
        chmod(0755, 't/public_html/10/permission_ng/permission_ok.html');
        chmod(0700, 't/public_html/10/permission_ng/permission_ng.html');
    }
    
    my $backup = $ENV{MOJO_MODE} || '';

	use Test::More tests => 11;
	
	if ($^O eq "MSWin32") {
		__PACKAGE__->SKIP_ALL("Test irrelevant on MSWin32");
	}

    {
		
        $ENV{MOJO_MODE} = 'production';
        my $t = Test::Mojo->new('SomeApp');
        $t->get_ok('/10/permission_ok/permission_ok.html')->status_is(200);
        $t->get_ok('/10/permission_ok/permission_ng.html')->status_is(403);
        $t->get_ok('/10/permission_ng/permission_ok.html')->status_is(403);
        $t->get_ok('/10/permission_ng/permission_ng.html')->status_is(403);
    }
    
    {
		
        $ENV{MOJO_MODE} = 'production';
        my $t = Test::Mojo->new('ErrorDocument');
        $t->get_ok('/10/permission_ng/permission_ng.html')
			->status_is(403)
			->content_is('403');
    }
    
	$ENV{MOJO_MODE} = $backup;

package SomeApp;
use strict;
use warnings;
use base 'Mojolicious';

sub startup {
    my $self = shift;
    $self->plugin(TusuRenderer => {
		document_root => 't/public_html'
	});
}

package ErrorDocument;
use strict;
use warnings;
use base 'Mojolicious';

sub startup {
    my $self = shift;
    $self->plugin(TusuRenderer => {
		document_root => 't/public_html',
		error_document => {
			404 => '/08/err/404.html',
			403 => '/08/err/403.html',
			500 => '/08/err/500.html',
		}
	});
}

__END__
