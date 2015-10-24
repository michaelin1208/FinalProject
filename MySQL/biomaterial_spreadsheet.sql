DROP TABLE IF EXISTS `Biomaterial_Spreadsheet`;
CREATE TABLE `Biomaterial_Spreadsheet` (
  `biomaterial_spreadsheet_id` int(11) NOT NULL AUTO_INCREMENT,
  `spreadsheet_id` bigint NOT NULL,
  `acc_biomaterial_location_id` int(11) NOT NULL,
  `acc_biomaterial_id` int(11) NOT NULL,
  `ensat_id` int(11) NOT NULL,
  `center_id` varchar(5) NOT NULL,
  `aliquot_sequence_id` int(11) NOT NULL,
  `material` varchar(100) DEFAULT NULL,
  `freezer_number` varchar(10) DEFAULT NULL,
  `freezershelf_number` varchar(10) DEFAULT NULL,
  `rack_number` varchar(10) DEFAULT NULL,
  `shelf_number` varchar(10) DEFAULT NULL,
  `box_number` varchar(10) DEFAULT NULL,
  `position_number` varchar(10) DEFAULT NULL,
  `bio_id` varchar(100) DEFAULT NULL,
  `conn_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`biomaterial_spreadsheet_id`,`acc_biomaterial_location_id`,`acc_biomaterial_id`,`ensat_id`,`center_id`)
)