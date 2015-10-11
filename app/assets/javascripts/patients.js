$(document).on('ready page:change', function() {
  function updateCounter() {
    var hiddenMinutesField = $('#appointment_time_left');
    minutesLeft = parseInt(hiddenMinutesField.val());
    minutesLeft = minutesLeft - 1;
    var percent = 120 - minutesLeft;
    var color;
    if (minutesLeft > 25) {
      color = 'info';
    }else if (minutesLeft <= 25 && minutesLeft > 5) {
      color = 'warning'
    } else {
      color = 'danger';
    }
    hiddenMinutesField.val(minutesLeft);
    var text;
    if (minutesLeft > 0 && minutesLeft <= 120) {
      text = (minutesLeft == 1 ?
        (minutesLeft + ' minute until appointment') :
        (minutesLeft + ' minutes until appointment'));
    } else {
      text = '';
    }
    $('#appointment-progress-text').text(text);
    $('#appointment-progress-bar').html(
      '<progress class="progress progress-striped progress-' + color +'" value="' + percent + '" max="120"></progress>'
    );
  }
  if ($('progress').length != 0) {
    updateCounter();
    if (minutesLeft != 'undefined' && minutesLeft >= 0) {
      setInterval(updateCounter, 60000);
    }
  }
});


