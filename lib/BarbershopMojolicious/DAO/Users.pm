package BarbershopMojolicious::DAO::Users;

use Mojo::Base -base;
use POSIX qw(strftime);
use BarbershopMojolicious::Service::DB;

my $_table = "barbershop.users";

sub list_users {
    my $self = shift;
    my @rows;
    my $db = BarbershopMojolicious::Service::DB->new->get_db_handler;

    $db->run(fixup => sub{
        my $dbh = shift;
	my $sql = $dbh->prepare("SELECT id, name, create_at, update_at, balance FROM " . $_table);
	$sql->execute() or die $DBI::errstr;
	if ($sql) {
            while (my $row = $sql->fetchrow_hashref) {
                push @rows, $row;
            }
        }
        $sql->finish();

        return @rows;
    });
}

sub list_user_by_id {
    my $self = shift;
    my ($id) = @_;
    my $db = BarbershopMojolicious::Service::DB->new->get_db_handler;

    $db->run(fixup => sub {
        my $dbh = shift;
	my $sql = $dbh->prepare("SELECT id, name, phone, create_at, update_at, balance, is_active FROM " . $_table . " WHERE id = (?)");
	$sql->execute($id);
	my $row = $sql->fetchrow_hashref;
        $sql->finish();
	return $row;
    });
}

sub list_users_by_name {
    my $self = shift;
    my ($name) = @_;
    my @rows;
    my $db = BarbershopMojolicious::Service::DB->new->get_db_handler;

    $db->run(fixup => sub{
        my $dbh = shift;
	my $sql = $dbh->prepare("SELECT id, name, phone, create_at, update_at, balance, is_active FROM " . $_table . " WHERE name LIKE (?)");
	$sql->execute("%$name%") or die $DBI::errstr;
	if ($sql) {
            while (my $row = $sql->fetchrow_hashref) {
                push @rows, $row;
            }
        }
	$sql->finish();
	return @rows;
    });
}

sub insert_user {
    my $self = shift;
    my ($name, $phone, $balance) = @_;
    my $ret = 0;
    my $now = strftime "%Y-%m-%d %H:%M:%S", localtime;
    my $db = BarbershopMojolicious::Service::DB->new->get_db_handler;

    $db->run(fixup => sub{
        my $dbh = shift;
	my $sql = $dbh->prepare("INSERT INTO " . $_table . " (name, phone, balance, create_at, update_at, is_active)
                                 VALUES
                                 (?,?,?,?,?,?)");
        $sql->execute($name, $phone, $balance, $now, $now, 1) or die $DBI::errstr;
	if ($sql) {
            $ret = $sql->rows;
        }
        $sql->finish();

        return $ret;
    });
}

sub delete_user_by_id {
    my $self = shift;
    my ($id) = @_;
    my $ret = 0;
    my $db = BarbershopMojolicious::Service::DB->new->get_db_handler;

    $db->run(fixup => sub{
        my $dbh = shift;
        my $sql = $dbh->prepare("DELETE FROM " . $_table . " WHERE id = (?)");
        $sql->execute($id) or die $DBI::errstr;
        if ($sql) {
            $ret = $sql->rows;
        }
        $sql->finish();

        return $ret;
    });
}

sub update_user_by_id {
    my $self = shift;
    my ($id, $name, $phone, $balance, $is_active) = @_;
    my $ret = 0;
    my $now = strftime "%Y-%m-%d %H:%M:%S", localtime;
    my $db = BarbershopMojolicious::Service::DB->new->get_db_handler;

    $db->run(fixup => sub {
        my $dbh = shift;
        my $sql = $dbh->prepare("UPDATE " . $_table . " SET name = ?, phone = ?,
                                update_at = ?,  balance= ?, is_active = ? WHERE id = " . $id);
        $sql->execute($name, $phone, $now, $balance, $is_active) or die $DBI::errstr;
        if ($sql) {
            $ret = $sql->rows;
        }
        $sql->finish();

        return $ret;
    });
}

1;
