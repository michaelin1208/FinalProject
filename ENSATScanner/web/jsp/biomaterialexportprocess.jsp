<%-- 
    Document   : biomaterialexportprocess
    Created on : 2015-8-15, 15:07:11
    Author     : Michaelin
--%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" import="java.util.*,java.sql.*,org.apache.log4j.*" pageEncoding="ISO-8859-1"%>

<jsp:useBean id='bioMaterialExport' class='BiomaterialExport.BioMaterialExport'  scope='session'/>
<jsp:useBean id='qRCodeGenerator' class='BiomaterialExport.QRCodeGenerator'  scope='session'/>
<jsp:include page="/jsp/page/check_credentials.jsp" />
<jsp:include page="/jsp/page/check_input.jsp" />
<jsp:include page="/jsp/page/page_head.jsp" />

<td colspan="2" width="81%" align="left" valign="top" background="/images/possbk.jpg"><table width="1200" border="0" cellspacing="0" cellpadding="10"> 
      <tr> 
        <td width="15" align="left" valign="top">&nbsp;</td> 
        <td align="left" valign="top"><!-- #BeginEditable "MainText" --> 

<jsp:include page="/jsp/page/page_nav.jsp" />

<jsp:useBean id='connect' class='ConnectBean.ConnectBean' scope='session'/>
<jsp:useBean id='presentation' class='summaryinfo.SummaryInfo' scope='session'/>
<jsp:useBean id='user' class='user.UserBean'  scope='session'/>
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
  </tr>
