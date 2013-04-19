// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
   $("#task_request_request_date").datepicker({dateFormat: 'yy-mm-dd'});
});
$(function() {
   $("#task_request_expected_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
});
//hide/show for need_delivery
$(function(){
   $("#task_request_need_delivery").change(function() {
   	 var rpt = $('#task_request_need_delivery').val();
   	 if ( rpt == 'true') {
   	    $("#task_request_delivery").show(); 
   	 } else {
   	 	$("#task_request_delivery").hide(); 
   	 }
   }); 
});