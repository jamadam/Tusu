use strict;
use warnings;
use Test::Memory::Cycle;
use Test::More;
use Tusu;

use Test::More tests => 1;

my $app = SomeApp->new;
memory_cycle_ok( $app );


package SomeApp;
use strict;
use warnings;
use base 'Mojolicious';
use Tusu;

sub startup {
    my $self = shift;
    my $tusu = $self->plugin(TusuRenderer => {});
}

__END__