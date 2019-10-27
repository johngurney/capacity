// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

function file_field_tag_browse_click(id){
   var fileVal=document.getElementById(id + "file-upload");
   if (fileVal.value != "") {
     var name = fileVal.value.split('\\').pop().split('/').pop();
     document.getElementById(id + "file_field_path_label").innerHTML = name;
     document.getElementById(id + "file_field_path_div").style.display = "inline-flex";
     document.getElementById(id + "file_field_upload").style.display = "block";
   } else {
     document.getElementById(id + "file_field_path_label").innerHTML = "";
     document.getElementById(id + "file_field_path_div").style.display = "none";
     document.getElementById(id + "file_field_upload").style.display = "none";
     }
  }
