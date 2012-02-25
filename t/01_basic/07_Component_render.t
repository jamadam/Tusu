use strict;
use warnings;
use lib 'lib';
use Test::More;
use Test::Mojo;

    my $backup = $ENV{MOJO_MODE} || '';
	
	use Test::More tests => 9;
	
	{
		package IniTest;
		use strict;
		use warnings;
		use base 'Tusu::ComponentBase';
		__PACKAGE__->attr('foo');
	}
	{
		my $tpl = Text::PSTemplate->new;
		my $component = IniTest->new($tpl);
		$component->foo('b');
		is($component->foo, 'b', 'set attr');
	}
	
	{
		package SomeComponent;
		use strict;
		use warnings;
		use base 'Tusu::ComponentBase';
			
			__PACKAGE__->attr('key1');
			__PACKAGE__->attr('app');
			
			my $inited;
			
			sub init {
				my ($self, $app) = @_;
				$self->key1('value1');
				$self->app($app);
				return $self;
			}
		
			sub get {
				my ($self) = @_;
				$self->controller->render(handler => 'tusu', template => '07/some_component/index2.html');
			}
	}
	{
		my $app = SomeApp2->new;
	}
		{
			package SomeApp2;
			use strict;
			use warnings;
			use base 'Mojolicious';
			use Test::More;
				
				sub startup {
					my $self = shift;
					my $tusu = $self->plugin(tusu => {
						components => {
							'SomeComponent' => undef,
						},
						document_root => $self->home->rel_dir('../public_html'),
					});
					my $SomeComponent = $tusu->get_component('SomeComponent');
					is($SomeComponent->key1, 'value1');
					is($SomeComponent->app, $self);
				}
		}
    
    {
        $ENV{MOJO_MODE} = 'production';
        my $t = Test::Mojo->new('SomeApp');
        $t->get_ok('/')
			->status_is(200)
			->content_is('default');
        $t->get_ok('/07/some_component/index2.html')
			->status_is(200)
			->content_is('index2');
    }
		{
			package SomeApp;
			use strict;
			use warnings;
			use base 'Mojolicious';
				
				sub startup {
					my $self = shift;
				
					my $tusu = $self->plugin(tusu => {
						components => {
							'SomeComponent' => undef,
						},
						document_root => 't/public_html'
					});
					
					my $r = $self->routes;
					$r->route('/07/some_component/index2.html')->to(cb => sub {
						$tusu->bootstrap($_[0], 'SomeComponent', 'get');
					});
				}
		}
    
	$ENV{MOJO_MODE} = $backup;
    
__END__
