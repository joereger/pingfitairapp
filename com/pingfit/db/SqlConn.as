package com.pingfit.db {
	
	import flash.data.SQLConnection;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.MovieClip;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;

	
	public class SqlConn {
		
		private static var sqlConnection:SQLConnection;
		private static var dbFile:File;
		private static String dbPath = "data";
		private static String dbFileName = "pingFitDatabase.db";
		
		public function SqlConn() { }
		
		public static function getSyncConn():SQLConnection{
			if (sqlConnection==null || !sqlConnection.connected){
				initConnSync();
			}
			return sqlConnection;
		}
		
		private function closeSyncDB():void{
			output.appendText( "Closing sync connection...\n" );
			var syncResponder:Responder = new Responder( syncDbClosure, syncDbClosureError );
			sqlConnection.close( syncResponder );
		}					
		
		private static function syncDbClosure( evt:SQLEvent ):void{
			output.appendText( "closed sync db connection" );
		}

		private function syncDbClosureError( evt:SQLErrorEvent ):void{
			output.appendText( "Errors closing sync db connection: " + evt.error.message );
		}
														
																		
		
		private static function initConnSync():void{
			if (dbFileName==null || !dbFileName.exists){
				initLocalDbFile();
			}
			sqlConnection = new SQLConnection();
			output.appendText( "Opening sync connection...\n" );
			try{
				sqlConnection.open( dbFile );
			}catch( e:SQLError ){
				output.appendText( "Sync connection error: " + e.message + " operation type: " + e.operation + "\n" );
				return;
			}
			output.appendText( "Sync connection opened!\n" );
		}
		
		private static function initLocalDbFile():void{
			// create folder, in application root, to store database files
			var folder:File = File.applicationStorageDirectory.resolvePath( dbPath );
			// ensure folder exists
			folder.createDirectory();
			// create/access file to contains db
			dbFile 	= folder.resolvePath( dbFileName );
			output.appendText("Database repository position: " + dbFile.nativePath + "\n");
		}


	
		
	}
	
}