package Template_Basic;
use strict;
use warnings;
use lib 'lib';
use Test::More;
use Test::Mojo;
use Tusu;
    
use Test::More tests => 13;

    BEGIN {
        chmod(0755, 't/00_partial/f/t01/permission_ok');
        chmod(0744, 't/00_partial/f/t01/permission_ng');
        chmod(0755, 't/00_partial/f/t01/permission_ok/permission_ok.html');
        chmod(0700, 't/00_partial/f/t01/permission_ok/permission_ng.html');
        chmod(0755, 't/00_partial/f/t01/permission_ng/permission_ok.html');
        chmod(0700, 't/00_partial/f/t01/permission_ng/permission_ng.html');
    }

    my $backup = $ENV{MOJO_MODE} || '';

	if ($^O eq "MSWin32") {
		__PACKAGE__->SKIP_ALL("Test irrelevant on MSWin32");
	}
    
    {
        is(Tusu::_permission_ok('t/00_partial/f/t01/permission_ok/permission_ok.html'), 1);
        is(Tusu::_permission_ok('t/00_partial/f/t01/permission_ok/permission_ng.html'), 0);
        is(Tusu::_permission_ok('t/00_partial/f/t01/permission_ng/permission_ok.html'), 0);
        is(Tusu::_permission_ok('t/00_partial/f/t01/permission_ng/permission_ng.html'), 0);
    }
    
    {
        is(Tusu::_fill_filename('t/00_partial/f/t02', ['index.html']), 't/00_partial/f/t02/index.html');
        is(Tusu::_fill_filename('t/00_partial/f/t02/', ['index.html']), 't/00_partial/f/t02/index.html');
        is(Tusu::_fill_filename('t/00_partial/f/t02/a', ['index.html']), 't/00_partial/f/t02/a/index.html');
        is(Tusu::_fill_filename('t/00_partial/f/t02/a/', ['index.html']), 't/00_partial/f/t02/a/index.html');
        is(Tusu::_fill_filename('t/00_partial/f/t02/b/', ['index.html']), undef);
        is(Tusu::_fill_filename('t/00_partial/f/t02', ['index2.html']), undef);
        is(Tusu::_fill_filename('t/00_partial/f/t02/', ['index2.html']), undef);
        is(Tusu::_fill_filename('t/00_partial/f/t02/a', ['index2.html']), undef);
        is(Tusu::_fill_filename('t/00_partial/f/t02/a/', ['index2.html']), undef);
    }

__END__
