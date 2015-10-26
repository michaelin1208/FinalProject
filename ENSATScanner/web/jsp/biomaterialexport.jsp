
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" import="java.util.*,java.sql.*,org.apache.log4j.*" pageEncoding="ISO-8859-1"%>

<jsp:include page="/jsp/page/check_credentials.jsp" />
<jsp:include page="/jsp/page/check_input.jsp" />
<jsp:include page="/jsp/page/page_head.jsp" />
<%
    String section=request.getParameter("section");
%>
<td colspan="2" width="81%" align="left" valign="top" background="/images/possbk.jpg"><table width="1200" border="0" cellspacing="0" cellpadding="10"> 
      <tr> 
        <td width="15" align="left" valign="top">&nbsp;</td> 
        <td align="left" valign="top"><!-- #BeginEditable "MainText" --> 

<jsp:include page="/jsp/page/page_nav.jsp" />

<jsp:useBean id='connect' class='ConnectBean.ConnectBean' scope='session'/>
<jsp:useBean id='presentation' class='summaryinfo.SummaryInfo' scope='session'/>
<jsp:useBean id='user' class='user.UserBean'  scope='session'/>


<%
    //Moving Github on
ServletContext context = getServletContext() ;  
//Logging configuration
String log4jConfigFile = context.getInitParameter("log4j_property_file");
Logger logger = Logger.getLogger("rootLogger");
logger.setLevel(Level.DEBUG);
PropertyConfigurator.configure(log4jConfigFile);

//This is the initial setting up of the connections that will be used from now on in the session
Connection conn = connect.getConnection();
Connection secConn = connect.getSecConnection();
Connection paramConn = connect.getParamConnection();
Connection ccConn = connect.getCcConnection();

connect.setConnections(context,conn,secConn,paramConn,ccConn);
conn = connect.getConnection();
secConn = connect.getSecConnection();
paramConn = connect.getParamConnection();
ccConn = connect.getCcConnection();
if(conn == null){
    logger.debug("conn is null...");
}

String[] ensatSections = {"ACC","Pheo","NAPACA","APA",""};


    
Vector<String> centerCodes = new Vector<String>();

//Set logfile parameter in any auxiliary classes here
presentation.setLogfileName(log4jConfigFile);
        
String username = user.getUsername();
logger.debug("section "+section);

String userCenter = user.getCenter();
int i = 0;
%>
<form name="form1" method="post" action="/ENSAT/jsp/biomaterialexportprocess.jsp" >
<table width="900" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td>ENSAT-ID</td>
    <td>Conn-ID</td>
    <td>bio-ID</td>
    <td>date</td>
    <td>material</td>
    <td>aliquot</td>
    <td>Freezer</td>
    <td>F-Shelf</td>
    <td>Rack</td>
    <td>R-Shelf</td>
    <td>Box</td>
    <td>Pos</td>
    <td>Select</td>
  </tr>
  <%
