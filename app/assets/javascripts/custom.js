$(document).on('ready turbolinks:load', function() {
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
	
		$('.thread-body').on('focus', '.comment-text-area', function() {
			$(this).css("background", "none");
			$(this).closest('.comments-form').find('.comment-actions').slideDown(1000);
		});

  	$('.thread-body').on('blur', '.comment-text-area', function() {
			if ($(this)[0].value == '') { 
				$(this).css("background-color", "#F5F5F5");
				$(this).closest('.comments-form').find('.comment-actions').slideUp(1000);
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
					//MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
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
					//MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
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
			// delete the current msg if there is one
			if ($('.alert').length || $('#error_explanation').length) {
				$('.alert').remove();
				$('#error_explanation').remove();
			}


    	if (typeof(e.detail[0].errors) != "undefined") {
				var html = "<div id='error_explanation'><ul><li>" + e.detail[0].message + "</li></ul></div>";
				$(this).closest('.forum_message').prepend(html);
				// On successful submission reload Mathjax, add a slot to postPages and 
			// add a success msg"
			} else {
				//MathJax.Hub.Queue(["Typeset",MathJax.Hub, $postForm[0]]);
				postPages.push(2);
				var html = "<div class='flash-top post-post-alert alert alert-success'> New post created!</div>";
				$('body').append(html);
				$('.flash-top').slideDown(500);
				setTimeout(function(){
    			$('.flash-top').slideUp(500);
  			}, 3500);

			}
		});

		/******  Post Update *************/
		

		$('.thread-body').on('ajax:success', '.update-posts-form', function (e) {
			if (typeof(e.detail[0].errors) != "undefined") {
				var html = "<div id='error_explanation'><ul><li>" + e.detail[0].message + "</li></ul></div>";
				if ($('.alert').length || $('#error_explanation').length) {
					$('.alert').remove();
					$('#error_explanation').remove();
				}
				$(this).closest('.forum_message').prepend(html);
			} 		
		}); 

		/*************** Comment Update ********************/

		$('.thread-body').on('ajax:success', '.update-comments-form', function (e) {
			if (typeof(e.detail[0].errors) != "undefined") {
				var html = "<div id='error_explanation'><ul><li>" + e.detail[0].message + "</li></ul></div>";
				if ($('.alert').length || $('#error_explanation').length) {
					$('.alert').remove();
					$('#error_explanation').remove();
				}
				$(this).closest('.forum_message').prepend(html);
			} 		
		}); 


	}

	/***************** Branch page **************/
	if ($('.branch-page').length) {

		/********************** Submit problems filter form ***************/

		$('#problems-filter-submit').on('click', function() {
			var id = $('.branch-page').attr('id');
			var branch_id = parseInt(id.substring(7, id.length));


			var topics = [];
			var problem_status = [];
			var difficulties = [];
			$('.topic-input').each(function() {
				if ($(this)[0].checked) {
					var id = $(this).attr('id');
					topics.push(id);
				}
			});

			$('.status-input').each(function() {
				if ($(this)[0].checked) {
					var id = $(this).attr('id');
					problem_status.push(id);
				}
			});

			$('.difficulty-input').each(function() {
				if ($(this)[0].checked) {
					var id = $(this).attr('id');
					difficulty = parseInt(id.substring(11, id.length));

					difficulties.push(difficulty);
				}
			});

			$.ajax({
				type: "GET",
				url: "/problems_filter",
				headers: {
					Accept: "text/javascript; charset=utf-8",
					"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
				},
				data: {
					branch_id: branch_id,
					problem_status: problem_status,
					topics: topics,
					difficulties: difficulties
				}
			});

		});
	}

	/* Leaderboard Page */

	if ($('.leaderboard-page').length) {
		$('#leaderboards-filter-submit').on('click', function() {

			var branches = [];
			var users = [];
			var leaderboard = "";
			$('.branch-input').each(function() {
				if ($(this)[0].checked) {
					var id = $(this).attr('id');
					var branch_id = parseInt(id.substring(7, id.length));
					branches.push(branch_id);
				}
			});

			$('.users-input').each(function() {
				if ($(this)[0].checked) {
					var id = $(this).attr('id');
					users.push(id);
				}
			});

			$('.leaderboard-input').each(function() {
				if ($(this)[0].checked) {
					leaderboard = $(this).attr('id');
				}
			});

			$.ajax({
				type: "GET",
				url: "/leaderboard_filter",
				headers: {
					Accept: "text/javascript; charset=utf-8",
					"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
				},
				data: {
					branches: branches,
					users: users,
					leaderboard: leaderboard
				}
			});

		});

	}

	if ($('#frame').length) {
		
		$(".messages").animate({ scrollTop: $(document).height() }, "fast");

		$("#profile-img").click(function() {
			$("#status-options").toggleClass("active");
		});

		$(".expand-button").click(function() {
  		$("#profile").toggleClass("expanded");
			$("#contacts").toggleClass("expanded");
		});

		$("#status-options ul li").click(function() {
			$("#profile-img").removeClass();
			$("#status-online").removeClass("active");
			$("#status-away").removeClass("active");
			$("#status-busy").removeClass("active");
			$("#status-offline").removeClass("active");
			$(this).addClass("active");
	
			if($("#status-online").hasClass("active")) {
				$("#profile-img").addClass("online");
			} else if ($("#status-away").hasClass("active")) {
				$("#profile-img").addClass("away");
			} else if ($("#status-busy").hasClass("active")) {
				$("#profile-img").addClass("busy");
			} else if ($("#status-offline").hasClass("active")) {
				$("#profile-img").addClass("offline");
			} else {
				$("#profile-img").removeClass();
			};
	
			$("#status-options").removeClass("active");
		});

			
		/* Message Submission */

		$('#frame .msg-submit').click(function() {
			if ($('.alert').length || $('#error_explanation').length) {
				$('.alert').remove();
				$('#error_explanation').remove();
			}

  		$form = $(this).closest('form')[0];
			message = $($form).find('textarea[name="message[body]"]:first').val();
			if($.trim(message) == '') {
				// Error handling
				var error_html = "<div id='error_explanation'><ul><li>" + "Message cannot be empty" + "</li></ul></div>";
				if ($($form).hasClass('messages-form')) {
					$(error_html).appendTo($('.messages'));
				}
				setTimeout(function(){
    			$('#error_explanation').fadeOut(500);
  			}, 3500);

				return false;
			} else {
				$.ajax({
					type: "POST",
					url: "/messages",
					headers: {
						Accept: "text/javascript; charset=utf-8",
						"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
					},
					data: {
						message: {
							body: message,
							conversation_id: $($form).find('input[name="conversation_id"]:first').val()
						},
						authenticity_token: AUTH_TOKEN
					}
				});
			}
		});
	
		
	}

	/*************** Preview Markdown ***********************/

	$('body').on('click', '.preview-btn', function() {
		$form = $(this).closest('form')[0];
		var content = '';
		if ($($form).hasClass('posts-form') || $($form).hasClass('update-posts-form')) {
			content = $($form).find('textarea[name="post[content]"]:first').val();
		} else if ($($form).hasClass('comments-form') || $($form).hasClass('update-comments-form')){
			content = $($form).find('textarea[name="comment[content]"]:first').val();
		} else if ($($form).hasClass('problems-form') || $($form).hasClass('update-problems-form')) {
			content = $($form).find('textarea[name="problem[question]"]:first').val();
		} else {
			content = $($form).find('textarea[name="message[body]"]:first').val();
		}
		math = $('#preview-modal .preview_content > p');
		math.text(content);	
		setTimeout(function() {
			MathJax.Hub.Queue(["Typeset", MathJax.Hub, math[0]]);
		} ,500);
	});

	/* Sending message through modal */

	if (('#new-conversation-modal').length) {
		$('#new-conversation-modal').on('click', '.msg-submit', function() {
			if ($('.alert').length || $('#error_explanation').length) {
				$('.alert').remove();
				$('#error_explanation').remove();
			}

			$form = $(this).closest('form')[0];
			message = $($form).find('textarea[name="message[body]"]:first').val();
			username = $(this).closest('.modal-body').find('#username-search').val();
			if($.trim(message) == '') {
				// Error handling for empty message
				var error_html = "<div id='error_explanation' class='g-mt-20'><ul><li>" + "Message cannot be empty" + "</li></ul></div>";
				if ($($form).hasClass('messages-form')) {
					$(error_html).appendTo($($form));
				}
				
				return false;
			} else if ($.trim(username) == '') {
				// Error handling
				var error_html = "<div id='error_explanation' class='g-mt-20'><ul><li>" + "Username cannot be blank" + "</li></ul></div>";
				if ($($form).hasClass('messages-form')) {
					$(error_html).appendTo($($form));
				}
				return false;
			} else {
				$.ajax({
					type: "POST",
					url: "/conversations",
					headers: {
						Accept: "text/javascript; charset=utf-8",
						"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
					},
					data: {
						body: message,
						username: username,
						authenticity_token: AUTH_TOKEN
					},
					success: function(data) {
			
					}
				});
			}

		});
	}

	/* Relationships */

	if ($('.relationship-btn').length) {
		
		/* Follow User */

		$('body').on('click', '.follow-btn', function(event) {
			var id = $(this).attr('id');
			var user_id = parseInt(id.substring(11, id.length));
			$("#follow-btn-" + user_id).remove();
			$.ajax({
				url: '/follow',  // submits it to the given url of the form
				headers: {
					Accept: "text/javascript; charset=utf-8",					"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
				},
				type: 'POST',
				data: {	
					authenticity_token: AUTH_TOKEN,
					followed: user_id
				}
			});
		});

		/************************ Unfollow **************/
		$('body').on('click', '.unfollow-btn', function(event) {
			var id = $(this).attr('id');
			var user_id = parseInt(id.substring(14, id.length));
			$("#following-btn-" + user_id).remove();
		
			$.ajax({
				url: '/unfollow',  // submits it to the given url of the form
				headers: {
					Accept: "text/javascript; charset=utf-8",					"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
				},
				type: 'GET',
				data: {	
					authenticity_token: AUTH_TOKEN,
					followed: user_id
				}
			});
		});
	}

	/* Progress Page */

	if ($('.profile-main-div').length) {

		$('.new-msg').on('click', function() {
			var username = $('.username').text();
			$('#username-search').val(username);
		});

		if ($(".profile-img-edit").length) {
			$('.profile-img-file').on('change', function() {
				$('.profile-img-edit').submit();
			});

		}


	/* Load more recently solved problems */

	var currentRecentlySolvedPage = 2;
	$('.load-more-problems-solved').on('click', function() {
		var id = $(this).attr('id');
		var user_id = parseInt(id.substring(26, id.length));

		$.ajax({
			type: "GET",
			url: "/recently_solved_problems",
			headers: {
				Accept: "text/javascript; charset=utf-8",
				"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
			},
			data: {
				page: currentRecentlySolvedPage,
				user_id: user_id
			},
			success: function(myData) {
				currentRecentlySolvedPage = currentRecentlySolvedPage + 1;
			}
		});
	});

	}

	/* Search Suggestions */

	$.widget( "custom.catcomplete", $.ui.autocomplete, {
  	_create: function() {
      this._super();
      this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
    },
		_renderItem: function( ul, item ) {
			if (item.category === "Users") {
				return $("<li>")
					.append("<a href='/users/" + item.id + "'><img class='inline-icon' src='" + item.image_url + "'> <span class='font-weight-500 g-ml-5'>" + item.label + "</span></a>")
					.appendTo ( ul );
			} else {
				return $("<li>")
					.append("<a href='/problems/" + item.id + "'><span class='font-weight-500 g-ml-5'>" + item.label + "</span></a>")
					.appendTo ( ul );

			}
		},
    _renderMenu: function( ul, items ) {
      var that = this,
      currentCategory = "users";
      $.each( items, function( index, item ) {
        var li;
        if ( item.category != currentCategory ) {
          ul.append( "<li class='ui-autocomplete-category " + item.category + "-cat'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        li = that._renderItemData( ul, item );
        if ( item.category ) {
          li.attr( "aria-label", item.category + " : " + item.label );
        }
      });
    }
  });

	$("#main-search").catcomplete( {
		delay: 0,
		source: function( request, response ) {
			$.ajax({
				type: "GET",
				url: "/autocomplete",
				data: {
					query: request.term
				},
				success: function(data) {
					response(data.suggestions);
				}
			});
		},
		select: function(event, ui) {	
			$("#main-search").val(ui.item.name);
			if (ui.item.category === "Users") {
				window.location.href = "/users/" + ui.item.id;
			} else {
				window.location.href = "/problems/" + ui.item.id;
			}
		},
		focus: function(event, ui) {
			event.preventDefault();
			$('#main-search').val(ui.item.name);
		},
	});	

	/* Mark Notification as read */
	$('#notifications-modal').on('hidden.bs.modal', function() {
		$.ajax({
			url: "/read_notifications",  // submits it to the given url of the form
			headers: {
				Accept: "text/javascript; charset=utf-8",
				"Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
			},
			type: 'GET',		
			data: {
				authenticity_token: AUTH_TOKEN
			}
		});
	});
  	//MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
});
