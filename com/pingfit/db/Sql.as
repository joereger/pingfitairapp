package com.pingfit.db {
	
	public class Sql {
		

		public function Sql() {}
		
		
	
		public static executeSQL(sql:String):SQLResult{
			trace("sql="+sql);
			var statement:SQLStatement = executeSQLGetStatement(sql);
			if( statement != null){
				traceStatement(statement);
				return statement.getResult();
			}
			return null;
		}
		
		public static insertSQL(sql:String):Number{
			var sqlResult = executeSQL(sql);
			return sqlResult.lastInsertRowID;
		}
		
		public static updateSQL(sql:String):Number{
			var sqlResult = executeSQL(sql);
			return sqlResult.rowsAffected;
		}
		
		
		private function executeSQLGetStatement( sql:String ):SQLStatement{
			try{
				var statement:SQLStatement = new SQLStatement();
				statement.sqlConnection = SqlConn.getSyncConn();
			    statement.text = sql;
				statement.execute();
				trace( "Sql.executeSQL() -- SQL statement executed correctly." );
			} catch ( e:SQLError ){
				trace( "Sql.executeSQL() -- SQLError [ " + e.operation + " ]... " +  e.message );
				return null;
			}
			return statement;
		}
		
		public function traceStatement(statement:SQLStatement):void{
			if(statement!=null){
				var result:SQLResult = statement.getResult();
				if(result.data!= null){
					trace( "DATA returned:" );
					var item:Object;
					for each(item in result.data){
						trace( "    row: "+item.toString());
					}
				}
			}
		}
		
		
	
	}
	
}