package Template_Basic;
use strict;
use warnings;
use lib 'lib';
use Test::More;
use Test::Mojo;
use utf8;
use Encode;
use Encode::Guess;

    my $backup = $ENV{MOJO_MODE} || '';
    
	use Test::More tests => 6;
	
    {
        $ENV{MOJO_MODE} = 'production';
        my $t = Test::Mojo->new('TestCase1');
        $t->get_ok('/11/')
			->header_is('Content-Type', 'text/html;charset=UTF-8')
			->content_is('シフトJISのファイル');
        $t->get_ok('/11/utf8.html')
			->header_is('Content-Type', 'text/html;charset=UTF-8')
			->content_is('utf8のファイル漢字あいうえおかきくけこ');
    }
		{
			package TestCase1;
			use strict;
			use warnings;
			use base 'Mojolicious';
			
			sub startup {
				my $self = shift;
				$self->plugin(TusuRenderer => {
					document_root => 't/public_html',
					encoding => ['Shift-JIS', 'utf8'],
				});
			}
		}
	
	$ENV{MOJO_MODE} = $backup;

__END__
