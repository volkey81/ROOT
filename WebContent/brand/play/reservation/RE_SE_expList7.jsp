<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*,
            java.text.*,
            com.efusioni.stone.common.*,
            com.efusioni.stone.utils.*,
            com.sanghafarm.common.*,
            com.sanghafarm.service.board.*,
            com.sanghafarm.service.code.*,
            com.sanghafarm.service.product.*,
            com.sanghafarm.utils.*" %>
<%
    class HTMLUtil {
        public static String generateTicketInput(Param row, int remain) {
            StringBuilder html = new StringBuilder();
            String expPid = row.get("exp_pid");
            String ticketType = row.get("ticket_type");
            String ticketName = row.get("ticket_name");
            String price = row.get("price");
            String formattedPrice = NumberFormat.getInstance().format(Integer.parseInt(price));
            
            html.append("<div class='ticket'>")
                .append("<div class='ticket-info'>")
                .append("<span class='ticket-name'>" + ticketName + "</span>")
                .append("<span class='ticket-price'>" + formattedPrice + "원</span>")
                .append("</div>")
                .append("<div class='quantity-selector'>")
                .append("<button type='button' onclick=\"setQty('down', '" + expPid + "', '" + ticketType + "')\">-</button>")
                .append("<input type='text' name='quantity_" + expPid + "_" + ticketType + "' value='0' readonly>")
                .append("<button type='button' onclick=\"setQty('up', '" + expPid + "', '" + ticketType + "')\">+</button>")
                .append("</div>")
                .append("</div>");
            
            return html.toString();
        }
    }

    Param param = new Param(request);
    ExpProductService svc = new ExpProductService().toProxyInstance();
    List<Param> list = svc.getSelProductList(param);

    String previousExpId = "";
%>
<%@ page import="java.util.List" %>
<%@ page import="com.sanghafarm.service.product.ExpProductService" %>
<%@ page import="com.efusioni.stone.common.Param" %>

<% for (Param row : list) {
    String expPid = row.get("exp_pid");
    if (!expPid.equals(previousExpId)) {
        if (!previousExpId.isEmpty()) {
            out.println("</div>");
        }
        
        out.println("<div class='product'>");
        out.println("<h2>Product: " + row.get("exp_type_name") + "</h2>");
    }

    int remain = row.getInt("seat_num") - row.getInt("reserved_num");
    
    out.println(HTMLUtil.generateTicketInput(row, remain));

    previousExpId = expPid;
}
if (!previousExpId.isEmpty()) {
    out.println("</div>");
}
%>
