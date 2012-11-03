## Test configurable type prefixes.
use Test::More tests => 6;
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
          shutdown
        / ],
      ],
    );

    $self->set_pluggable_type_prefixes(
      {
        PROCESS => 'Proc',
        NOTIFY  => 'Notify',
      },
    );

    $self->_start_emitter;
  }

  sub shutdown {
    my ($kernel, $self) = @_[KERNEL, OBJECT];

    $self->call( 'shutdown_emitter' );
  }

  sub Proc_things {
    my ($self, $emitter, $first) = @_;
    pass("Got Proc_things in Emitter")
  }

}

{
  package
    MyPlugin;
  use strict; use warnings FATAL => 'all';
  use Test::More;
  use MooX::Role::Pluggable::Constants;

  sub new { bless [], shift }

  sub Emitter_register {
    my ($self, $core) = splice @_, 0, 2;
    $core->subscribe( $self, 'NOTIFY', 'all' );
    EAT_NONE
  }

  sub Emitter_unregister {
    EAT_NONE
  }

  sub Notify_test_event {
    pass("Plugin got Notify_test_event");
    EAT_NONE
  }

  sub Proc_things {
    my ($self, $core) = splice @_, 0, 2;
    pass("Plugin got Proc_things");
    EAT_NONE
  }
}


POE::Session->create(
  package_states => [
    main => [ qw/
      _start
      emitted_registered
      emitted_test_event
    / ],
  ],
);

$poe_kernel->run;

sub _start {
  my $emitter = MyEmitter->new;
  $poe_kernel->post( $emitter->session_id, 'subscribe' );

  $emitter->plugin_add( 'MyPlugin', MyPlugin->new );

  ## Test process()
  $emitter->process( 'things', 1 );
  ## Test emit()
  $emitter->emit( 'test_event', 1 );

  $emitter->yield('shutdown');
}

sub emitted_registered {
  ## Test 'registered' ev
  pass("listener got emitted_registered");
}

sub emitted_test_event {
  ## emit() received
  pass("Got emitted_test_event");
}
