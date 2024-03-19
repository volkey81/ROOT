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
    $('body').css('overflow','hidden');
    $('.popup_g').show();
    $('.popup_wrap').hide();
    $('.popup_wrap#' + popId).show();
}
function popupClose(){
    $('.popup_g').hide();
    $('body').css('overflow','auto');
}
$(".dim_g").click(function(){
    $('.popup_g').hide();
    $('body').css('overflow','auto');
});
function checkNumber(event) {
    if(event.key === '.' 
       || event.key === '-'
       || event.key >= 0 && event.key <= 9) {
      return true;
    }
    
    return false;
}