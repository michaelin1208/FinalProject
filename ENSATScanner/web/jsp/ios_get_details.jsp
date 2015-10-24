<%-- 
    Document   : ios_getDetails
    Created on : 2015-8-28, 15:51:19
    Author     : Michaelin
--%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=utf-8"%>
<%@page import="java.sql.*"%>
<%
Connection con;
Statement sql;
ResultSet rs;
String spreadsheetID = request.getParameter("spreadsheet_id");
String centerID = request.getParameter("center_id");
try{Class.forName("com.mysql.jdbc.Driver").newInstance();}
catch(Exception e){out.print(e);}
try{
    String uri="jdbc:mysql://localhost:3306/ensat_v3";
    con=DriverManager.getConnection(uri,"root","");
    sql=con.createStatement();
    rs=sql.executeQuery("select * from Biomaterial_Spreadsheet where spreadsheet_id = \""+spreadsheetID+"\"");
    JSONObject result = new JSONObject();
    JSONArray data = new JSONArray(); 
    while(rs.next()){
        JSONObject item = new JSONObject();
        item.put( "biomaterial_location_id" , rs.getString("biomaterial_location_id"));
        item.put( "biomaterial_id" , rs.getString("biomaterial_id"));
        item.put( "ensat_id" , rs.getString("ensat_id"));
        item.put( "center_id" , rs.getString("center_id"));
        item.put( "aliquot_sequence_id" , rs.getString("aliquot_sequence_id"));
        item.put( "material" , rs.getString("material"));
        item.put( "bio_id" , rs.getString("bio_id"));
        if(rs.getString("section")!=null){
            item.put( "section" , rs.getString("section"));
        }
        data.add(item);
    }
    // get the capacity of freezer
    rs=sql.executeQuery("select * from Freezer_Structure where center_id = \""+centerID+"\" order by freezer_id");
    JSONArray freezerCapacity = new JSONArray(); 
    int i = 1;
    while(rs.next()){
        JSONObject item = new JSONObject();
        item.put("freezer_number",i+"");
        item.put("freezer_capacity",rs.getString("freezer_capacity"));
        item.put("freezer_shelf_capacity",rs.getString("freezer_shelf_capacity"));
        item.put("rack_capacity",rs.getString("rack_capacity"));
        item.put("rack_shelf_capacity",rs.getString("rack_shelf_capacity"));
        item.put("box_capacity",rs.getString("box_capacity"));
        freezerCapacity.add(item);
        i++;
    }
    // get the occupied positions in freezer
    rs=sql.executeQuery("select * from (select freezer_number,freezershelf_number,rack_number,shelf_number,box_number,position_number from ACC_Biomaterial_Freezer_Information where (center_id = \""+centerID+"\" or material_transferred = \""+centerID+"\") and material_used = 'No' and freezer_number regexp '^[[:digit:]]+$' and freezershelf_number regexp '^[[:digit:]]+$' and rack_number regexp '^[[:digit:]]+$' and shelf_number regexp '^[[:digit:]]+$' and box_number regexp '^[[:digit:]]+$' and position_number regexp '^[[:digit:]]+$' group by freezer_number,freezershelf_number,rack_number,shelf_number,box_number,position_number union "
    + "select freezer_number,freezershelf_number,rack_number,shelf_number,box_number,position_number from APA_Biomaterial_Freezer_Information where (center_id = \""+centerID+"\" or material_transferred = \""+centerID+"\") and material_used = 'No' and freezer_number regexp '^[[:digit:]]+$' and freezershelf_number regexp '^[[:digit:]]+$' and rack_number regexp '^[[:digit:]]+$' and shelf_number regexp '^[[:digit:]]+$' and box_number regexp '^[[:digit:]]+$' and position_number regexp '^[[:digit:]]+$' group by freezer_number,freezershelf_number,rack_number,shelf_number,box_number,position_number union "
    + "select freezer_number,freezershelf_number,rack_number,shelf_number,box_number,position_number from NAPACA_Biomaterial_Freezer_Information where (center_id = \""+centerID+"\" or material_transferred = \""+centerID+"\") and material_used = 'No' and freezer_number regexp '^[[:digit:]]+$' and freezershelf_number regexp '^[[:digit:]]+$' and rack_number regexp '^[[:digit:]]+$' and shelf_number regexp '^[[:digit:]]+$' and box_number regexp '^[[:digit:]]+$' and position_number regexp '^[[:digit:]]+$' group by freezer_number,freezershelf_number,rack_number,shelf_number,box_number,position_number union "
    + "select freezer_number,freezershelf_number,rack_number,shelf_number,box_number,position_number from Pheo_Biomaterial_Freezer_Information where (center_id = \""+centerID+"\" or material_transferred = \""+centerID+"\") and material_used = 'No' and freezer_number regexp '^[[:digit:]]+$' and freezershelf_number regexp '^[[:digit:]]+$' and rack_number regexp '^[[:digit:]]+$' and shelf_number regexp '^[[:digit:]]+$' and box_number regexp '^[[:digit:]]+$' and position_number regexp '^[[:digit:]]+$' group by freezer_number,freezershelf_number,rack_number,shelf_number,box_number,position_number) as allPosition "
    + "order by (freezer_number+0),(freezershelf_number+0),(rack_number+0),(shelf_number+0),(box_number+0),(position_number+0)");
    JSONArray usedPositions = new JSONArray(); 
    while(rs.next()){
        JSONObject item = new JSONObject();
        item.put( "freezer_number" , rs.getString("freezer_number"));
        item.put( "freezershelf_number" , rs.getString("freezershelf_number"));
        item.put( "rack_number" , rs.getString("rack_number"));
        item.put( "shelf_number" , rs.getString("shelf_number"));
        item.put( "box_number" , rs.getString("box_number"));
        item.put( "position_number" , rs.getString("position_number"));
        usedPositions.add(item);
    }
    result.put("data", data);
    if(freezerCapacity.isEmpty()){
        result.put("freezerCapacity", "");
    }else{  
        result.put("freezerCapacity", freezerCapacity);
    }
    result.put("usedPositions", usedPositions);
    result.put("type", "ios_get_details");
    out.print(result.toString());
    
    con.close();
}
catch(SQLException e1){out.print(e1);}
%>