#===============================================================================
#
#         FILE: Mycaptcha.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (Lykashov Yuriy), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 30.03.2015 11:57:27
#     REVISION: ---
#===============================================================================

    use strict;
    use warnings;
    package Mycaptcha;
    use Authen::Captcha;
    use Digest::MD5 qw( md5_hex ); 
    use Exporter 'import';


    { 
	no warnings 'redefine';
    sub new {
       my $class = shift;
       my $self = {
                cap_length    => shift,
                cap_out_img   => shift,
                cap_data      => shift,
                expire        => shift,
                width         => shift,
                height        => shift,
                keep_failures => shift,
                debug         => shift
                
             };
        $self->{GETCAP} = Authen::Captcha->new( 
                                                data_folder => $self->{cap_data},
                                                output_folder => $self->{cap_out_img},
                                                expire        => $self->{expire},
                                                width         => $self->{width}, 
                                                height        => $self->{height},
                                                keep_failures => $self->{keep_failures},
                                                debug         => $self->{debug}
                                                );  
       bless $self, $class;
       return $self;
      }
    }
    
    { 
	no warnings 'redefine';
    sub getCaptchaImg {
       my($self) = @_; 
       my $cap_length  = $self->{ cap_length };
       my $cap_out_img = $self->{ cap_out_img };
       my $cap_data    = $self->{ cap_data };
       my $captcha     = $self->{ GETCAP };
       my $md5sum = $captcha->generate_code($cap_length);
          $self->{ md5sum } = $md5sum;
       return $self->{ md5sum };
     } 
    }
    
    { 
	no warnings 'redefine';    
    sub getStatus { 
       my($self,$code,$token) = @_;
       my $captcha = $self->{ GETCAP };
       my $result = $captcha->check_code($code,$token);
       return $result;
     }
    }



   1;
