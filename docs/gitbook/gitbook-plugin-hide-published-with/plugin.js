require(["gitbook"], function(gitbook) {
	$('.gitbook-link').hide(); 
    gitbook.events.bind("page.change", function() {
    	console.log("Hello custom plugin")
    	$('.gitbook-link').hide();           
    });
});
