<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				 com.efusioni.stone.utils.*,
				 com.sanghafarm.common.*,
				 com.sanghafarm.utils.*,
				 com.sanghafarm.service.order.*,
				 org.json.simple.*" %>
<%
	Param param = new Param(request);
	String message = param.get("message");
	
	JSONObject json = (JSONObject)JSONValue.parse(message);
	
	String orderid = (String) json.get("ETC1");
	
	System.out.println("--------------- orderid : " + orderid);
	System.out.println("--------------- message : " + message);
	
	if(orderid == null || "".equals(orderid)) {
		System.out.println("++++++++++++ parameter orderid is null !!!");
		Utils.sendMessage(out, "세션이 만료 되었거나 유효하지 않은 요청 입니다.", "/");
		return;
	}
	
	OrderService svc = (new OrderService()).toProxyInstance();
	Param info = svc.getOrderFormInfo(orderid);
	
	if(info == null || "".equals(info.get("orderid"))) {
		System.out.println("++++++++++++ order form is null !!!");
		Utils.sendMessage(out, "세션이 만료 되었거나 유효하지 않은 요청 입니다.", "/");
		return;
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="UTF-8" lang="UTF-8">
<head>
<title>SmilePay 결제 응답 샘플 페이지</title>
<meta http-equiv="cache-control" content="no-cache"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="content-type" content="text/html; charset=euc-kr" />

<script src="/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript">
	window.onload = function (){
		var message = '<%=message %>'; 
		
		if(validResult(message)){
			var obj = JSON.parse(message);

			$("input[name=merchantTxnNum]").val(obj.MerchantTxnNum);
			$("input[name=SPU]").val(obj.SPU);
			$("input[name=SPU_SIGN_TOKEN]").val(obj.SPU_SIGN_TOKEN);
			$("#LGD_PAYINFO").submit();
		}else{
			alert("결제가 취소되었습니다.");
			//페이지 이동 등의 후 처리가 필요하면 이 곳에 추가
		}
	}
	
	//message에 대한 유효성 검증
	function validResult(message){
		if(message == null || message == ""){
			return;
		}else{
			var data = JSON.parse(message);
			if(data == null){
				return;
			}else{
				//0001은 CNS 내부 처리 실패, 0002는 고객이 스마일페이 결제창에서 닫기 버튼을 누를 경우 
				if(data.resultCode == '0001' || data.resultCode == '0002'){
					return;
				}else{
					if(data.SPU != null && data.SPU_SIGN_TOKEN != null){
						return true;
					}else{
						return;
					}
				}
			}
		}
	}
	
	function makeReqForm(form, name, value){
		var input = form.appendChild(document.createElement("input"));
		input.type = 'hidden';
		input.name = name;
		input.value = value;
		form.appendChild(input);
	}
</script>
</head>
<body>
<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO" action="<%= Env.getSSLPath() %>/order/orderProc.jsp">
<%= info.get("form") %>
</form>

</body>
</html>