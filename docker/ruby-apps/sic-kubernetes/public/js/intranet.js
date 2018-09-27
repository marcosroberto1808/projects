(function($){
	$('input, select, textarea').addClass('form-control');
	$('input[type="submit"], input[type="button"], input[type="reset"], input[type="radio"], input[type="checkbox"]').removeClass('form-control');
	$('input[type="submit"], input[type="button"], input[type="reset"]').addClass('btn');
	$('table').addClass('table table-bordered table-hover table-striped');
	$('.switch-display').change(function(){
		var elemento = $(this).attr('data-elemento');
		var show = $(this).val();
		$(elemento).hide('fast');
		$(show).show('fast');
	});

	$('.switch-element').click(function(){
		var elemento = $(this).attr('data-elemento');
		var estado = $(elemento).attr('data-display');
		if (estado == 'true'){
			$(elemento).attr('data-display', 'false');
			$(elemento).hide('fast');
		}else{
			$(elemento).attr('data-display', 'true');
			$(elemento).show('fast');
		}
	});

	$('.dropdown').mouseover(function(){
		var estado = $(this).find('.dropdown-toggle').attr('aria-expanded');
		if (estado == 'true'){
			$(this).find('.dropdown-toggle').attr('aria-expanded',false);
			$(this).removeClass('open');
		}else{
			$(this).find('.dropdown-toggle').attr('aria-expanded',true);
			$(this).addClass('open');
		}
	}).mouseout(function(){
		var estado = $(this).find('.dropdown-toggle').attr('aria-expanded');
		if (estado == 'true'){
			$(this).find('.dropdown-toggle').attr('aria-expanded',false);
			$(this).removeClass('open');
		}else{
			$(this).find('.dropdown-toggle').attr('aria-expanded',true);
			$(this).addClass('open');
		}
	});

})(jQuery)