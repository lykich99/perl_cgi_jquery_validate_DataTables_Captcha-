#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: form.pl
#
#        USAGE: ./form.pl  
#
#  DESCRIPTION: CGI Form example
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (Lykashov Yuriy), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 28.03.2015 13:29:35
#     REVISION: ---
#===============================================================================

    use strict;
    use warnings;
    use utf8;   
    use CGI qw(:standard);
    use YAML::AppConfig;
    use Data::Dumper;
    use File::Basename;
    use FindBin;
    use lib dirname(__FILE__).'/lib';
    use Template;
    use Mydbi;
    use Mycaptcha;
    my $conf = YAML::AppConfig->new(file => dirname(__FILE__).'/config.yml');
    my $p = $ENV{ REQUEST_URI };  
    my $p_cgi = $p;
       $p =~ s/form\/form.pl//;
       $p_cgi =~ s/form.pl//;

    #******* Data for Captcha *************************************************
    my $dir_cap_out_img = dirname(dirname(__FILE__)).'/outputcaptcha/';
    my $cap_data_folder = dirname(__FILE__).'/tmp/captcha/';
    my $img_cap_length  = $conf->get_captcha->{length};
    my $expire          = $conf->get_captcha->{expire}; 
    my $width           = $conf->get_captcha->{width};
    my $height          = $conf->get_captcha->{height};
    my $keep_failures   = $conf->get_captcha->{keep_failures};
    my $debug           = $conf->get_captcha->{debug};
    #**************************************************************************
    my $c = new Mycaptcha( $img_cap_length, $dir_cap_out_img, $cap_data_folder, $expire, $width, $height, $keep_failures, $debug );
    my $c_img = $c->getCaptchaImg();
    my $capthca_img = '../..'.$p.'outputcaptcha/'.$c_img.'.png';
    
    #******* Data for Mydbi **************************************************
    my $driver     = $conf->get_plugins->{Database}->{driver};
    my $database   = $conf->get_plugins->{Database}->{database};
    my $host       = $conf->get_plugins->{Database}->{host};
    my $port       = $conf->get_plugins->{Database}->{port};
    my $username   = $conf->get_plugins->{Database}->{username};
    my $password   = $conf->get_plugins->{Database}->{password};
    my $RaiseError = $conf->get_plugins->{Database}->{dbi_params}->{RaiseError};
    my $AutoCommit = $conf->get_plugins->{Database}->{dbi_params}->{AutoCommit};
    #*************************************************************************
    my $Db = new Mydbi( $driver,$database,$host,$port,$username,$password,$RaiseError,$AutoCommit );
        $Db->getConect();
    my $row_tt = $Db->getRow();
    #************************************************************************
    my $t = Template->new({
		                     ENCODING => 'utf8',
                             INCLUDE_PATH => dirname(__FILE__).'/view',
                          });
    
    my $q = new CGI;
    my $data_pager = $conf->get_DataTabble->{ lengthMenu };  
    print $q->header(-charset => 'UTF-8');     
    print "<script language='JavaScript'> DataTablePager = $data_pager; </script>";
    print $q->start_html(  -title=>'Guestbook - perl, cgi, jQuery validate, DataTables example',
                           -encoding => "utf-8",
                           -script=>[
                                      {-type=>'JAVASCRIPT', -src=>$p.'js/validate/jquery.js'},
                                      {-type=>'JAVASCRIPT', -src=>$p.'DataTables/js/jquery.dataTables.js'},
                                      {-type=>'JAVASCRIPT', -src=>$p.'js/dist/jquery.validate.js'},
                                      {-type=>'JAVASCRIPT', -src=>$p.'js/sweet-alert.min.js'},
                                      {-type=>'JAVASCRIPT', -src=>$p.'js/xregexp.js'},
                                      {-type=>'JAVASCRIPT', -src=>$p.'js/addons/unicode/unicode-base.js'},
                                      {-type=>'JAVASCRIPT', -src=>$p.'js/addons/unicode/unicode-categories.js'},
                                      {-type=>'JAVASCRIPT', -src=>$p.'js/addons/unicode/unicode-scripts.js'},
                                      {-type=>'JAVASCRIPT', -src=>$p.'js/main.js'}
                                    ],
                           -style=> [
                                      {-src=>$p.'css/validate/screen.css'},
                                      {-src=>$p.'DataTables/css/jquery.dataTables.css'},
                                      {-src=>$p.'css/sweet-alert.css'},
                                      {-src=>$p.'css/form.css'},
                                      {-src=>$p.'css/table.css'}
                                    ]        
                         );

    binmode(STDOUT, ":utf8");
    $t->process('form.tt', {
                              cap_img => $capthca_img,
                              md5sum  => $c_img,
                              row     => $row_tt
                            }                     
                            
               )|| die $t->error;    
        
        
    print $q->end_html;
   
