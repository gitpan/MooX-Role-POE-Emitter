#!/usr/bin/env perl
use Module::Build;
use strict; use warnings;

my $build = Module::Build->new(
  module_name => 'MooX::Role::POE::Emitter',
  license     => 'perl',

  dist_abstract => 'Pluggable POE event emitter role for cows',
  dist_author   => 'Jon Portnoy <avenj@cobaltirc.org>',

  recursive_test_files => 1,
  create_readme        => 1,
  create_makefile_pl   => 'small',

  configure_requires => {
    'Module::Build' => '0.40',
  },

  build_requires => {
    'Test::More'      => 0,
    'Test::Exception' => 0,
  },

  requires => {
    'perl'     => '5.10.1',

    'Carp'          => 0,
    'Exporter'      => 0,
    'Scalar::Util'  => 0,

    'strictures'                   => 1,

    'Moo'                          => 1,
    'MooX::Role::Pluggable'        => 0,
    'MooX::Types::MooseLike::Base' => '0.15',

    'namespace::clean'             => '0.23',

    'POE'                          => 0,

    'Try::Tiny'                    => 0,
  },

  meta_merge => {
    resources => {
      repository => 'http://github.com/avenj/moox-role-poe-emitter.git',
    },
  },
);

$build->create_build_script;

__END__
Snacks.
