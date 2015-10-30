package BiomaterialExport;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;

import javax.swing.JOptionPane;

public class BioMaterialExport{
    // export Excel file with biomaterial details
	public void exportBioMaterialExcel(ArrayList<Hashtable<String,String>> array,String path) throws IOException {  
        
        ExportExcel<BioMaterial> exportExcel = new ExportExcel<BioMaterial>();  
          
        String[] headers = new String[]{"ensat_id", "conn_id", "bio_id", "date", "material", "aliquot", "freezer", "f_shelf", "rack", "r_shelf", "box", "pos"};  
        List<BioMaterial> studentList = new ArrayList<BioMaterial>();  
        
        for(Hashtable<String,String> item : array){
            BioMaterial stu1 = new BioMaterial(item.get("ensat_id"),item.get("conn_id"),item.get("bio_id"),item.get("biomaterial_date"),item.get("material"),item.get("aliquot_sequence_id"),item.get("freezer_number"),item.get("freezershelf_number"),item.get("rack_number"),item.get("shelf_number"),item.get("box_number"),item.get("position_number"));   
            studentList.add(stu1); 
        }
        
        FileOutputStream out = null;  
        try {  
            File directory = new File("");//set the current folder

            System.out.println(directory.getCanonicalPath());//get the path
            System.out.println(directory.getAbsolutePath());//get the absolute path
            

            out = new FileOutputStream(new File(path));
            // generate the Excel file with customised headers, list of data, output path and the time format. 
            exportExcel.exportExcep(headers, studentList, out, "yyyy/MM/dd");  
//            JOptionPane.showMessageDialog(null, "Success");
            System.out.println("EXCEL export successfully!");
        } catch (FileNotFoundException e) {  
            e.printStackTrace();  
        }finally{  
            if(null != out){  
                try {  
                    out.close();  
                } catch (IOException e) {  
                    e.printStackTrace();  
                }  
            }  
        }  
    }  
}