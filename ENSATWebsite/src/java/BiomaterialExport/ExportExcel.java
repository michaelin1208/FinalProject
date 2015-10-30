package BiomaterialExport;

import java.io.IOException;  
import java.io.OutputStream;  
import java.lang.reflect.Field;  
import java.lang.reflect.InvocationTargetException;  
import java.lang.reflect.Method;  
import java.text.SimpleDateFormat;  
import java.util.Collection;  
import java.util.Date;  
import java.util.Iterator;  
import java.util.regex.Matcher;  
import java.util.regex.Pattern;  
import org.apache.poi.hssf.usermodel.HSSFCell;  
import org.apache.poi.hssf.usermodel.HSSFCellStyle;  
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;  
import org.apache.poi.hssf.usermodel.HSSFComment;  
import org.apache.poi.hssf.usermodel.HSSFFont;  
import org.apache.poi.hssf.usermodel.HSSFPatriarch;  
import org.apache.poi.hssf.usermodel.HSSFRichTextString;  
import org.apache.poi.hssf.usermodel.HSSFRow;  
import org.apache.poi.hssf.usermodel.HSSFSheet;  
import org.apache.poi.hssf.usermodel.HSSFWorkbook;  
import org.apache.poi.hssf.util.HSSFColor;  
  
/** 
 * Export Excel class used to export biomaterial excel.
 */  
public class ExportExcel<T> {  
      
    public void exportExcel(Collection<T> dataset,OutputStream out){  
        this.exportExcel("Test", null, dataset, out, "yyyy-MM-dd");
    }  
      
    public void exportExcel(String[] headers,Collection<T> dataset,OutputStream out){  
        this.exportExcel("Test", headers, dataset, out,"yyyy-MM-dd");
    }  
      
    public void exportExcep(String[] headers,Collection<T> dataset,OutputStream out,String patterm){  
        this.exportExcel("Test", headers, dataset, out, patterm);
    }  
      
    /**
     * @param title 
     *      Sheet title
     * @param headers 
     *      Titles of columes.
     * @param dataset 
     *      dataset to store into the Excel.
     * @param out 
     *      output stream.
     * @param pattem 
     *      date format, default value is "yyyy-MM-dd".
     */  
    public void exportExcel(String title,String[] headers,Collection<T> dataset,OutputStream out,String pattem){  
        //create a work book
        HSSFWorkbook workbook = new HSSFWorkbook();  
        //create a sheet
        HSSFSheet sheet = workbook.createSheet(title);  
        //set the default column width
        sheet.setDefaultColumnWidth((short)15);  
        //create a cell style
        HSSFCellStyle style = workbook.createCellStyle();  
        style.setFillForegroundColor(HSSFColor.GOLD.index);  
        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);  
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);  
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);  
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);  
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);  
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);  
        //create a font
        HSSFFont font = workbook.createFont();  
        font.setColor(HSSFColor.BLACK.index);  
        font.setFontHeightInPoints((short)12);  
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);  
        //set the font
        style.setFont(font);  
        //create another cell style
        HSSFCellStyle style2 = workbook.createCellStyle();  
        style2.setFillForegroundColor(HSSFColor.WHITE.index);  
        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);  
        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);  
        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);  
        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);  
        style2.setBorderTop(HSSFCellStyle.BORDER_THIN);  
        style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);  
        style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);  
        //create another font
        HSSFFont font2 = workbook.createFont();  
        font2.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);  
        //set the font
        style2.setFont(font2);  
          
        
        HSSFPatriarch patriarch = sheet.createDrawingPatriarch();  
 
          
        //set the column title
        HSSFRow row = sheet.createRow(0);  
        for(int i = 0; i < headers.length; i++){  
            HSSFCell cell = row.createCell((short) i);  
            cell.setCellStyle(style);
            HSSFRichTextString text = new HSSFRichTextString(headers[i]);  
            cell.setCellValue(text.toString());
        }  
          
        //set the content
        Iterator<T> it = dataset.iterator();  
        int index = 0;  
        while(it.hasNext()){  
            index++;  
            row = sheet.createRow(index);  
            T t = (T)it.next();
            Field[] fields = t.getClass().getDeclaredFields();  
            for(int i = 0; i < fields.length; i++){  
                HSSFCell cell = row.createCell((short) i);  
                cell.setCellStyle(style2);  
                Field field = fields[i];  
                String fieldName = field.getName();  
                String getMethodName = "get"+fieldName.substring(0, 1).toUpperCase()+fieldName.substring(1);  
                Class tCls = t.getClass();  
                try {  
                    Method getMethod = tCls.getMethod(getMethodName, new Class[]{});  
                    Object value = getMethod.invoke(t, new Object[]{});  
                    
                    String textValue = null;  
                    /*if(value instanceof Integer){ 
                        Integer intValue = (Integer)value; 
                        cell.setCellValue(intValue); 
                    }else if(value instanceof Float){ 
                        Float floatValue = (Float)value; 
                        cell.setCellValue(floatValue); 
                    }else if(value instanceof Double){ 
                        Double doubleValue = (Double)value; 
                        cell.setCellValue(doubleValue); 
                    }else if(value instanceof Long){ 
                        Long longValue = (Long)value; 
                        cell.setCellValue(longValue); 
                    }else */  
                    if(value instanceof Boolean){  
                        boolean booleanValue = (Boolean)value;  
                        textValue = "male";
                        if(!booleanValue){  
                            textValue = "female";
                        }  
                        cell.setCellValue(textValue);  
                    }else if(value instanceof Date){  
                        Date date = (Date)value;  
                        SimpleDateFormat sdf = new SimpleDateFormat(pattem);  
                        textValue = sdf.format(date);  
                        cell.setCellValue(textValue);  
                    }else if(value instanceof byte[]){
                        //set picture
                        row.setHeightInPoints(60);
                        sheet.setColumnWidth((short) i, (short)(35.7*80));  
                        //sheet.autoSizeColumn(i);  
                        byte[] bsValue = (byte[])value;  
                        HSSFClientAnchor anchor = new HSSFClientAnchor(0,0,1023,55,(short)6,index,(short)6,index);  
//                        anchor.setAnchorType(2);  
//                        patriarch.createPicture(anchor,workbook.addPicture(bsValue, HSSFWorkbook.PICTURE_TYPE_JPEG));  
                    }else{  
                        //other kinds of value
                        if(value != null){
                            textValue = value.toString();  
                        }
                    }  
                    //if it is not image, check whether it is a pure number
                    if(textValue != null){  
                        Pattern p = Pattern.compile("^\\d+(\\.\\d+)?$");  
                        Matcher matcher = p.matcher(textValue);  
                        if(matcher.matches()){
                            cell.setCellValue(Double.parseDouble(textValue));  
                        }else{  
                            HSSFRichTextString richString = new HSSFRichTextString(textValue);  
                            HSSFFont font3 = workbook.createFont();  
                            font3.setColor(HSSFColor.BLACK.index);  
                            richString.applyFont(font3);  
                            cell.setCellValue(richString.toString());  
                        }  
                    }  
                } catch (SecurityException e) {  
                    e.printStackTrace();  
                } catch (NoSuchMethodException e) {  
                    e.printStackTrace();  
                } catch (IllegalArgumentException e) {  
                    e.printStackTrace();  
                } catch (IllegalAccessException e) {  
                    e.printStackTrace();  
                } catch (InvocationTargetException e) {  
                    e.printStackTrace();  
                }finally{  
                    
                }  
            }  
        }  
        try {  
            workbook.write(out);  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
    }  
}  