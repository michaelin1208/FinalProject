<%-- 
    Document   : ios_update_biomaterial
    Created on : 2015-9-14, 10:47:09
    Author     : Michaelin
--%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.apache.log4j.PropertyConfigurator"%>
<%@page import="org.apache.log4j.Level"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.Scanner"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=utf-8"%>
<%@page import="java.sql.*"%>
<%
        //Logging configuration
    
    ServletContext context = this.getServletContext();
    String log4jConfigFile = context.getInitParameter("log4j_property_file");
    Logger logger = Logger.getLogger("rootLogger");
    logger.setLevel(Level.DEBUG);
    PropertyConfigurator.configure(log4jConfigFile);
    
    
Connection con;
Statement sql;
int rs;
String body=request.getParameter("data");
if(body!=null){
logger.debug("body "+body);
JSONArray array=(JSONArray)JSONValue.parse(body);
logger.debug("arraysize "+array.size());
try{
    Class.forName("com.mysql.jdbc.Driver").newInstance();
}catch(Exception e){
    logger.debug("e "+e);
    JSONObject result = new JSONObject();
    result.put("type", "ios_update_biomaterial");
    result.put("result", "-1");
    out.print(result.toString());
}
try{
    String uri="jdbc:mysql://localhost:3306/ensat_v3";
    con=DriverManager.getConnection(uri,"root","");
    sql=con.createStatement();
    
    String query = "";
    for(int i=0; i<array.size();i++){
        JSONObject obj = (JSONObject)array.get(i);
        logger.debug("obj "+obj);
        // update the current locations of biomaterials and mark missed biomaterials in the database
        if (obj.get("section")==null){
            query = "UPDATE ACC_Biomaterial_Freezer_Information SET material_transferred='"+obj.get("current_center_id")+"', freezer_number='"+obj.get("freezer_number")+"', freezershelf_number='"+obj.get("freezershelf_number")+"', rack_number='"+obj.get("rack_number")+"', shelf_number='"+obj.get("shelf_number")+"', box_number='"+obj.get("box_number")+"', position_number='"+obj.get("position_number")+"' WHERE acc_biomaterial_location_id='"+obj.get("biomaterial_location_id")+"' AND ensat_id='"+obj.get("ensat_id")+"' AND center_id='"+obj.get("center_id")+"'";
            rs=sql.executeUpdate(query);
            query = "UPDATE APA_Biomaterial_Freezer_Information SET material_transferred='"+obj.get("current_center_id")+"', freezer_number='"+obj.get("freezer_number")+"', freezershelf_number='"+obj.get("freezershelf_number")+"', rack_number='"+obj.get("rack_number")+"', shelf_number='"+obj.get("shelf_number")+"', box_number='"+obj.get("box_number")+"', position_number='"+obj.get("position_number")+"' WHERE apa_biomaterial_location_id='"+obj.get("biomaterial_location_id")+"' AND ensat_id='"+obj.get("ensat_id")+"' AND center_id='"+obj.get("center_id")+"'";
            rs=sql.executeUpdate(query);
            query = "UPDATE NAPACA_Biomaterial_Freezer_Information SET material_transferred='"+obj.get("current_center_id")+"', freezer_number='"+obj.get("freezer_number")+"', freezershelf_number='"+obj.get("freezershelf_number")+"', rack_number='"+obj.get("rack_number")+"', shelf_number='"+obj.get("shelf_number")+"', box_number='"+obj.get("box_number")+"', position_number='"+obj.get("position_number")+"' WHERE napaca_biomaterial_location_id='"+obj.get("biomaterial_location_id")+"' AND ensat_id='"+obj.get("ensat_id")+"' AND center_id='"+obj.get("center_id")+"'";
            rs=sql.executeUpdate(query);
            query = "UPDATE Pheo_Biomaterial_Freezer_Information SET material_transferred='"+obj.get("current_center_id")+"', freezer_number='"+obj.get("freezer_number")+"', freezershelf_number='"+obj.get("freezershelf_number")+"', rack_number='"+obj.get("rack_number")+"', shelf_number='"+obj.get("shelf_number")+"', box_number='"+obj.get("box_number")+"', position_number='"+obj.get("position_number")+"' WHERE pheo_biomaterial_location_id='"+obj.get("biomaterial_location_id")+"' AND ensat_id='"+obj.get("ensat_id")+"' AND center_id='"+obj.get("center_id")+"'";
            rs=sql.executeUpdate(query);
        }else{
            query = "UPDATE "+obj.get("section")+"_Biomaterial_Freezer_Information SET material_transferred='"+obj.get("current_center_id")+"', freezer_number='"+obj.get("freezer_number")+"', freezershelf_number='"+obj.get("freezershelf_number")+"', rack_number='"+obj.get("rack_number")+"', shelf_number='"+obj.get("shelf_number")+"', box_number='"+obj.get("box_number")+"', position_number='"+obj.get("position_number")+"' WHERE "+obj.get("section").toString().toLowerCase()+"_biomaterial_location_id='"+obj.get("biomaterial_location_id")+"' AND ensat_id='"+obj.get("ensat_id")+"' AND center_id='"+obj.get("center_id")+"'";
            rs=sql.executeUpdate(query);
        }
    //    
    }
//    rs=sql.executeUpdate(query);
    con.close();
    JSONObject result = new JSONObject();
    result.put("type", "ios_update_biomaterial");
    result.put("result", "1");
    out.print(result.toString());
    con.close();
}
catch(Exception e1){
    logger.debug("e1 "+e1);
    JSONObject result = new JSONObject();
    result.put("type", "ios_update_biomaterial");
    result.put("result", "-1");
    out.print(result.toString());
}
}else{
    JSONObject result = new JSONObject();
    result.put("type", "ios_update_biomaterial");
    result.put("result", "-1");
    out.print(result.toString());
}
%>