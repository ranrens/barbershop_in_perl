package BarbershopMojolicious;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Example#welcome');

  # GET /users/
  $r->get('/users')->to('Users#list_users');

  # GET /user/id/{id}
  $r->get('/users/id/:id')->to('Users#list_user_by_id');

  # GET /users/name/{name}
  $r->get('/users/name/:name')->to('Users#list_users_by_name');

  # POST /users/
  $r->post('/users/')->to('Users#insert_user');

  # DEL /users/id/{id}
  $r->delete('/users/id/:id')->to('Users#delete_user_by_id');

  # PATCH /user/id/{id}
  $r->patch('/users/id/:id')->to('Users#update_user_by_id');
}

1;
