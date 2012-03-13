package Mojolicious::Plugin::TusuRenderer;
use strict;
use warnings;
use Try::Tiny;
use Text::PSTemplate;
use Mojo::Base 'Tusu';
use Carp;
use Scalar::Util qw(weaken);

    __PACKAGE__->attr('engine');
    
    sub default_args {
        my $class = shift;
        return {
            %{$class->SUPER::default_args(@_)},
            encoding                => 'utf8',
            components              => {},
        }
    }
    
    sub register {
        my ($self, $app, $args) = @_;
        
        $self->SUPER::register($app, $args);
        
        my $engine = Text::PSTemplate->new;
        $engine->set_filter('=', \&Mojo::Util::html_escape);
        $engine->set_filename_trans_coderef(sub {
            $self->filename_trans($app->static->paths->[0], @_);
        });
        
        {
            local $Tusu::APP = $app;
            $engine->plug(
                'Tusu::ComponentBase'            => undef,
                'Tusu::Component::Util'          => '',
                'Tusu::Component::Mojolicious'   => 'Mojolicious',
                %{$args->{components}}
            );
        }
        $self->engine($engine);
        $engine->set_encoding($args->{encoding});
        
        $app->renderer->add_handler(tusu => sub {
            my ($renderer, $c, $output, $options) = @_;
            
            try {
                local $SIG{__DIE__} = undef;
                local $Tusu::CONTROLLER = $c;
                $$output = Text::PSTemplate ->new($self->engine)
                                            ->parse_file('/'. $options->{template});
            } catch {
                my $err = $_ || 'Unknown Error';
                $c->app->log->error(qq(Template error in "$options->{template}": $err));
                $c->render_exception("$err");
                $$output = '';
                return 0;
            };
            return 1;
        });
        
        weaken $self;
        
        return $self;
    }
    
    ### ---
    ### Get component
    ### ---
    sub get_component {
        my ($self, $name) = @_;
        return $self->engine->get_plugin($name);
    }
    
    ### ---
    ### bootstrap for frameworking
    ### ---
    sub bootstrap {
        my ($self, $c, $component, $action, @args) = @_;
        local $Tusu::CONTROLLER = $c;
        return $self->engine->get_plugin($component)->$action(@args);
    }

1;

__END__

=head1 NAME

Tusu::TusuRenderer - Tusu::TusuRenderer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head1 SEE ALSO

L<Text::PSTemplate>, L<Mojolicious::Plugin::Renderer>

=head1 AUTHOR

Sugama Keita, E<lt>sugama@jamadam.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sugama Keita.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
