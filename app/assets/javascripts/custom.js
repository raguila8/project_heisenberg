$(document).on('turbolinks:load', function() {

/*************** Threads *******************/
	if ($('.thread-body').length) {

		/****** Load comment buttons on input focus *************/
	
		$('.comment-text-area')
		.focus(function() { 
			$(this).css("background", "none");
			$(this).closest('.comment-form').find('.comment-actions').slideDown(1000);
		})
  	.blur(function() { 
			if ($(this)[0].value == '') { 
				$(this).css("background-color", "#F5F5F5");
				$(this).closest('.comment-form').find('.comment-actions').slideUp(1000);
			} 
		});

		/************ Load More Comments ********/

		var numberOfPosts = $('.post-container').length;
		// Keeps track of visible comments. The key is the post number and the
		// the value is the current page of th post. Each page has 5 comments. 
		// Every post starts at page 2 because the first 5 comments are visible 
		// by default.
		var postPages = new Array();
		for (var i = 0; i < numberOfPosts; i++) {
			postPages[i] = 2;
		}
		$('.thread-body').on('click', '.more-comments-link', function() {
			var id = $(this).attr('id');
			var post_id = parseInt(id.substring(14, id.length));
			var post_number_str = $($(this).closest('.post-container')).attr('id');
			var post_number = post_number_str.substring(11, post_number_str.length);
			
			$.ajax({
				type: "GET",
				url: "/get_comments",
				headers: {
					Accept: "text/javascript; charset=utf-8",
					"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
				},
				data: {
					post_id: post_id,
					page: postPages[post_number]
				},
				success: function(data) {
					postPages[post_number] = postPages[post_number] + 1;
				}
			});
		});

	}
});
