package  
{
	/**
	 * ...
	 * @author Timewave Games
	 */
	
	//import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import org.flixel.FlxG;
	import org.flixel.FlxPreloader;
	//import timewave.core.assets.Images;
	import timewave.core.globals.TopLevel;
	import SWFStats.Log;
	import fog.as3.FogDevAPI;	//////////	FOG API	///////////
	
	public class Preloader extends FlxPreloader	//extends FlxGroup
	{
		protected var siteLockVerifiedByFOG_API:Boolean;
		
		public function Preloader() {
			
			//minDisplayTime = 2;
			//myURL = "www.timewavegames.com";
			
			//	Cliente FOG - iniciando API e carregando preloader deles
			if (CONFIG::USE_FOG_API)
			{
				TopLevel.FogAPI = new FogDevAPI( { id:'YOUR_ID_HERE', root:root } );
				siteLockVerifiedByFOG_API = false;
				performFOGSitelock();
				TopLevel.FogAPI.Preloader.Start(function():void { TopLevel.FOGPreloaderFinished = true; } );
			}
			
			var urls_allowed:Array = [
				//"www.timewavegames.com",
				//"www.flashgamelicense.com",
				//"brizoman.timewavegames.com"
			];
			
			if (sitelock(urls_allowed) && !(siteLockVerifiedByFOG_API))
			{
				this.root.alpha = 0;	
			}
			else
			{
				//	Log.View inicializa o uso dos SWFStats. E' uma comunicacao com o servidor do Playtomic para
				//guardarmos metricas, geolocalizarmos o jogador, etc...
				//	Ja incrementa o numero de Views nas estatisticas deste jogo
				Log.View(585, "2fce39e7-90e0-4b26-976b-a97b2ddb8304", root.loaderInfo.loaderURL);
				
				className = "Main";	//	This should always be the name of your main project/document class
				
				super();
			}
		}
		
		public function sitelock(urls_allowed:Array) : Boolean {
			var lock:Boolean=true;
			var urlString:String=stage.loaderInfo.url;
			var urlParts:Array=urlString.split("://");
			var domain:Array=urlParts[1].split("/");

			for (var i:uint = 0; i < urls_allowed.length; i++) 
			{
			 if (urls_allowed[i]==domain[0]) {
			  lock = false;
			 }
			}

			if (urls_allowed.length == 0)
				return false;
			
			return lock;
		}
		
		private function performFOGSitelock():void
		{
			TopLevel.FogAPI.SiteLock();
			siteLockVerifiedByFOG_API = true;
		}
		
		override protected function onEnterFrame(event:Event):void
        {
			if(!_init)
			{
				if((stage.stageWidth <= 0) || (stage.stageHeight <= 0))
					return;
				create();
				_init = true;
			}
        	var i:int;
            graphics.clear();
			var time:uint = getTimer();
			
			//	No caso do cliente FOG, so saimos do preloader quando o preloader dele estiver completo tambem
			var waitFOGPreloader:Boolean = false;
			if (CONFIG::USE_FOG_API)
				if (!TopLevel.FOGPreloaderFinished)
					waitFOGPreloader = true;
					
            if((framesLoaded >= totalFrames) && (time > _min + 5000) && !waitFOGPreloader)
            {
                removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                nextFrame();
                var mainClass:Class = Class(getDefinitionByName(className));
	            if(mainClass)
	            {
	                var app:Object = new mainClass();
	                addChild(app as DisplayObject);
	            }
                removeChild(_buffer);
            }
            else
			{
				var percent:Number = root.loaderInfo.bytesLoaded/root.loaderInfo.bytesTotal;
				if((_min > 0) && (percent > time/_min))
					percent = time/_min;
            	update(percent);
			}
			
        }
	}

}