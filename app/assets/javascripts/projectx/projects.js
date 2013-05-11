// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//autocomplete for customers

$(function() {
    return $('#user_customer_name_autocomplete').autocomplete({
        minLength: 1,
        source: $('#user_customer_name_autocomplete').data('autocomplete-source'),  //'#..' can NOT be replaced with this
        select: function(event, ui) {
            //alert('fired!');
            $('#user_customer_name_autocomplete').val(ui.item.value);
        },
    });
});


$(function() {
	$( "#project_start_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#project_project_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	
});
