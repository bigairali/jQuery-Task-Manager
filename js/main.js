// Date.create().set({ month: Date.create().getMonth() + 1 }).format('{Month}') > June;
// month change

/*  
	LocalityME task manager
	Author: Chris J. Whitman
*/

(function($){
	
//===============================================
//=========================== APPLICATION GLOBALS	
	
	var win = $(window),
		body = $(document.body),
		container = $('#container'),	// the only element in index.html
		currentUser = {},
		currentDate = [],
		currentEvent = {},
		currentInfo = {},
		appLoaded = false
	;
	
	var placeholders = $('input[placeholder], textarea[placeholder]').placeholder();
	var tasks = {}; 
	var openPanel = false;

	var todayMonth = Date.create().format('{Month}');
	var todayYear = Date.create().format('{yyyy}');
	
	var currentMonthValue = Date.create(todayMonth).getMonth();
	
	
/* For Future endeavors
	var ajaxCall = function(which, data, success){
		
		var opts = $.extend({}, calls[which], {data: data, success: success});
		$.ajax(opts);
	};
*/
	

//===============================================
//========================= APPLICATION FUNCTIONS
	
	
	/* [LOAD APP] Function
	============================================== */
	var loadApp = function(firstName, lastName){
		$.get('templates/app.html', function(html){
			var h = $(html);
			var landingCode = h.find('#template_app').html();
			$.template('app', landingCode);		// compile template
			container.html($.render(currentUser, 'app')); // use template
						
			var userLink =  $('#currentUser');
			
			if(currentUser.first_name !== '' && currentUser.last_name !== ''){	
				userLink.html(currentUser.first_name + ' ' + currentUser.last_name);
			}else{
				userLink.html(currentUser.user_n);
			};
			renderMonth(todayMonth + ' ' + todayYear);
			getTasks();
			
		});
	
	};
	
	
	/* [LOAD LANDING]
	============================================== */
	var loadLanding = function(){
		$.get('templates/landing.html', function(html){
			var h = $(html);
			var landingCode = h.find('#template_landing').html();
			$.template('landing', landingCode);		// compile template
			container.html($.render(currentUser, 'landing')); // use template
			
			appLoaded = false;
		});
	};
	
	
	/* [LOAD NEW EVENT PANEL]
	============================================== */
	var loadNewEvent = function(){
		$('#myModal').remove();
	
		$.get('templates/app.html', function(html){
			var h = $(html);
			var landingCode = h.find('#template_add_panel').html();
			$.template('add_panel', landingCode);		// compile template
			body.append($.render(currentUser, 'add_panel')); // use template
			
			$('.panel').reveal();
			$('.panel form').focus();
		});
		$('.overTasked').fadeOut();
	};
	
	
	/* [LOAD EDIT EVENT PANEL]
	============================================== */
	var loadEdit = function(){
		$('#myModal').remove();
	
		$.get('templates/app.html', function(html){
			var h = $(html);
			var landingCode = h.find('#template_edit_panel').html();
			$.template('edit_panel', landingCode);		// compile template
			body.append($.render(currentUser, 'edit_panel')); // use template
			
			$('.panel').reveal();
	
			$('input[name="title"]').val(currentInfo.taskName);
			$('select').val(currentInfo.status);
			$('textarea').val(currentInfo.taskDescription);
		});
		$('.overTasked').fadeOut();
	};
	
	
	/* [LOAD ACCOUNT INFORMATION PANEL]
	============================================== */
	var loadAccount = function(){
		$('#myModal').remove();
	
		$.get('templates/app.html', function(html){
			var h = $(html);
			var landingCode = h.find('#template_account_panel').html();
			$.template('account_panel', landingCode);		// compile template
			body.append($.render(currentUser, 'account_panel')); // use template
			
			$('.accountpanel').reveal();
			
			var panel = $('.accountpanel');
			
			var inputFirstName = panel.find('input[name="first_name"]');
			var inputLastName = panel.find('input[name="last_name"]');
			var inputEmail = panel.find('input[name="email"]');
			var inputBio = panel.find('textarea');
			
			inputFirstName.val(currentUser.first_name);
			inputLastName.val(currentUser.last_name);
			inputEmail.val(currentUser.email);
			inputBio.val(currentUser.avatar);			
		});
	};
	
	
	/* [UPDATE USER INFO] Function
	============================================== */
	var updateUser = function(){
		$.ajax({
			url: 'xhr/update_user.php',
			type: 'post',
			data: {
				password: currentUser.password,
				email: currentUser.email,
				first_name: currentUser.first_name,
				last_name: currentUser.last_name,
				avatar: currentUser.avatar
			},
			dataType: 'json',
			success: function(response){
			}
		});
	};
	
	
	/* [CREATE NEW USER] Function
	============================================== */
	var newUser = function(user, pass, email){
		$.ajax({
			url: 'xhr/register.php',
			type: 'post',
			data: {
				username: user,
				password: pass,
				email: email
			},
			dataType: 'json',
			success: function(response){					
				if(response.error){
					var error = $('#signup .error');
					error.html(response.error);
					error.show();
				}else if(response.user){
					currentUser = response.user;
					loadApp();
				};
			}
		});
	};
		
		
	/* [LOGIN] Function
	============================================== */
	var login = function(username, password){
		$.ajax({
			url: 'xhr/login.php',
			type: 'post',
			data: {
				username: username,
				password: password
			},
			dataType: 'json',
			success: function(response){
				if(response.error){
					$('#login .error').show();
				}else if(response.user){
					$('#login .error').hide();
										
					currentUser = response.user;
					checkLoginState();
				}
			}
		});

	};
	
	
	/* [LOGOUT] Function
	============================================== */
	var logout = function(){
		$.ajax({
			url: 'xhr/logout.php',
			type: 'get',
			dataType: 'json',
			success: function(response){
				if(response.success){
					loadLanding();
				}
			}
		});
	};
	
	
	/* [CHECK LOGIN STATE] Function
	============================================== */	
	var checkLoginState = function(){
		$.ajax({
			url: 'xhr/check_login.php',
			type: 'get',
			dataType: 'json',
			success: function(response){
				if(response.error){
					loadLanding();
				}else if(response.user){
					currentUser = response.user;
					loadApp();
				};
			}
		});
	};
//notif check
	var notifCheck = function(list){
		var listLength = list.find('li').length;
				
		if(listLength > 5){
			var parentDate = list.parent();
			
			list.css('display', 'none');
			parentDate.addClass('eventOverflow');
			
			if(parentDate.find('.notif').length === 0){
				parentDate.append('<div class="notif"><a href="#">'+ listLength +' Events</a></div>');
			}else{
				parentDate.find('.notif a').text(listLength +' Events');
			};
			
			if(list.find('.urgent').length > 0){
				parentDate.find('.notif').addClass('urgentImage');
			}
		}else if(listLength <= 5){
		
			list.show().removeClass('overTasked');
			
			list.parent().removeClass('eventOverflow');
			list.parent().find('div').remove();
		};
	};
	
	
	
	/* [POPULATE CALENDAR] Function
	============================================== */
	var populateCalendar = function(){
		var dates = $('tbody td');
		
		$.each(dates, function(i, dateValue){
			var currentBlock = $(dateValue);
			var blockDate = currentBlock.attr('data-date');

			var ulBlock = '<ul class="tasks"></ul>';
			currentBlock.append(ulBlock);
			
			
			
			$.each(tasks, function(i, taskValue){
				if(taskValue.startDate === blockDate){
					
					var taskList = currentBlock.find('ul');					
					var title = taskValue.taskName;
					
					// truncate taskName
					if(title.length > 20){
						var truncated = '';
					
						for(var i = 0, max = 15; i < max; i++ ){								
							truncated += title[i]
						};
						
						truncated = truncated.trim();
						truncated += '...';
						title = truncated;
					};
					
					if(taskValue.status === 'Normal'){
						taskList.append('<li class="green-up" data-id="'+ 
						taskValue.id +'">'+ title +'</li>');
					}else if(taskValue.status === 'Urgent'){
						taskList.append('<li class="red-up urgent" data-id="'+ 
						taskValue.id +'">'+ title +'</li>');
					}else if(taskValue.status === 'Delayed'){
						taskList.append('<li class="delayed khakibar" data-id="'+ 
						taskValue.id +'">'+ title +'</li>');
					}else if(taskValue.status === 'Finished'){
						taskList.append('<li class="blackbar finished" data-id="'+ 
						taskValue.id +'">'+ title +'</li>');
					};
					
					notifCheck(taskList);
				};
			});
			
			
/* ============== DRAGGABLE, SORT */			
			$('.tasks').sortable({
				revert: true,
				connectWith: '.tasks',
				tolerance: 'pointer',
				receive: function(e, ui){
					var list = $(this);
					
					var liEvent = ui.item;
					var id = liEvent.attr('data-id');
					var date;
										
					$.each(tasks, function(i, value){
						if(value.id === id){
							date = liEvent.parent().parent().attr('data-date');
							updateTask(id, date);
						};
					});	
					
					notifCheck(liEvent.parent());
					notifCheck(ui.sender);
					$('.overTasked').fadeOut();
				}
			});
			
			$('ul, li, td').disableSelection();
		});
		
	};
	
	

	/* [ADD USER TASK] Function
	============================================== */
	var addTask = function(name, stat, des, date){
	
		var newProjectID = 35;
			
		$.ajax({
			url: 'xhr/new_task.php',
			type: 'post',
			data: {
			   projectID: '' + newProjectID,	// string (required)
			   taskName: name,					// string (required)
			   status: stat,					// string (required)
			   taskDescription: des,			// optional
			   taskeeID: name,					// optional
			   startDate: date,					// optional
			},
			dataType: 'json',
			success: function(response){
				var id = response.task.id;
 				getTasks();
				
				currentEvent.attr('data-id', id);
			}
		});
	};


	/* [GET USER TASKS] Function
	============================================== */
	var getTasks = function(){
		$.ajax({
			url: 'xhr/get_tasks.php',
			type: 'get',
			dataType: 'json',
			success: function(response){
				tasks = response.tasks;
								
				if(!appLoaded){
					populateCalendar();
					appLoaded = true;
				};
			}
		});
	};
	
	
	/* [DELETE USER TASKS] Function
	============================================== */
	var deleteTask = function(id){
		$.ajax({
			url: 'xhr/delete_task.php',
			type: 'post',
			data: {
				taskID: id
			},
			dataType: 'json',
			success: function(response){
				getTasks();
			}
		});
	};
	
	
	/* [UPDATE USER TASKS] Function
	============================================== */
	var updateTask = function(id, date){
		$.ajax({
			url: 'xhr/update_task.php',
			type: 'post',
			data: {
				taskID: id ? id : currentInfo.id,
				taskName: currentInfo.taskName,
				taskDescription: currentInfo.taskDescription,
				status: currentInfo.status,
				startDate: date ? date : currentInfo.startDate
			},
			dataType: 'json',
			success: function(response){
				getTasks();
			}
		});
	};
		
	
	/* [MAKE CALENDAR] Function
	============================================== */
	var renderMonth = function(start){
		var tbody = $('#days');
		var theMonth = $('.month');
		
		theMonth.html(todayMonth + " " + todayYear);
		
		var thisMonth = Date.create(start);
		var monthLength = thisMonth.daysInMonth();
		var startIndex = thisMonth.getDay();
		var totalDays = monthLength + startIndex;
		var maxDays = 35;

				
		var html = '';
		var dayBefore = startIndex;
		
		// This checks to see if there is a need for an extra week in the month
		if(startIndex >= 5 && totalDays === 31){
			maxDays = 42;
		}else if(startIndex === 6 && totalDays >= 30){
			maxDays = 42;
		}else if(startIndex === 0 && totalDays === 28){
			maxDays = 28;
		};
		
		for(var i = 0; i < maxDays; i++){
			if(i % 7 === 0){
				if(i !== 0){
					html += '</tr>';
				};
				html += '<tr>';
			}
			
			if(i < startIndex){
				// previous month day
				var previousDay = (dayBefore).daysBefore(start).getDate();
				var prevData = (dayBefore).daysBefore(start).format('{yyyy}-{Month}-{dd}');
				
				html += '<td class="offset_month blackbar" data-date="'+ prevData +'">'+ previousDay +'</td>';
				dayBefore--;
			}else{
				var dayNumber = (i - startIndex).daysAfter(start).getDate();
				var dataDate = (i - startIndex).daysAfter(start).format('{yyyy}-{Month}-{dd}')
				
				if(i < totalDays){
					
					if(i % 2 === 0){
						html += '<td class="even" data-date="'+ dataDate +'">'+ dayNumber +'</td>';
					}else{
						html += '<td data-date="'+ dataDate +'">'+ dayNumber +'</td>';
					};
				
				}else{
					html += '<td class="offset_month blackbar" data-date="'+ dataDate +'" >'+ dayNumber +'</td>';
				};
			}
		};

		tbody.html(html);
		getTasks();
	};
	
	
	/* [RERENDER THE MONTH] Function
	============================================== */
	var changeMonth = function(){
		appLoaded = false;
		var currentMonthYear = Date.create().set({ month: currentMonthValue }).format('{Month} {yyyy}');
		var nextMonth = Date.create().set({ month: currentMonthValue }).format('{Month}');
		
		todayMonth = nextMonth;
		
		$('.month').text( currentMonthYear );
		renderMonth( currentMonthYear );
	};
	

//============================================
//SETUP FOR INIT
		
	var init = function(){
		checkLoginState();
	};
		
	init();

//===============================================
//======================================== EVENTS	

	/* ========================= ON LOGIN */
	win.on('submit', '#login form', function(e){
		var loginForm = $(this);
		var user = loginForm.find('input[name="loginUser"]').val();
		var pass = loginForm.find('input[name="loginPass"]').val();
				
		login($.trim(user), $.trim(pass));
		e.preventDefault();
		return false;
	});
	
	
	/* ========================= OPEN ACCOUNT INFORMATION */
	win.on('click', '#currentUser', function(e){
		$('#myModal').remove();
		
		openPanel = true;
		
		loadAccount();
	});


	/* ========================= SUBMIT UPDATED ACCOUNT INFO */
	win.on('submit', '#accountInfo', function(e){
		var panel = $(this);

		var inputFirstName = panel.find('input[name="first_name"]');
		var inputLastName = panel.find('input[name="last_name"]');
		var inputNewPass = panel.find('input[name="newpass"]');
		var inputConfirmPass = panel.find('input[name="confirmpass"]');
		var inputEmail = panel.find('input[name="email"]');
		var inputBio = panel.find('textarea');
		
		var pattern = /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$/;		
		var emailPass = pattern.test(inputEmail.val());
		
		if(!emailPass || inputNewPass.val() !== inputConfirmPass.val()){
			if(!emailPass){
				inputEmail.parent().find('span').fadeIn();
			}else{
				inputEmail.parent().find('span').fadeOut();
			};
			
			if(inputNewPass.val() !== inputConfirmPass.val()){
				inputNewPass.parent().find('span').fadeIn();
				inputConfirmPass.parent().find('span').fadeIn();
			}else{
				inputNewPass.parent().find('span').fadeOut();
				inputConfirmPass.parent().find('span').fadeOut();
			};
			
		}else{
			currentUser.first_name = inputFirstName.val();
			currentUser.last_name = inputLastName.val();
			currentUser.email = inputEmail.val();
			currentUser.avatar = inputBio.val();
			
			if(inputNewPass.val() !== '' && inputConfirmPass.val() !== ''){
				currentUser.password = inputNewPass.val();
			};
			
			updateUser();
			$('#myModal').fadeOut();
		};
		
		openPanel = false;
				
		e.preventDefault();
		return false;
	});


	/* ========================= SIGN-UP */
	win.on('submit', '#signup', function(e){

		var email = $(this).find('input[name="email"]');
		var password = $(this).find('input[name="regPass"]');
		
		var pattern = /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$/;		
		var pass = pattern.test(email.val());		
		
		if(!pass || password.val() === ''){
			$(this).find('.error').html('Please fill-in all values');
			$(this).find('.error').show();
						
			e.preventDefault();
			return false;
		}else if(pass && email.val() !== ''){
			$(this).find('.error').hide();
			
			newUser(email.val(), password.val(), email.val());
							
			e.preventDefault();
			return false;
		};
	});
	
	
	/* ========================= DATE CLICK */
	win.on('click', '#days td', function(e){
		if($('.infoTip').length > 0){
			$('.infoTip').remove();
		};
		
		var list = $(this).find('ul');
		
		loadNewEvent();
		
		currentDate = $(this);
		currentDate.find('.tasks').append('<li class="green-up newEvent">Title Event</li>');
		
		notifCheck(currentDate.find('.tasks'));
		
		openPanel = true;
		
		return false;
	});
	
	
	/* ========================= PANEL CLOSED */
	win.on('click', '.close-panel', function(e){	
		currentDate.find('ul li:last-child').remove();
		$('#myModal').fadeOut();
		
		notifCheck(currentDate.find('.tasks'));
		
		openPanel = false;
		
		e.preventDefault();
		return false;
	});
	win.on('click', '.edit-close, .account-close', function(e){	
		$('#myModal').fadeOut();
		notifCheck(currentDate.find('.tasks'));
		openPanel = false;
		
		e.preventDefault();
		return false;
	});
	
	
	/* ========================= SUBMIT NEW TASK */
	win.on('submit', '#addTask', function(e){	
		currentEvent = currentDate.find('li:last-child');
		currentEvent.removeClass('newEvent');
		
		var taskName = $('input[name="title"]');
		var status = $('select');
		var desc = $('textarea');
		var date = $(currentDate).attr("data-date");

		var trimTaskName = taskName.val().trim();
		var trimDesc = desc.val().trim();

		if(trimTaskName.length < 20){
			currentEvent.text(trimTaskName);
		}else{
			var truncated = '';
		
			for(var i = 0, max = 15; i < max; i++ ){
				truncated += trimTaskName[i]
			};
			
			truncated = truncated.trim();
			truncated += '...';
			currentEvent.text(truncated);
		}

		if(status.val() === 'Urgent'){
			currentEvent.removeClass('green-up').addClass('red-up urgent');
		}else if(status.val() === 'Finished'){
			currentEvent.removeClass('green-up').addClass('blackbar finished');
		}else if(status.val() === 'Delayed'){
			currentEvent.removeClass('green-up').addClass('delayed khakibar');
		};
		
		if(trimTaskName === ''){
			taskName
				.parent()
				.find('span')
				.css('display', 'block')
				.text('Please fill out event title.')
			;
		}else{
			$('#myModal').fadeOut();
			openPanel = false;
		}
		
 		addTask(trimTaskName, status.val(), trimDesc, date);
						
		e.preventDefault();
		return false;
	});


	/* ========================= EDIT TASK */
	win.on('submit', '#editEvent', function(e){
		var taskName = $('input[name="title"]');
		var status = $('select');
		var desc = $('textarea');
		var date = $(currentDate).attr("data-date");

		var trimTaskName = taskName.val().trim();
		var trimDesc = desc.val().trim();

		if(trimTaskName.length < 20){
			currentEvent.text(trimTaskName);
		}else{
			var truncated = '';
		
			for(var i = 0, max = 15; i < max; i++ ){
				truncated += trimTaskName[i]
			};
			truncated = truncated.trim();
			truncated += '...';
			currentEvent.text(truncated);
		}
		
		if(status.val() === 'Urgent'){
			currentEvent.removeClass().addClass('red-up urgent');
		}else if(status.val() === 'Finished'){
			currentEvent.removeClass().addClass('blackbar finished');
		}else if(status.val() === 'Delayed'){
			currentEvent.removeClass().addClass('delayed khakibar');
		};
		
		if(trimTaskName === ''){
			taskName
				.parent()
				.find('span')
				.css('display', 'block')
				.text('Please fill out event title.')
			;
		}else{
			currentInfo.taskName = trimTaskName;
			currentInfo.status = status.val();
			currentInfo.taskDescription = trimDesc;
						
			updateTask();
			$('#myModal').fadeOut();
		}
		
		openPanel = false;
		
		e.preventDefault();
		return false;
	});


	/* ========================= DELETE EVENT */
	win.on('click', '.edit-delete', function(e){
		var taskID = currentEvent.attr('data-id');
		
		deleteTask(taskID);
		
		var safeKeeping = currentEvent.parent();		
	
		currentEvent.remove();
		$('#myModal').fadeOut();
				
		notifCheck(safeKeeping);
				
 		getTasks();
		openPanel = false;
		
		e.preventDefault();
		return false;
	});

	
	/* ========================= CHARACTERS LEFT EVENT */
	win.on('keyup', '.panel input, .panel textarea', function(e){
		var targetThing = $(this);
		var maxChars = targetThing.attr('maxlength');
		var textLength = targetThing.val().length;
		var lettersLeft = maxChars - textLength;
						
		if(targetThing.val() === ''){
			targetThing
				.parent()
				.find('span')
				.hide()
			;
		}else{
			targetThing
				.removeClass('prefocus')
				.parent()
				.find('span')
				.css('display', 'block')
				.text('You have '+ lettersLeft +' characters left.')
			;
		}		
	});

	
	/* ========================= LOGOUT */
	win.on('click', '#userLogout', function(e){
		logout();
		
		e.preventDefault();
		return false;
	});

	
	/* ========================= EVENT CLICK */
	win.on('click', '#days li', function(e){
		currentEvent = $(this);
		
		var check = currentEvent.parent().hasClass('overTasked');
		
		if(!check){
			$('.overTasked').fadeOut();
		};		
		
		var currentID = currentEvent.attr('data-id');
		var title = '';
		var description = '[No current description]';
		
	// Finds and sets the currentInfo to the selected task by...
	// ...finding the task by it's DATA-ID number.	
		$.each(tasks, function(i, value){		
			if(value.id === currentID){
				currentInfo = value;
				return false;
			};
		});
				
		if(currentInfo.taskName.length < 20){
			title = currentInfo.taskName;
		}else{
			var truncated = '';
		
			for(var i = 0, max = 15; i < max; i++ ){
				truncated += currentInfo.taskName[i];
			};
			
			truncated = truncated.trim();
			truncated += '...';
			title = truncated;
		}
		
		if(currentInfo.taskDescription){
			description = currentInfo.taskDescription;
		}
				
		//this is the max for the title
		var tipWindow = $('.infoTip');
		var thing = '<div class="infoTip">'+
			'<h5 class="blackbar">'+ title +'</h5><p>'+ description +'</p>'+
			'<div><button class="khakibar edit-btn">Edit</button><button class="green-up done-btn">Done</button>'+
			'</div></div>';
		
		if(tipWindow.length > 0){
			$('.infoTip').remove();
			$(this).append(thing);
		}else{
			$(this).append(thing);			
		}
		
		openPanel = true;
		
		return false;
	});


	/* ========================= TOOL TIP DONE */
	win.on('click', '.done-btn', function(e){
		$('.infoTip').fadeOut();
		openPanel = false;
		return false;
	});


	/* ========================= TOOL TIP EDIT */
	win.on('click', '.edit-btn', function(e){
		$('.infoTip').fadeOut();
		$('.overTasked').fadeOut();
		loadEdit();
		openPanel = true;
		return false;
	});
	
	
	/* ========================= PREVIOUS MONTH */
	win.on('click', '.prev', function(e){
		currentMonthValue--;
		
		changeMonth();
		
		e.preventDefault();
		return false;
	});
	
	
	/* ========================= NEXT MONTH */
	win.on('click', '.next', function(e){
		currentMonthValue++;
		
		changeMonth();
		
		e.preventDefault();
		return false;
	});
	
	
	/* ========================== ARROW THROUGH CALENDAR */
	win.on('keyup', this, function(e){
		
		if(e.keyCode === 39 && !openPanel){
			currentMonthValue++;
			changeMonth();
		}else if(e.keyCode === 37 && !openPanel){
			currentMonthValue--;
			changeMonth();
		}else if(e.keyCode === 27){
			$('#myModal').fadeOut();
			$('.newEvent').remove();
		};
		
	});
	
	
	/* ========================= NOTIFICATION */
	win.on('click', '.notif a', function(e){
		$('.infoTip').fadeOut();
		$('.overTasked').fadeOut();

		var listHolder = $(this).parent().parent();
		
		listHolder.find('.tasks').addClass('overTasked').fadeIn();
		
		e.preventDefault();
		return false;
	});
	
	win.on('click', function(){
		$('.overTasked').fadeOut();
	});
	
	
	/*	
	==================================== END EVENTS 
	===============================================
	*/
		
		

	
})(jQuery); // end private scope




