package com.pingfit.versionupdate {
	
	import flash.events.Event;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.desktop.Updater;
	import flash.filesystem.FileMode;
	import flash.desktop.NativeApplication;
	import flash.events.IOErrorEvent;
	import com.pingfit.xml.ApiParams;
	
	
	public class VersionCheck {
		
		private var descriptor:XML;
		private var ns:Namespace;
		private var installedVersion;
		private var remoteVersion:String;
		private var appURL:String;
		private var loader:URLLoader;
		private var urlStream:URLStream;
		private var fileData:ByteArray;
		
		
		
		public function VersionCheck() { 
			trace("VersionCheck instanciated");
			descriptor = NativeApplication.nativeApplication.applicationDescriptor;
			ns = descriptor.namespaceDeclarations()[0];
			installedVersion = descriptor.ns::version;
			trace("VersionCheck installedVersion="+installedVersion);
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadXML);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadXMLError);
			loader.load(new URLRequest(ApiParams.getBaseurl()+"PingFitAirAppVersion.xml"));
		}
		
		private function loadXML(event:Event):void{
			trace("VersionCheck loadXML()");
			//trace("---START RAW XML---");
			//trace(event.target.data);
			//trace("---END RAW XML---");
			var xmlData:XML = new XML(event.target.data);
			var ns:Namespace = xmlData.namespace();
			//trace("---START PARSED XML---");
			//trace(xmlData);
			//trace("---END PARSED XML---");
			//trace("---START ITERATE---");
			//for each (var child:XML in xmlData.*){
			//	trace("child.name()="+child.name() + " child=" +child);
			//}
			//trace("---END ITERATE---");
			remoteVersion = xmlData.ns::version;
			trace("VersionCheck remoteVersion="+remoteVersion);
			appURL = xmlData.url;
			//Compare... keep version of format 2.0.0 and everybody's happy, ok?
			if (remoteVersion > installedVersion){
				downloadUpdate();
			} else {
				trace("VersionCheck sez no need for update. installedVersion="+installedVersion+" remoteVerion="+remoteVersion);
			}
		}
		
		private function loadXMLError(event:IOErrorEvent):void{
			trace("VersionCheck loadXMLError()");
		}
		
		private function downloadUpdate():void{
			trace("VersionCheck downloadUpdate()");
			urlStream = new URLStream();
			fileData = new ByteArray();
			urlStream.addEventListener(Event.COMPLETE, installUpdate);
			urlStream.load(new URLRequest(ApiParams.getBaseurl()+"PingFit.air"));
			//urlStream.load(new URLRequest(appURL));
		}
		
		private function installUpdate(e:Event):void{
			trace("VersionCheck installUpdate()");
			urlStream.readBytes(fileData, 0, urlStream.bytesAvailable);
			var file:File = File.applicationStorageDirectory.resolvePath("PingFitAppUpdate.air");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(fileData, 0, fileData.length);
			fileStream.close();
			var updater:Updater = new Updater();
			updater.update(file, remoteVersion);
		}
	
	}
	
}