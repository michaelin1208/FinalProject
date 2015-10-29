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
            File directory = new File("");//设定为当前文件夹 

            System.out.println(directory.getCanonicalPath());//获取标准的路径 
            System.out.println(directory.getAbsolutePath());//获取绝对路径 
            

            out = new FileOutputStream(new File(path));  
            exportExcel.exportExcep(headers, studentList, out, "yyyy/MM/dd");  
//            JOptionPane.showMessageDialog(null, "导出成功");  
            System.out.println("EXCEL导出成功!");  
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