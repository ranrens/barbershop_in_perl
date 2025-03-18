package BarbershopMojolicious::Service::DB;

use Mojo::Base -base;
use warnings;
use strict;

use DBI;
use DBIx::Connector;
use Config::Tiny;
use FindBin;

sub _load_config {
    my $self = shift;
    my $config_file = "$FindBin::Bin/../lib/BarbershopMojolicious/Config/DB.ini";
    my $config = Config::Tiny->read($config_file);

    return $config->{db};
}

sub get_db_name {
    my $self = shift;
    my $db_config = $self->_load_config;

    return $db_config->{database}
}

sub get_db_handler {
    my $self = shift;
    my $db_config = $self->_load_config;
    my $dsn = "DBI:$db_config->{driver}:database=$db_config->{database}:host=$db_config->{host}:port=$db_config->{port}";
    my $conn = DBIx::Connector->new($dsn,
	                            $db_config->{username},
	                            $db_config->{password},
	                            { RaiseError => 1, AutoCommit => 1 });
    return $conn;
}

1;
