$(document).ready(function(){
    const wrap = document.getElementsByClassName('body_wrap')[0]; // 보일 영역
    const container = document.getElementsByClassName('section_wrap');
    let page = 0; // 영역 포지션 초기값
    const lastPage = container.length - 1; // 마지막 페이지

    wrap.style.top = 0;

    setTimeout(
    window.addEventListener('wheel',(e)=>{
        e.preventDefault();
        if(e.deltaY > 0){
            page++;
        }else if(e.deltaY < 0){
            page--;
        }
        if(page < 0){
            page=0;
        }else if(page > lastPage){
            page = lastPage;
        }
        console.log(e.deltaY)
        if(page == lastPage -1 && e.deltaY > 0){
            wrap.style.top = calc(((page -1) * -100 + 'vh') + '208px');
        }else if(page == lastPage && e.deltaY < 0){
            wrap.style.top = calc((page * -100 + 'vh') - '208px');
        }else{
            wrap.style.top = page * -100 + 'vh';
        }
    },{passive:false}), 1000); // 디폴트 기능 제거 - 스크롤
});