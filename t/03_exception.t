use Test::More tests => 8;
use Test::Exception;
use strict; use warnings FATAL => 'all';

{
  package
    MyEmitter;
  use strict; use warnings FATAL => 'all';
  use Moo;
  with 'MooX::Role::POE::Emitter';
}

dies_ok( sub { MyEmitter->new(
    object_states => '',
  ) }, 'empty string object_states dies'
);

my $emitter = MyEmitter->new;

dies_ok( sub { $emitter->set_object_states(
    [ $emitter => [ $_ ] ]
  ) }, "disallowed state $_ dies"
) for qw/
  _start
  _stop
  _default
  subscribe
  unsubscribe
/;

dies_ok( sub { $emitter->timer }, 'empty timer() call dies' );
dies_ok( sub { $emitter->timer_del }, 'empty timer_del() call dies' );
