/**
 * Created by ermacaz on 4/22/14.
 */

$(document).ready(function() {
    $("select#appointment_clinic_id").change(function() {
        var pathname = window.location.pathname;
        var p = new RegExp('((?:[a-z][a-z]+))(-).*?(?:[a-z][a-z]+)(-?)([0-9]?)', ["i"]);
        var m = p.exec(pathname);
        if ( m != null)
        {
            var patient_slug = m[0];
        }
        var requestUrl = 'https://www.mdme.us/patients/' + patient_slug + '/clinics/getdoctors';
        $.ajax({
            type: "GET",
            url: requestUrl,
            dataType: 'json',
            timeout: 5000,
            data: { 'clinic': $("select#appointment_clinic_id").find(":selected").text(),
                    'token':  $("#token").val() },
            success: function(data) {
                var $select = $('select#appointment_doctor_id');
                $select.find('option').remove();
                var n = 1;
                $.each(data.doctors, function(value) {
                    $select.append('<option value=' + n + '>' + data.doctors[value] + '</option>');
                    n = n + 1;
                })
            },
            error: function() {
                alert('error');
            }
        })
    });

    $("input#appointment_date").change(function() {
//        var pathname = window.location.pathname;
//        var p = new RegExp('((?:[a-z][a-z]+))(-).*?(?:[a-z][a-z]+)(-?)([0-9]?)', ["i"]);
//        var m = p.exec(pathname);
//        if ( m != null)
//        {
//            var patient_slug = m[0];
//        }
//        var requestUrl = 'http://www.mdme.tk:3000/patients/' + patient_slug + '/appointments/browse';
        //error occruing on www vs admin
        var pathname = document.URL;
        var p = new RegExp('(\/\/)((?:[a-z][a-z]+))', ["i"]);
        var m = p.exec(pathname);
        if (m != null)
        {
            var subdomain = m[0].substring(2);
        }
        var requestUrl = 'https://' + subdomain +'.mdme.us/doctors/opentimes';
        var clinic_id = $('#clinic_id').val();
        $.ajax({
            type: "GET",
            url: requestUrl,
            timeout: 5000,
            dataType: 'text',
            data: { 'appointment': {'clinic_name': $("select#appointment_clinic_id").find(":selected").text(),
                                    'doctor_full_name': $('select#appointment_doctor_id').find(":selected").text(),
                                    'date': $('input#appointment_date').val(),
                                    'clinic_id': clinic_id}},
            crossDomain: true,
            success: function(data) {
                data = JSON.parse(data);
                var $select = $('select#date_time');
                $select.find('option').remove();
                var n = 1;
                $.each(data.open_times, function(value) {
                    $select.append('<option value=' + n + '>' + data.open_times[value] + '</option>');
                    n = n+1
                })
            },
            error: function(jqXHR, textStatus, errorThrown) {
                alert(textStatus + " " + errorThrown);
            }
        })
    })
});

