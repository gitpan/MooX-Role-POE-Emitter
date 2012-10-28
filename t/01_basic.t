use Test::More tests => 30;
use strict; use warnings FATAL => 'all';
require_ok('MooX::Role::Pluggable::Constants');
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

    $self->yield('subscribe', 'stuff' );
  }

  sub emitter_started {
    my ($kernel, $self) = @_[KERNEL, OBJECT];
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
    pass("Got emitted_stuff");
    cmp_ok($arg, 'eq', 'test', 'emitted_stuff has correct argument' );
    $self->yield('subscribe', 'test');
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

{
  package
    MyPlugin;
  use strict; use warnings;
  use Test::More;
  use MooX::Role::Pluggable::Constants;

  sub new { bless [], shift }

  sub Emitter_register {
    my ($self, $core) = splice @_, 0, 2;
    pass("Plugin got Emitter_register");
    isa_ok( $core, 'MyEmitter' );
    $core->subscribe( $self, 'NOTIFY', 'all' );
    $core->subscribe( $self, 'PROCESS', 'all' );
    EAT_NONE
  }

  sub Emitter_unregister {
    pass("Plugin got Emitter_unregister");
    EAT_NONE
  }

  sub P_from_default {
    my ($self, $core) = splice @_, 0, 2;
    pass("Plugin got P_from_default");
    cmp_ok(${ $_[0] }, 'eq', 'test', "P_from_default correct argument" );
  }

  sub N_eatclient {
    pass("Plugin got N_eatclient");
    EAT_CLIENT
  }

  sub N_stuff {
    my ($self, $core) = splice @_, 0, 2;
    my $arg = ${ $_[0] };
    pass("Plugin got N_stuff");
    cmp_ok($arg, 'eq', 'test', 'N_stuff correct argument' );
    EAT_NONE
  }
}


POE::Session->create(
  package_states => [
    main => [ qw/

      _start

      emitted_registered

      emitted_test_emit
      emitted_eatclient
    / ],
  ],
);

$poe_kernel->run;

sub _start {
  my $emitter = MyEmitter->new;
  my $sess_id;
  ok( $sess_id = $emitter->session_id, 'session_id()' );
  $poe_kernel->post( $sess_id, 'subscribe' );

  $emitter->plugin_add( 'MyPlugin', MyPlugin->new );

  ## Test process()
  $emitter->process( 'things', 1 );
  ## Test emit()
  $emitter->emit( 'test_emit', 1 );
  $emitter->emit( 'stuff', 'test' );
  $emitter->emit_now( 'eatclient' );

  my $alarm_id = $emitter->timer( 0, 'timed' );

  $emitter->yield(sub {
      my ($l_k, $l_s) = @_[KERNEL, STATE];
      my ($stuff, $things) = @_[ARG0 .. $#_];

      pass("Got anonymous coderef callback");

      cmp_ok($stuff, 'eq', 'stuff', 'coderef CB arg 1 correct');
      cmp_ok($things, 'eq', 'things', 'coderef CB arg 2 correct');

      ok(ref $l_s eq 'CODE', 'coderef CB received itself');
      isa_ok($l_k, 'POE::Kernel');

      $_[OBJECT]->yield(sub {
          pass("Got secondary coderef cb $_[ARG0]");
          return unless $_[ARG0]++ == 0;
          $_[OBJECT]->yield( $_[STATE], $_[ARG0] )
        }, 0
      );

    }, 'stuff', 'things'
  );

  $poe_kernel->post( $emitter->alias, 'from_default', 'test' );

  my $todel = $emitter->timer( 1, 'timed_fail' );
  $emitter->timer_del($todel);

  $emitter->timer( 0,
    sub { pass("Anon coderef callback in timer") },
  );

  $emitter->yield('shutdown');
}

sub emitted_registered {
  ## Test 'registered' ev
  pass("listener got emitted_registered");
  isa_ok( $_[ARG0], 'MyEmitter' );
}

sub emitted_test_emit {
  ## emit() received
  is( $_[ARG0], 1, 'emitted_test()' );
}

sub emitted_eatclient {
  fail("Should not have received EAT_CLIENT event");
}
