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