<%
    Logger logger = Logger.getLogger("rootLogger");
    logger.setLevel(Level.DEBUG);
    String tmp=new String();
    String s_num=request.getParameter("num");
    String centerID=request.getParameter("material_transfer");
    int num=Integer.valueOf(s_num);
    String[] items;
    ArrayList<Hashtable<String,String>> selectedItems = new ArrayList<Hashtable<String,String>>();
    for(int i=0;i<num;i++)
    {
        tmp=request.getParameter("checkbox"+i);
        if(tmp != null){
//            logger.debug("tmp "+ tmp);
            items = tmp.split(",", -1);
//            logger.debug("items "+ items.length);
            Hashtable<String,String> dic = new Hashtable<String,String>();
            dic.put("biomaterial_location_id",items[0]);
            dic.put("biomaterial_id",items[1]);
            dic.put("ensat_id",items[2]);
            dic.put("center_id",items[3]);
            dic.put("conn_id",items[4]);
            dic.put("bio_id",items[5]);
            dic.put("biomaterial_date",items[6]);
            dic.put("material",items[7]);
            dic.put("aliquot_sequence_id",items[8]);
            dic.put("freezer_number",items[9]);
            dic.put("freezershelf_number",items[10]);
            dic.put("rack_number",items[11]);
            dic.put("shelf_number",items[12]);
            dic.put("box_number",items[13]);
            dic.put("position_number",items[14]);
            dic.put("section",items[15]);
            selectedItems.add(dic);
        }
    }
    long date = new java.util.Date().getTime();
    String query = "";
    for(Hashtable<String,String> tempDic : selectedItems){
        //display the data 
        out.println("<tr>");
        out.println("<td>"+tempDic.get("ensat_id")+"</td>");
        out.println("<td>"+tempDic.get("conn_id")+"</td>");
        out.println("<td>"+tempDic.get("bio_id")+"</td>");
        out.println("<td>"+tempDic.get("biomaterial_date")+"</td>");
        out.println("<td>"+tempDic.get("material")+"</td>");
        out.println("<td>"+tempDic.get("aliquot_sequence_id")+"</td>");
        out.println("<td>"+tempDic.get("freezer_number")+"</td>");
        out.println("<td>"+tempDic.get("freezershelf_number")+"</td>");
        out.println("<td>"+tempDic.get("rack_number")+"</td>");
        out.println("<td>"+tempDic.get("shelf_number")+"</td>");
        out.println("<td>"+tempDic.get("box_number")+"</td>");
        out.println("<td>"+tempDic.get("position_number")+"</td>");       
        out.println("</tr>");
        
        //create the query to store the selected data into the database
       if(query.equals("")){
           query = "INSERT INTO `Biomaterial_Spreadsheet` (`spreadsheet_id`, `biomaterial_location_id`,`biomaterial_id`,`ensat_id`,`center_id`,`aliquot_sequence_id`,`material`,`freezer_number`,`freezershelf_number`,`rack_number`,`shelf_number`,`box_number`,`position_number`,`bio_id`,`conn_id`,`section`) VALUES ("+ date +","+Integer.parseInt(tempDic.get("biomaterial_location_id"))+","+Integer.parseInt(tempDic.get("biomaterial_id"))+","+Integer.parseInt(tempDic.get("ensat_id"))+",\""+tempDic.get("center_id")+"\","+Integer.parseInt(tempDic.get("aliquot_sequence_id"))+",\""+tempDic.get("material")+"\",\""+tempDic.get("freezer_number")+"\",\""+tempDic.get("freezershelf_number")+"\",\""+tempDic.get("rack_number")+"\",\""+tempDic.get("shelf_number")+"\",\""+tempDic.get("box_number")+"\",\""+tempDic.get("position_number")+"\",\""+tempDic.get("bio_id")+"\",\""+tempDic.get("conn_id")+"\",\""+tempDic.get("section")+"\")";
       }else{
           query = query + ",("+ date +","+Integer.parseInt(tempDic.get("biomaterial_location_id"))+","+Integer.parseInt(tempDic.get("biomaterial_id"))+","+Integer.parseInt(tempDic.get("ensat_id"))+",\""+tempDic.get("center_id")+"\","+Integer.parseInt(tempDic.get("aliquot_sequence_id"))+",\""+tempDic.get("material")+"\",\""+tempDic.get("freezer_number")+"\",\""+tempDic.get("freezershelf_number")+"\",\""+tempDic.get("rack_number")+"\",\""+tempDic.get("shelf_number")+"\",\""+tempDic.get("box_number")+"\",\""+tempDic.get("position_number")+"\",\""+tempDic.get("bio_id")+"\",\""+tempDic.get("conn_id")+"\",\""+tempDic.get("section")+"\")"; 
       }
        
    }
    Connection con;
    Statement sql;
    int rs;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
    }catch(Exception e){
        out.print(e);
    }
    try{
        String uri="jdbc:mysql://localhost:3306/ensat_v3";
        con=DriverManager.getConnection(uri,"root","");
        sql=con.createStatement();
        rs=sql.executeUpdate(query);
        
        for(Hashtable<String,String> tempDic : selectedItems){
            query = "UPDATE "+tempDic.get("section")+"_Biomaterial_Freezer_Information SET material_transferred='"+centerID+" - in transit' WHERE "+tempDic.get("section").toLowerCase()+"_biomaterial_location_id='"+tempDic.get("biomaterial_location_id")+"' AND ensat_id='"+tempDic.get("ensat_id")+"' AND center_id='"+tempDic.get("center_id")+"'";
            rs=sql.executeUpdate(query);
        }
        
        con.close();
    }
    catch(SQLException e1){out.print(e1);}
    String dir=application.getRealPath("/");  
//    out.println("dir "+dir+"</br>"); 
    bioMaterialExport.exportBioMaterialExcel(selectedItems, dir+"biomaterial_export/"+date+".xls");
    qRCodeGenerator.createPdf(String.valueOf(date), dir+"biomaterial_export/"+date+".pdf");
%>
</table>

<script type="text/javascript">
    var date = <%=date%>;
    function ExcelOnclick(){
       window.open("/ENSAT/biomaterial_export/"+date+".xls");
    }
    function QRCodeOnclick(){
       window.open("/ENSAT/biomaterial_export/"+date+".pdf");
    }
</script>
<% out.print("Transfer to "+centerID); %>
<input type="submit" name="Excel" onclick="ExcelOnclick()" value="Excel">
<input type="submit" name="QRCode" onclick="QRCodeOnclick()" value="QRCode">

<jsp:include page="/jsp/page/page_foot.jsp" />

