function popupOpen(popId,expCon){
    if(expCon != null){
        document.getElementById('expCon_PC').src = './image/' + expCon + '_PC.jpg';
        document.getElementById('expCon_MO').src = './image/' + expCon + '_MO.jpg';
    }
    if(popId == 'allMenu'){
        $('.popup_g').addClass('popup_allmenu');
        $('.dim_g').hide();
    }
    $('.popup_g').show();
    $('.popup_wrap').hide();
    $('.popup_wrap#' + popId).show();
}
function popupClose(){
    $('.popup_g').hide();
    $('.popup_g').removeClass('popup_allmenu');
    $('.dim_g').show();
}
$(".dim_g").click(function(){
    alert('test');
    $('.popup_g').hide();
    $('.popup_g').removeClass('popup_allmenu');
    $('.dim_g').show();
});