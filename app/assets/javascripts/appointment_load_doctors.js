/**
 * Created by ermacaz on 4/22/14.
 */

$(document).ready(function() {
    $("select#appointment_clinic_id").change(function() {
        $.ajax({
            type: "GET",
            url: 'http://www.mdme.tk:3000/clinics/getdoctors',
            dataType: 'json',
            timeout: 5000,
            data: { 'clinic': $("select#appointment_clinic_id").find(":selected").text() },
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
});

