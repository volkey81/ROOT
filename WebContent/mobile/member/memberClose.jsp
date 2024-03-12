<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.util.*,
			com.efusioni.stone.utils.*,
			com.sanghafarm.common.*,
			com.sanghafarm.utils.*,
			com.sanghafarm.service.board.*" %>
<script>
$(function() {
	if(!(window.opener && window.opener !== window)) {
		$(".popClose").show();
	}
});
</script>
<a href="javascript:history.back()" class="popClose" style="display:none"><img src="/mobile/images/btn/btn_close3.png" alt="" /></a>		
