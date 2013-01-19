$(function() {

  $.validator.addMethod(
    "dateFormat",
    function (value, element) {
      return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
    },
    "Please enter a date in the format mm/dd/yyyy"
  );

  $.validator.addMethod(
    "datePrecedence",
    function (value, element, elements) {
      var otherElement = null;
      if(elements[0] === $(element).attr('id')) {
        otherElement = elements[1];
      } else {
        otherElement = elements[0];
      }

      var value1 = $.trim($('#' + elements[0]).val());
      var value2 = $.trim($('#' + elements[1]).val());

      if(value1.length > 0 && value2.length > 0) {
        value1 = new Date(value1);
        value2 = new Date(value2);

        return value1 < value2;
      } else {
        return false;
      }
    },
    ""
  );

  $.validator.addMethod(
    "mp3Ext",
    function (value, element) {
      var value = value.split('.').pop().toLowerCase();
      return value === 'mp3';
    },
    "Music file must be in mp3 format."
  );

  // display confirm message on delete
  $('.delete-action').click(function(e) {
    var confirmMessage = $(this).data('confirm');
    var result = confirm(confirmMessage);
    if(result != true) {
      e.preventDefault();
    }
  });

  // validate registration form
  if($('#register-form').length) {
    $('#register-form').validate({
      debug: true,
      submitHandler: function(form) {
        form.submit();
      },
      rules: {
        'first_name': {required: true, maxlength: 40},
        'last_name': {required: true, maxlength: 40},
        'username': {required: true, maxlength: 40},
        'email': {required: true, email: true},
        'password': {required: true, minlength: 6, maxlength: 40}
      },
      errorPlacement: function(error, element) {
        element.closest('div').parent().addClass('error');
        error.appendTo(element.closest('div').find('.help-block')[0]);
      },
      success: function(label) {
        label.closest('div').parent().removeClass('error');
      }
    });
  }

  // validate venue form
  if($('#venue-form').length) {
    $('#venue-form').validate({
      debug: true,
      submitHandler: function(form) {
        form.submit();
      },
      rules: {
        'name': {required: true, maxlength: 40},
        'street': {required: true, maxlength: 40},
        'city': {required: true, maxlength: 40},
        'state': {required: true, minlength: 2, maxlength: 2},
        'zip': {required: true}
      },
      errorPlacement: function(error, element) {
        element.closest('div').parent().addClass('error');
        error.appendTo(element.closest('div').find('.help-block')[0]);
      },
      success: function(label) {
        label.closest('div').parent().removeClass('error');
      }
    });
  }  

  // validate show form
  if($('#show-form').length) {
    $('#show-form').validate({
      debug: true,
      submitHandler: function(form) {
        form.submit();
      },
      rules: {
        'venue_id': {required: true},
        'voting_start_date': {required: true, dateFormat: true},
        'voting_end_date': {required: true, dateFormat: true, datePrecedence: ['voting_start_date', 'voting_end_date']},
        'show_date': {required: true, dateFormat: true, datePrecedence: ['voting_end_date', 'show_date']}
      },
      messages: {
        'voting_end_date': {
          datePrecedence: 'Voting End Date must come after Voting Start Date'
        },
        'show_date': {
          datePrecedence: 'Show Date must come after Voting End Date'
        }
      },
      errorPlacement: function(error, element) {
        element.closest('div').parent().addClass('error');
        error.appendTo(element.closest('div').find('.help-block')[0]);
      },
      success: function(label) {
        label.closest('div').parent().removeClass('error');
      }
    });
  }

  // validate band form
  if($('#band-form').length) {
    $('#band-form').validate({
      debug: true,
      submitHandler: function(form) {
        form.submit();
      },
      rules: {
        'name': {required: true, maxlength: 40},
        'website': {required: false, maxlength: 40},
        'biography': {required: false, maxlength: 1500}
      },
      errorPlacement: function(error, element) {
        element.closest('div').parent().addClass('error');
        error.appendTo(element.closest('div').find('.help-block')[0]);
      },
      success: function(label) {
        label.closest('div').parent().removeClass('error');
      }
    });
  }

  // validate band member form
  $('.band-member-form').each(function() {
    var form = $(this);
    form.validate({
      debug: true,
      submitHandler: function(form) {
        form.submit();
      },
      rules: {
        'name': {required: true, maxlength: 40},
        'instrument': {required: true, maxlength: 40}
      },
      errorPlacement: function(error, element) {
        element.closest('div').parent().addClass('error');
        error.appendTo(element.closest('div').find('.help-block')[0]);
      },
      success: function(label) {
        label.closest('div').parent().removeClass('error');
      }
    });
  });

  // validate music file form
  if($('#music-file-form').length) {
    $('#music-file-form').validate({
      debug: true,
      submitHandler: function(form) {
        form.submit();
      },
      rules: {
        'title': {required: true, maxlength: 40},
        'upload_file': {required: true, mp3Ext: true}
      },
      errorPlacement: function(error, element) {
        element.closest('div').parent().addClass('error');
        error.appendTo(element.closest('div').find('.help-block')[0]);
      },
      success: function(label) {
        label.closest('div').parent().removeClass('error');
      }
    });
  }

});
