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
	$("#task_request_delivery_info").hide();
	
});
$(function(){
   $("#task_request_need_delivery").change(function() {
   	 var rpt = $('#task_request_need_delivery').is(":checked")  //val();
   	 //alert(rpt);
   	 if (rpt) {
   	 	//alert('if');
   	 	$("#task_request_delivery_info").show();  	    
   	 } else {
   	 	//alert('else');
   	 	$("#task_request_delivery_info").hide();  	 	
   	 }
   }); 
});