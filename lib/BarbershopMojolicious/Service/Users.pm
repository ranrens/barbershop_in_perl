package BarbershopMojolicious::Service::Users;

use Mojo::Base -base;
use BarbershopMojolicious::DAO::Users;

sub list_users {
    my $self = shift;
    my @users = BarbershopMojolicious::DAO::Users->new->list_users;
    return @users;
}

sub list_user_by_id {
    my $self = shift;
    my ($id) = @_;
    my $user = BarbershopMojolicious::DAO::Users->new->list_user_by_id($id);
    if (!defined $user) {
        $user = {};
    }
    return $user;
}

sub list_users_by_name {
    my $self = shift;
    my ($name) = @_;
    my @users = BarbershopMojolicious::DAO::Users->new->list_users_by_name($name);
    return @users;
}

sub insert_user {
    my $self = shift;
    my ($request) = @_;
    my $name = $request->{name};
    my $phone = $request->{phone};
    my $balance = $request->{balance};
    my $user = BarbershopMojolicious::DAO::Users->new->insert_user($name, $phone, $balance);

    my $ret->{ret} = $user;
    return $ret;
}

sub delete_user_by_id {
    my $self = shift;
    my ($id) = @_;
    my $user = BarbershopMojolicious::DAO::Users->new->delete_user_by_id($id);

    my $ret->{ret} = $user;
    return $ret;
}

sub update_user_by_id {
    my $self = shift;
    my ($id, $request) = @_;
    my ($name, $phone, $balance, $is_active, $ret);
    my $_ret = 0;

    my $user = BarbershopMojolicious::DAO::Users->new->list_user_by_id($id);
    if (defined $user) {
        if (defined $request->{name}) {
            $name = $request->{name};
        } else {
            $name = $user->{name};
        }
        if (defined $request->{phone}) {
            $phone = $request->{phone};
        } else {
            $phone = $user->{phone};
        }
        if (defined $request->{balance}) {
            $balance = $request->{balance};
        } else {
            $balance = $user->{balance};   
        }
        if (defined $request->{is_active}) {
            $is_active = $request->{is_active};
        } else {
            $is_active = $user->{is_active};
        }
	$_ret = BarbershopMojolicious::DAO::Users->new->update_user_by_id($id, $name, $phone, $balance, $is_active);
    }

    $ret->{ret} = $_ret;
    return $ret;
}

1;
