$(document).ready(function(){
    $('#trellotable').DataTable({
       "iDisplayLength": 100,
       "aaSorting": [[ 4, "asc" ]]
    });
});