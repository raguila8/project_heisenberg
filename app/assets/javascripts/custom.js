$(document).on('turbolinks:load', function() {
	var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');

/*************** Threads *******************/
	if ($('.thread-body').length) {

		/************ Change background of post textarea on focus *************/ 

		$('.post-textarea')
		.focus(function() { 
			$(this).css("background", "none");
		})
  	.blur(function() { 
			if ($(this)[0].value == '') { 
				$(this).css("background-color", "#F5F5F5");
			} 
		});	
		

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
		// The post create form also has a .post-container class.
		var numberOfPosts = $('.post-container').length - 1;
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
					MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
					postPages[post_number] = postPages[post_number] + 1;
				}
			});
		});

		/****************** Load More Posts (Infinite Scroll) *******************/
		var currentPostPage = 2;
		$('.thread-body').on('click', '.more-posts-btn', function() {
			var id = $(this).attr('id');
			var thread_id = parseInt(id.substring(15, id.length));

		$.ajax({
			type: "GET",
			url: "/topics/" + thread_id,
			headers: {
				Accept: "text/javascript; charset=utf-8",
				"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
			},
			data: {
				page: currentPostPage
			},
			success: function(myData) {
				MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
				currentPostPage = currentPostPage + 1;
				for (var i = 0; i < 10; i++) {
					postPages.push(2);
				}
			}
		});
	});

		/***************** Submit Post With ajax *********/
/*
		$('.thread-body').on('click', '.submit-post-btn', function() {
			$form = $(this).closest('form')[0];
			$.ajax({
				url: '/posts',  // submits it to the given url of the form
				headers: {
					Accept: "text/javascript; charset=utf-8",
					"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
				},
				type: 'POST',
				data: {
					post: {
						content: $($form).find('textarea[name="post[content]"]').val(), 
						user_id: $($form).find('input[name="user_id"]').val(), 
						topic_id: $($form).find('input[name="topic_id"]').val()
					},
					post_count: postPages.length,
					authenticity_token: AUTH_TOKEN
				},
				success: function(data) {
					MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
					postPages.push(2);
					console.log("success");
				}
			});
		});
*/

		/******  Post Submission *************/

		var $postForm = $('#posts-form');

    $postForm.on('ajax:success', function(e) {
    	if (typeof(e.detail[0].errors) != "undefined") {
				var html = "<div class='alert alert-danger'>" + e.detail[0].message + "</div>";

				// On successful submission reload Mathjax, add a slot to postPages and 
			// add a success msg"
			} else {
				MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
				postPages.push(2);
				var html = "<div class='alert alert-success'> New post created!</div>";
			}

			// replaces the current msg if there is one
			if ($('.alert').length) {
				$('.alert').replaceWith(html);
			} else {
				$('.thread-body').prepend(html);
			}

    });

		/*************** Preview Markdown ***********************/

		$('.thread-body').on('click', '.preview-btn', function() {
			$form = $(this).closest('form')[0];
			var content = '';
			if ($(this).parent()[0].isEqualNode($('.post-actions')[0])) {
				content = $($form).find('textarea[name="post[content]"]').val();
			} else {
				content = $($form).find('textarea[name="comment[content]"]').val();	
			}
			$('#post-preview-modal .forum_message > p').text(content);
			MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
		});
	}
});
