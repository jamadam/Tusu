package Mojolicious::Plugin::Tusu;
use strict;
use warnings;
use Mojo::Base 'Tusu';
    
    sub register {
        return shift->SUPER::register(@_);
    }

1;

__END__

=head1 NAME

Mojolicious::Plugin::Tusu - Alias of Tusu class

=head1 DESCRIPTION

This is a sub class of Tusu with no extention. This class is just for resolving
namespace issue of Mojolicious plugin.

=head1 SEE ALSO

L<Mojolicious>, L<Tusu>

=head1 AUTHOR

Sugama Keita, E<lt>sugama@jamadam.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sugama Keita.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
