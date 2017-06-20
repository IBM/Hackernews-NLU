// Empty JS for your own code to be here
var apiUrl = window.location;
//var apiUrl= 'http://localhost:8080/update'
$(function(){
   initData();
});
function initData() {
  console.log("apiUrl: " + apiUrl)
  $("#loader_section").show()
  $("#section_one").hide();
  $("#section_two").hide();
  $.get(apiUrl+'update?path=/v0/topstories.json', function(data) {
        var parsed = JSON.parse(data);
        $('#news_articles > tr').remove();
        for (var i = 0; i < parsed.length; i++) {
          $('<tr>').html("<td id='" + parsed[i].id + "'>" + parsed[i].title + "</td>").appendTo('#news_articles');
        }
        $("#loader_section").hide()
        $("#section_one").show();
    });
}

$(document).on("click", "#news_articles td", function(e) {
    $("#section_one").hide();
    $("#loader_section").show()
    var data = $(this).attr('id');
    var title="Article \""+$(this).text()+"\" analysis";
    var url=window.location+'analyse?articleid='+data
    console.log("apiUrl: " + url)
    $.get(url, function(data) {
          $("#articleTitle").text(title)
          console.log(data);
          $("#url").empty().html('<strong>Article Url:  <strong><a  href="'+data.retrieved_url+'" target="blank">'+data.retrieved_url+'</a>');
          //$("#urlValue").text(data.retrieved_url);
          $('#concepts tbody').remove();
          $('#categories tbody').remove();
          $('#emotion tbody').remove();
          $('#entities tbody').remove();
          $('#keywords tbody').remove();
          $('a[href="#menu1"]').click();
          var parsed = data.concepts;
          for (var i = 0; i < parsed.length; i++) {
            $('<tr>').html("<td class='tdcolor'>" + parsed[i].text + "</td> <td>" + Number(parsed[i].relevance).toFixed(2) + "</td>").appendTo('#concepts');
          }
          parsed = data.categories;
          for (var i = 0; i < parsed.length; i++) {
            $('<tr>').html("<td class='tdcolor'>" + parsed[i].label + "</td> <td>" + Number(parsed[i].score).toFixed(2) + "</td>").appendTo('#categories');
          }
          parsed = data.emotion.document.emotion;
          for (var key in parsed) {
            $('<tr>').html("<td class='tdcolor'>" + key + "</td> <td>" + Number(parsed[key]).toFixed(2) + "</td>").appendTo('#emotion');
          }
          $('#sentiment').text(data.sentiment.document.label+"[ "+Number(data.sentiment.document.score).toFixed(2) +" ]");
          parsed = data.entities;
          for (var i = 0; i < parsed.length; i++) {
            $('<tr>').html("<td class='tdcolor'>" + parsed[i].text+"</td> <td>" + parsed[i].type + "</td><td>"+Number(parsed[i].relevance).toFixed(2)+"</td>").appendTo('#entities');
          }
          parsed = data.keywords;
          for (var i = 0; i < parsed.length; i++) {
            $('<tr>').html("<td class='tdcolor'>" + parsed[i].text + "</td> <td>" + Number(parsed[i].relevance).toFixed(2) + "</td>").appendTo('#keywords');
          }
          $("#loader_section").hide()
          $("#section_two").show();

      })
      .fail(function() {
          //alert("Problem with article url. Please try another article!")
          $("#error_modal").modal()
          $("#loader_section").hide()
          $("#section_one").show();
      });

});

$("#home").click(function () {
  $("#loader_section").hide()
  $("#section_one").show();
  $("#section_two").hide();
});
