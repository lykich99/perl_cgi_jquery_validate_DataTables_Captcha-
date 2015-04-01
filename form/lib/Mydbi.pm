#===============================================================================
#
#         FILE: Mydbi.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (Lykashov Yuriy), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 28.03.2015 16:53:57
#     REVISION: ---
#===============================================================================

    use strict;
    use warnings;
    package Mydbi;
    use DBI; 
    use POSIX;
    use Exporter 'import';

    { 
	no warnings 'redefine';
    sub new {
         my $class = shift;
         my $self = {
                 driver     => shift,
                 database   => shift,
                 host       => shift,
                 port       => shift,
                 username   => shift,
                 password   => shift,
                 RaiseError => shift,
                 AutoCommit => shift     
             };
        bless $self, $class;
        return $self;
      }
    }

    {
	no warnings 'redefine';
    sub getConect {
       my($self) = @_;
       my $driver      = $self->{driver};
       my $db          = $self->{database};
       my $h           = $self->{host};
       my $port        = $self->{port};
       my $l           = $self->{username};
       my $p           = $self->{password};
       my $RaiseError  = $self->{RaiseError};
       my $AutoCommit  = $self->{AutoCommit};
       my $dsn = 'dbi:'.$driver.':'.$db.':'.$h.':'.$port; 
       my $dbh = DBI->connect($dsn,"$l","$p",{ RaiseError => $RaiseError, AutoCommit => $AutoCommit, mysql_enable_utf8 => 1 }) or die $DBI::errstr;
          $self->{dbh} = $dbh;
        return $self->{dbh};
      }
    }
    
    {
    no warnings 'redefine';  
    sub insertRow {
       my($self,$val) = @_;
       my $d = $self->{dbh};
       my @val = @{$val}; 
          $d->do('INSERT INTO Guestbook (id,name,email,url,text,date,ip,agent) VALUES (?, ?, ?, ?, ?, NOW(), ?, ?)',
                   undef,
                  '',$val[0], $val[1], $val[2], $val[3], $val[4], $val[5]);
    
       return 1;
    
      }
    }
    
    {
	 no warnings 'redefine';	
     sub getRow {
        my($self) = @_;
        my $d = $self->{dbh};
        my $q = "SELECT * FROM Guestbook ORDER by date DESC";
        my $sth = $d->prepare( $q );
	       $sth->execute() or die $DBI::errstr;
        my $result = $sth->fetchall_arrayref({});
        return $result;
    
      }
    }
    
    1;
