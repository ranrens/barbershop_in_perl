package BarbershopMojolicious::Controller::Users;

use Mojo::Base 'Mojolicious::Controller';
use BarbershopMojolicious::Service::Users;

sub list_users {
    my $self = shift;
    my @users = BarbershopMojolicious::Service::Users->new->list_users;
    
    $self->render(json => \@users);
}

sub list_user_by_id {
    my $self = shift;
    my $id = $self->stash('id');
    my $user = BarbershopMojolicious::Service::Users->new->list_user_by_id($id);

    $self->render(json => $user);
}

sub list_users_by_name {
    my $self = shift;
    my $name = $self->stash('name');
    my @users = BarbershopMojolicious::Service::Users->new->list_users_by_name($name);

    $self->render(json => \@users);
}

sub insert_user {
    my $self = shift;
    my $request = $self->req->json;
    my $user = BarbershopMojolicious::Service::Users->new->insert_user($request);

    $self->render(json => $user);
}

sub delete_user_by_id {
    my $self = shift;
    my $id = $self->stash('id');
    my $user = BarbershopMojolicious::Service::Users->new->delete_user_by_id($id);

    $self->render(json => $user);
}

sub update_user_by_id {
    my $self = shift;
    my $id = $self->stash('id');
    my $request = $self->req->json;
    my $user = BarbershopMojolicious::Service::Users->new->update_user_by_id($id, $request);

    $self->render(json => $user);
}

1;
