package MooX::Role::POE::Emitter::RegisteredSession;
$MooX::Role::POE::Emitter::RegisteredSession::VERSION = '1.001001';
use Moo;

has id       => ( is => 'rw', required => 1 );
has refcount => ( is => 'rw', required => 1 );

1;

=pod

=for Pod::Coverage id refcount

=cut
