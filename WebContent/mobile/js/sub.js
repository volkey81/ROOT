function checkAll(targetId,groupId){
    var selectall 
        = document.querySelector('input[name="'+targetId+'"]');
    var checkboxes 
        = document.getElementsByName(groupId);
    
    if(selectall.checked == false){
        checkboxes.forEach((checkbox) => {
            checkbox.checked = true;
        })
    }else{
        checkboxes.forEach((checkbox) => {
            checkbox.checked = false;
        })
    }
}
function popupOpen(popId,expCon){
    if(expCon != null){
        document.getElementById('expCon_PC').src = './image/' + expCon + '_PC.jpg';
        document.getElementById('expCon_MO').src = './image/' + expCon + '_MO.jpg';
    }
    if(popId == 'allMenu'){
        $('.popup_g').addClass('popup_allmenu');
        $('.dim_g').hide();
    }
    $('body').css('overflow','hidden');
    $('.popup_g').show();
    $('.popup_wrap').hide();
    $('.popup_wrap#' + popId).show();
}
function popupClose(){
    $('body').css('overflow','auto');
    $('.popup_g').hide();
    $('.popup_g').removeClass('popup_allmenu');
    $('.dim_g').show();
}
$(".dim_g").click(function(){
    $('body').css('overflow','auto');
    $('.popup_g').hide();
    $('.popup_g').removeClass('popup_allmenu');
    $('.dim_g').show();
});
function checkNumber(event) {
    if(event.key === '.' 
       || event.key === '-'
       || event.key >= 0 && event.key <= 9) {
      return true;
    }
    
    return false;
}

$(function(){
    $(document).on("click", "input[type=checkbox]", function(e) {
        var targetName = $(this).attr("name");
        var targetId = $(this).attr("id");
        var targetchecked = $("input:checkbox[name=" + targetName + "]:checked").length;
        var targetState = document.querySelector("#" + targetId).checked;

        if(targetchecked > 0){
            $("input:checkbox[name='" + targetName + "']").prop('checked', false);
            $("input:checkbox[id='" + targetId + "']").prop('checked', true);
        }else if(targetState == true){
            $("input:checkbox[name='" + targetName + "']").prop('checked', false);
        }
    });
});