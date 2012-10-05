package com.pingfit.db.dao {
	
	import com.pingfit.db.Sql;
	
	public class Prop {
		
		//JUST AN EXAMPLE... DON'T USE THIS FOR PROPS... USE com.pingfit.prefs.*
		
		//AGAIN, DON'T USE THIS
		
		private static var dbTableExistenceAndStructureValidated:Boolean = false;
		private var id:int = 0;
		private var name:String;
		private var value:String;
		
		public function Prop() { 
			validateTableExistenceAndStructure();
		}
		
		public static function get(id:int):Prop{
			validateTableExistenceAndStructure();
			if (dbTableExistenceAndStructureValidated){
				var sql:String = "SELECT * from prop WHERE propid="+id;
				var sqlResult:SQLResult = Sql.executeSQL(sql);
				if( result.data != null ){
					trace( "sync DATA returned:" )
					var item:Object;
					for each( item in result.data ){
						trace( "    row: " + item.name + " " + item.value );
						Prop prop = new Prop();
						prop.setId(item.id);
						prop.setName(item.name);
						prop.setValue(item.value);
						return prop;
					}
				}
			} else {
				trace("dbTableExistenceAndStructureValidated=false");
			}
			return null;
		}
		
		public function save():void{
			if (id>0){
				int rowId = Sql.insertSql("INSERT INTO prop (name, value) VALUES ('"+name+"', '"+value+"')");
				id = rowId;
			} else {
				int rowsAffected = Sql.insertSql("UPDATE prop SET (name, value) VALUES ('"+name+"', '"+value+"')");
			}
		
		}
		
		public function delete():void{
		
		}
		
		public function refresh():void{
		
		}
		
		public static function findByName(name:String):Array{
		
		}
		
		public static function validateTableExistenceAndStructure():void{
			if (!dbTableExistenceAndStructureValidated){
				
				
			}
		}
		
		
		public function getId():String{
			return id;
		}
		public function setId():void{
			this.id = id;
		}
		
		public function getName():String{
			return name;
		}
		public function setName(name:String):void{
			this.name = name;
		}
		
		public function getValue():String{
			return value;
		}
		public function setValue(value:String):void{
			this.value = value;
		}
		
		

	}
	
}