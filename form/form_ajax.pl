#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: form_ajax.pl
#
#        USAGE: ./form_ajax.pl  
#
#  DESCRIPTION: :
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (Lukasho Yuriy), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 30.03.2015 14:54:05
#     REVISION: ---
#===============================================================================

    use strict;
    use warnings;
    use utf8;
    use File::Basename;
    use FindBin;
    use lib dirname(__FILE__).'/lib';
    use Mycaptcha;
    use Mydbi;
    use CGI qw(:standard);
    use YAML::AppConfig;
    
    my $conf = YAML::AppConfig->new(file => dirname(__FILE__).'/config.yml');
    my $p = $ENV{ REQUEST_URI };  
    my $p_cgi = $p;
       $p =~ s/form\/form.pl//;
       $p_cgi =~ s/form.pl//;

    my $dir_cap_out_img = dirname(dirname(__FILE__)).'/outputcaptcha/';
    my $cap_data_folder = dirname(__FILE__).'/tmp/captcha/';
    my $img_cap_length  = $conf->get_captcha->{length};
    
    #******* Data for Mydbi ****************************************************
    my $driver     = $conf->get_plugins->{Database}->{driver};
    my $database   = $conf->get_plugins->{Database}->{database};
    my $host       = $conf->get_plugins->{Database}->{host};
    my $port       = $conf->get_plugins->{Database}->{port};
    my $username   = $conf->get_plugins->{Database}->{username};
    my $password   = $conf->get_plugins->{Database}->{password};
    my $RaiseError = $conf->get_plugins->{Database}->{dbi_params}->{RaiseError};
    my $AutoCommit = $conf->get_plugins->{Database}->{dbi_params}->{AutoCommit};
    #***************************************************************************
    my $q = new CGI;
    my $md5sum  = param('md5sum');
    my $capa    = param('capa');	
    my $comment = param('comment');	
    my $email   = param('email');		
    my $name    = param('name');	
    my $url     = param('url');	
    my $ip      = $ENV{ REMOTE_ADDR };
    my $agent   = $ENV{ HTTP_USER_AGENT };

    my $c = new Mycaptcha( $img_cap_length, $dir_cap_out_img, $cap_data_folder );
    my $result = $c->getStatus( $capa,$md5sum );
    print $q->header;  
    if ( $result == 1 ) {
		my $Db = new Mydbi( $driver,$database,$host,$port,$username,$password,$RaiseError,$AutoCommit );
        my $st = $Db->getConect();
		my @insert_val = ( $name, $email, $url, $comment, $ip, $agent ); 
		my $r = $Db->insertRow( \@insert_val );  
		print $result;
		
	 } else {
		print $result;
     }		 	
		      

   
   
