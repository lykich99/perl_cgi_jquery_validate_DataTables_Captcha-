<a href="http://lweb.pl.ua/perl/form/form.pl"> Guestbook - perl, cgi, jQuery validate, DataTables Captcha example </a>  - Demo<br>
<p> A. Copy or git pull this repository to cgi dir.</p>
    Correct ./form/config.yml for access to database.
         Database:
             driver: 'mysql'
             database: 'you_database' 
             host: 'you_host' 
             port: 3306 
             username: 'you_login' 
            password: 'you_password' 
      dbi_params:
             RaiseError: 1
             AutoCommit: 1
<p> You can tune in DataTables - the number of lines per page.</p>
      DataTabble:
          lengthMenu: 10
<p>   The next section tune in captcha.</p>
      captcha:
      length:         4   
      expire:         300       # optional. default 300
      width :         25        # optional. default 25
      height:         35        # optional. default 35
      keep_failures:  0         # optional, defaults to 0(false)
      debug:          0         # optional. default 0

<p>B. Create tables for database or you can get dump table /mysql/Guestbook.sql</p>

   CREATE TABLE `Guestbook` (<br>
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,<br>
  `name` varchar(200) NOT NULL,<br>
  `email` varchar(150) NOT NULL,<br>
  `url` varchar(200) NOT NULL,<br>
  `text` tinytext NOT NULL,<br>
  `date` datetime NOT NULL,<br>
  `ip` varchar(100) NOT NULL,<br>
  `agent` varchar(150) NOT NULL,<br>
  PRIMARY KEY (`id`)<br>
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;<br>

<p>C. You have to access cgi or mod_perl to form/form.pl (/form/*) </p>
     You have to make readable dir /outputcaptcha ( chmod 777 /outputcaptcha ).
     You have to make readable dir /form/tmp/captcha/ ( chmod -R 777 /form/tmp/captcha/ ).
     You have to install modules from CPAN or other it.
     Error log web-server can show what modules have not been installed.








