	$.validator.setDefaults({
		submitHandler: function() {
            var url = "../form/form_ajax.pl"; 
            $.ajax({
                type: "POST",
                url: url,
                data: $("#commentForm").serialize(), 
                success: function(data)
                   {
                      //alert(data); 
                      var msg_text;
                      if( data == 1 ) {
						   msg_text = "Good job!"; 
						} else {
						   msg_text = "Bad captcha code!";
						}	 
                      swal({   title: msg_text,   text: "I will close in 1 seconds.",   timer: 1000,   showConfirmButton: false });
                      location.reload();
                   }
                });
	    }
	});

	$().ready(function() {
	/**** DataTable ***********/
    $('#example').dataTable( {
               "lengthMenu": [ DataTablePager ],
               "order": [[ 6, "desc" ]]
    });
	/*************************/	             
    jQuery.validator.addMethod("textOnly", myTextOnlyValidation, "Please enter only characters.");
    jQuery.validator.addMethod("textUTF8", myTextUTF8, "Please enter only utf-8 text");
		
		// validate the comment form when it is submitted
    $("#commentForm").validate({
		     rules: {
		       comment:{
					     textOnly: true
				       },
			   name:   {
				         textUTF8: true
				       }
				        
		     }
		});

		
	});  
  
    function myTextUTF8(value, element){
		    var unicodeWord = XRegExp('^\\pL+$');
            return unicodeWord.test(value);
            //return /[a-zA-Z ]/.test(value);
    };
  
  
    function myTextOnlyValidation(value, element){
        var patt = /(<[^>]*>)/;
        var patt_str = patt.test(value);
        if( patt_str ) {
		     return false;
	     } else {
		     return true; 
	     }	 	
    };
