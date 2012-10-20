use Test::More tests => 13;
use strict; use warnings FATAL => 'all';

use POE;

{
  package
   MyEmitter;

  use strict; use warnings FATAL => 'all';

  use POE;
  use Test::More;

  use MooX::Role::Pluggable::Constants;

  use Moo;

  with 'MooX::Role::POE::Emitter';

  sub BUILD {
    my ($self) = @_;

    $self->set_alias( 'SimpleEmitter' );

    $self->set_object_states(
      [
        $self => [ qw/
          emitter_started
          emitter_stopped
          shutdown
          emitted_stuff
          timed
          timed_fail
        / ],
      ],
    );

    $self->_start_emitter;

    $self->yield('subscribe', 'stuff');
  }

  sub emitter_started {
    pass("Emitter started");
  }

  sub emitter_stopped {
    pass("Emitter stopped");
  }

  sub shutdown {
    my ($kernel, $self) = @_[KERNEL, OBJECT];

    pass("shutdown called");

    $self->call( 'shutdown_emitter' );
  }

  sub emitted_stuff {
    my ($kernel, $self, $arg) = @_[KERNEL, OBJECT, ARG0];
    cmp_ok($arg, 'eq', 'test', 'emitted_stuff has correct argument' );
  }

  sub P_things {
    my ($self, $emitter, $first) = @_;
    isa_ok( $emitter, 'MyEmitter' );
    ok( $emitter->does('MooX::Role::Pluggable'), 'Emitter is Pluggable' );
    is( $$first, 1, "P_things had expected args" );
  }


  sub timed {
    pass("timed event fired");
  }

  sub timed_fail {
    fail("timer should have been deleted");
  }

}

POE::Session->create(
  package_states => [
    main => [ qw/

      _start

      emitted_registered

      emitted_test_emit
    / ],
  ],
);

$poe_kernel->run;

sub _start {
  my $emitter = MyEmitter->new;
  my $sess_id;
  ok( $sess_id = $emitter->session_id, 'session_id()' );
  $poe_kernel->post( $sess_id, 'subscribe' );
  ## Test process()
  $emitter->process( 'things', 1 );
  ## Test emit()
  $emitter->emit( 'test_emit', 1 );
  $emitter->emit( 'stuff', 'test' );

  my $alarm_id = $emitter->timer( 0, 'timed' );

  my $todel = $emitter->timer( 1, 'timed_fail' );
  $emitter->timer_del($todel);
}

sub emitted_registered {
  ## Test 'registered' ev
  pass("listener got emitted_registered");
  isa_ok( $_[ARG0], 'MyEmitter' );
}

sub emitted_test_emit {
  ## emit() received
  is( $_[ARG0], 1, 'emitted_test()' );
  $poe_kernel->post( $_[SENDER], 'shutdown' );
}