Connection con;
Statement sql;
ResultSet rs;
ResultSet rs2;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
try{Class.forName("com.mysql.jdbc.Driver").newInstance();}
catch(Exception e){out.print(e);}
try{
    String uri="jdbc:mysql://localhost:3306/center_callout";
    con=DriverManager.getConnection(uri,"root","");
    sql=con.createStatement();
    
    //Get the destination center list here
    rs=sql.executeQuery("SELECT DISTINCT center_id FROM Center_Callout ORDER BY center_id;");
    while(rs.next()){
        String centerIn = rs.getString(1);
        if (centerIn == null) {
            centerIn = "";
        }
        if (!centerIn.equals("")) {
            centerCodes.add(centerIn);
        }
    }
    
    uri="jdbc:mysql://localhost:3306/ensat_v3";
    con=DriverManager.getConnection(uri,"root","");
    sql=con.createStatement();
    //get the details of stored biomaterials in this section 
    rs=sql.executeQuery("select * from "+section+"_Biomaterial_Freezer_Information join "+section+"_Biomaterial where ("+section+"_Biomaterial_Freezer_Information.center_id = \""+userCenter+"\" or "+section+"_Biomaterial_Freezer_Information.material_transferred =\""+userCenter+"\") and "+section+"_Biomaterial_Freezer_Information.material_used = 'No' and "+section+"_Biomaterial_Freezer_Information."+section.toLowerCase()+"_biomaterial_id = "+section+"_Biomaterial."+section.toLowerCase()+"_biomaterial_id and "+section+"_Biomaterial_Freezer_Information.ensat_id = "+section+"_Biomaterial.ensat_id and "+section+"_Biomaterial_Freezer_Information.center_id = "+section+"_Biomaterial.center_id  and "+section+"_Biomaterial_Freezer_Information.freezer_number regexp '^[[:digit:]]+$' and "+section+"_Biomaterial_Freezer_Information.freezershelf_number regexp '^[[:digit:]]+$' and "+section+"_Biomaterial_Freezer_Information.rack_number regexp '^[[:digit:]]+$' and "+section+"_Biomaterial_Freezer_Information.shelf_number regexp '^[[:digit:]]+$' and "+section+"_Biomaterial_Freezer_Information.box_number regexp '^[[:digit:]]+$' and "+section+"_Biomaterial_Freezer_Information.position_number regexp '^[[:digit:]]+$' order by "+section+"_Biomaterial_Freezer_Information.ensat_id, "+section+"_Biomaterial.biomaterial_date");
    while(rs.next()){
        JSONObject item = new JSONObject();
//        conn_id is not existing in database now, so just add an empty string in json.
//        item.put( "conn_id" , rs.getString("conn_id"));
        item.put( "conn_id" , "");
        item.put( "biomaterial_location_id" , rs.getString(section.toLowerCase()+"_biomaterial_location_id"));
        item.put( "biomaterial_id" , rs.getString(section.toLowerCase()+"_biomaterial_id"));
        item.put( "ensat_id" , rs.getString("ensat_id"));
        item.put( "center_id" , rs.getString("center_id"));
        item.put( "aliquot_sequence_id" , rs.getString("aliquot_sequence_id"));
        item.put( "material" , rs.getString("material"));
        item.put( "freezer_number" , rs.getString("freezer_number"));
        item.put( "freezershelf_number" , rs.getString("freezershelf_number"));
        item.put( "rack_number" , rs.getString("rack_number"));
        item.put( "shelf_number" , rs.getString("shelf_number"));
        item.put( "box_number" , rs.getString("box_number"));
        item.put( "position_number" , rs.getString("position_number"));
        item.put( "bio_id" , rs.getString("bio_id"));
        item.put( "material_used" , rs.getString("material_used"));
        item.put( "material_transferred" , rs.getString("material_transferred"));
        item.put( "biomaterial_date" , rs.getString("biomaterial_date"));
        item.put( "section", section);
        out.println("<tr>");
        out.println("<td>"+item.get("ensat_id").toString()+"</td>");
        out.println("<td>"+item.get("conn_id").toString()+"</td>");
        out.println("<td>"+item.get("bio_id").toString()+"</td>");
        out.println("<td>"+item.get("biomaterial_date").toString()+"</td>");
        out.println("<td>"+item.get("material").toString()+"</td>");
        out.println("<td>"+item.get("aliquot_sequence_id").toString()+"</td>");
        out.println("<td>"+item.get("freezer_number").toString()+"</td>");
        out.println("<td>"+item.get("freezershelf_number").toString()+"</td>");
        out.println("<td>"+item.get("rack_number").toString()+"</td>");
        out.println("<td>"+item.get("shelf_number").toString()+"</td>");
        out.println("<td>"+item.get("box_number").toString()+"</td>");
        out.println("<td>"+item.get("position_number").toString()+"</td>");       

// set the checkbox value in order to transmit the selected biomaterials to next page  
%>
<td><input name="checkbox<%=i%>" type="checkbox" value="<%=item.get("biomaterial_location_id").toString()%>,<%=item.get("biomaterial_id").toString()%>,<%=item.get("ensat_id").toString()%>,<%=item.get("center_id").toString()%>,<%=item.get("conn_id").toString()%>,<%=item.get("bio_id").toString()%>,<%=item.get("biomaterial_date").toString()%>,<%=item.get("material").toString()%>,<%=item.get("aliquot_sequence_id").toString()%>,<%=item.get("freezer_number").toString()%>,<%=item.get("freezershelf_number").toString()%>,<%=item.get("rack_number").toString()%>,<%=item.get("shelf_number").toString()%>,<%=item.get("box_number").toString()%>,<%=item.get("position_number").toString()%>,<%=item.get("section").toString()%>"></td>
<% 
    out.println("</tr>");
        i++;
    }
    
    con.close();
}
catch(SQLException e1){out.print(e1);}
%>
</table>
<input type="hidden" name="num" value="<%=i%>">
<%
String menuOut = "<select name='material_transfer'>";
menuOut += "<option value=''>[Select...]</option>";
for (int j = 0; j < centerCodes.size(); j++) {
    String centerCode = centerCodes.get(j);
    menuOut += "<option value='" + centerCode + "'>" + centerCode + "</option>";
}
menuOut += "</select>";
out.println("Transfer to "+menuOut);
%>
<input type="submit" name="Submit3" value="Submit">
</form>

<jsp:include page="/jsp/page/page_foot.jsp" />