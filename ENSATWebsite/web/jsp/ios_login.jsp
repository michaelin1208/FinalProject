<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=utf-8"%>
<%@page import="java.sql.*"%>
<jsp:useBean id='usercheck' class='security.UserCheck'  scope='session'/>
<jsp:useBean id='connect' class='ConnectBean.ConnectBean' scope='session'/>
<%
Connection con;
Statement sql;
ResultSet rs;
String emailUsername = request.getParameter("username");
String password = request.getParameter("password");
if(emailUsername!=null&&password!=null){
Connection secConn = connect.getSecConnection();
/**
 * responseFlag:
 * 
 * 0 = user present, account active, membership up-to-date (OK login)
 * 1 = user not present (i.e. credentials are wrong)
 * 2 = user present, account not active
 * 3 = user present, account active, membership out-of-date
 */
    int responseFlag = 1; //Default is the no-credentials option
    responseFlag = usercheck.checkUserDetails(emailUsername,password,"ensat_security","localhost","root","",secConn);
    if(responseFlag == 0){
        /* if all correct, return the center id */
        String centerID = "";
        try{Class.forName("com.mysql.jdbc.Driver").newInstance();}
        catch(Exception e){out.print(e);}
        try{
            String uri="jdbc:mysql://localhost:3306/ensat_security";
            con=DriverManager.getConnection(uri,"root","");
            sql=con.createStatement();
            rs=sql.executeQuery("SELECT center FROM user where email_address = '"+emailUsername+"'");
            if(rs.next()){
                centerID = rs.getString("center");
            }
            con.close();
        }
        catch(SQLException e1){out.print(e1);}
        
        JSONObject result = new JSONObject();
        result.put("type", "ios_login");
        result.put("centerID", centerID);
        result.put("result", ""+responseFlag);
        out.print(result.toString());
    }else{
        JSONObject result = new JSONObject();
        result.put("type", "ios_login");
        result.put("result", ""+responseFlag);
        out.print(result.toString());
    }
}else{
    JSONObject result = new JSONObject();
    result.put("type", "ios_login");
    result.put("result", "-1");
    out.print(result.toString());
}
%>