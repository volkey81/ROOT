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