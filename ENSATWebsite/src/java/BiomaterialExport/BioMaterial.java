package BiomaterialExport;
import java.util.Date;


public class BioMaterial {
	String ensat_id;
	String conn_id;
	String bio_id;
	String date;
	String material;
	String aliquot;
	String freezer;
	String f_shelf;
	String rack;
	String r_shelf;
	String box;
	String pos;
	public BioMaterial(String ensat_id, String conn_id, String bio_id, String date, String material, String aliquot, String freezer, String f_shelf, String rack, String r_shelf, String box, String pos){
		this.ensat_id = ensat_id;
		this.conn_id = conn_id;
		this.bio_id = bio_id;
		this.date = date;
		this.material = material;
		this.aliquot = aliquot;
		this.freezer = freezer;
		this.f_shelf = f_shelf;
		this.rack = rack;
		this.r_shelf = r_shelf;
		this.box = box;
		this.pos = pos;
	}
	public String getEnsat_id() {
		return ensat_id;
	}
	public void setEnsat_id(String ensat_id) {
		this.ensat_id = ensat_id;
	}
	public String getConn_id() {
		return conn_id;
	}
	public void setConn_id(String conn_id) {
		this.conn_id = conn_id;
	}
	public String getBio_id() {
		return bio_id;
	}
	public void setBio_id(String bio_id) {
		this.bio_id = bio_id;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getMaterial() {
		return material;
	}
	public void setMaterial(String material) {
		this.material = material;
	}
	public String getAliquot() {
		return aliquot;
	}
	public void setAliquot(String aliquot) {
		this.aliquot = aliquot;
	}
	public String getFreezer() {
		return freezer;
	}
	public void setFreezer(String freezer) {
		this.freezer = freezer;
	}
	public String getF_shelf() {
		return f_shelf;
	}
	public void setF_shelf(String f_shelf) {
		this.f_shelf = f_shelf;
	}
	public String getRack() {
		return rack;
	}
	public void setRack(String rack) {
		this.rack = rack;
	}
	public String getR_shelf() {
		return r_shelf;
	}
	public void setR_shelf(String r_shelf) {
		this.r_shelf = r_shelf;
	}
	public String getBox() {
		return box;
	}
	public void setBox(String box) {
		this.box = box;
	}
	public String getPos() {
		return pos;
	}
	public void setPos(String pos) {
		this.pos = pos;
	}
	
}
