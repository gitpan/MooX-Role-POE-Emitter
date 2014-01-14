package MooX::Role::POE::Emitter::RegisteredSession;
{
  $MooX::Role::POE::Emitter::RegisteredSession::VERSION = '0.120005';
}
use Moo;
has id       => ( is => 'rw', required => 1 );
has refcount => ( is => 'rw', required => 1 );

1;

=pod

=for Pod::Coverage id refcount

=cut
