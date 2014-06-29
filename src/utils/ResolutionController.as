/**  ResolutionController.as
 * 
 * @author Alejandro Rodríguez
 */
package utils
{
	import flash.geom.Point;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	/**
	 * The <code>FPLResolutionController</code> is used to adjust the resolution
	 * of the starling class to the different devices and docks the objects to
	 * the screen.
	 */
	public class ResolutionController
	{
		//Const for center alignment.
		public static const CENTER:String = "center";
		//Const for left alignment.
		public static const LEFT:String = "left";
		//Const for right alignment.
		public static const RIGHT:String = "right";
		//Const for top alignment.
		public static const TOP:String = "top";
		//Const for bottom alignment.
		public static const BOTTOM:String = "bottom";
		
		public static const IPAD:String = "43";
		public static const IPOD4:String = "32";
		public static const IPOD5:String = "169";
		
		
		/**
		 * Builder for class.
		 * @param key: key for non instanciable class
		 */
		public function ResolutionController(key:StaticKey)
		{
			if(!key)
			{
				throw new Error('Static, use the static methods.');
			}
		}
		
		
		/**
		 * Gets the right aspect of the stage for multiple resolution.
		 *  
		 * @return A point with the resolution, x: height, y: width
		 */
		public static function adjustResolution():Point
		{
			var pScreenWidth:Number  = Starling.current.stage.stageWidth;
			var pScreenHeight:Number = Starling.current.stage.stageHeight;
			
			var isPad:Boolean = (pScreenHeight == 1536 || pScreenHeight == 768);
			var isPod:Boolean = (pScreenWidth == 480 || pScreenWidth == 960 || pScreenWidth == 1920);
			
			var pResolution:Point = new Point(0,0);
			if(isPad)
			{
				pResolution.x = 768;
				pResolution.y = 1024;
			}
			else if(isPod)
			{
				pResolution.x = 725;//640;
				pResolution.y = 1090;//960;
			}
			else
			{
				pResolution.x = 613;//640;
				pResolution.y = 1090;//1136;
			}
			
			return pResolution;
		}
		
		/**
		 * Dynamically adjusts the position of an <code>starling.display.DisplayObject</code>
		 * according to the screen resolution.
		 * 
		 * @param pObject: The <code>starling.display.DisplayObject</code> to adjust.
		 * @param pX: The X alignment.
		 * @param pXOffset: the x offset alignment.
		 * @param pY:The Y alignment.
		 * @param pYOffset: The Y offset alignment.
		 * @param pIsAnimated: Flag to indicate if is an <code>FPLAnimatedSprite</code>
		 * (this has the pivote at center).
		 * 
		 */
		public static function dockObject(pObject:DisplayObject, pX:String, pXOffset:Number, pY:String, pYOffset:Number, pIsAnimated:Boolean = false):void
		{
			var pScreenWidth:Number  = Starling.current.stage.stageWidth;
			var pScreenHeight:Number = Starling.current.stage.stageHeight;
			
			var objectWidth:Number = pIsAnimated ? 0 : pObject.width;
			var objectHeight:Number = pIsAnimated ? 0 : pObject.height;
			
			if(pX == LEFT)
			{
				pObject.x = 0;
			}
			else if(pX == RIGHT)
			{
				pObject.x = pScreenWidth - objectWidth;
			}
			else
			{
				pObject.x = pScreenWidth / 2 - objectWidth / 2;
			}
			
			if(pY == TOP)
			{
				pObject.y = 0;
			}
			else if(pY == BOTTOM)
			{
				pObject.y = pScreenHeight - objectHeight;
			}
			else
			{
				pObject.y = pScreenHeight / 2 - objectHeight / 2;
			}
			
			pObject.x += pXOffset;
			pObject.y += pYOffset;
		}
		
		/**
		 * Dynamically adjusts the position of an <code>starling.display.DisplayObject</code>
		 * according to the screen resolution.
		 * 
		 * @param pObject: The <code>starling.display.DisplayObject</code> to adjust.
		 * @param pX: The X alignment.
		 * @param pXOffset: the x offset alignment.
		 * @param pY:The Y alignment.
		 * @param pYOffset: The Y offset alignment.
		 * @param pIsAnimated: Flag to indicate if is an <code>FPLAnimatedSprite</code>
		 * (this has the pivote at center).
		 * 
		 */
		public static function dockCornerObject(pObject:DisplayObject, pX:String, pY:String):void
		{
			var pScreenWidth:Number  = Starling.current.stage.stageWidth;
			var pScreenHeight:Number = Starling.current.stage.stageHeight;
			
			if(pX == LEFT)
			{
				pObject.x = -Starling.current.stage.stageWidth/2 + pObject.width/2;
			}
			else if(pX == RIGHT)
			{
				pObject.x = Starling.current.stage.stageWidth/2 - pObject.width/2;
			}
			else
			{
				pObject.x = 0;
			}
			
			if(pY == TOP)
			{
				pObject.y = -Starling.current.stage.stageHeight/2 + pObject.height/2;
			}
			else if(pY == BOTTOM)
			{
				pObject.y = Starling.current.stage.stageHeight/2 - pObject.height/2;
			}
			else
			{
				pObject.y = 0;
			}
		}
		
		/**
		 * Calculates the aspect ratio of the screen an return a string with this.
		 * @return the current aspect ratio of the aplication.
		 * 
		 */
		public static function getResolutionAspectRatio():String
		{
			var currentResolution:String = IPAD;
			var currentAspectRatio:Number = Starling.current.stage.stageWidth/Starling.current.stage.stageHeight;
			
			if(1.3 < currentAspectRatio && currentAspectRatio < 1.4) {
				currentResolution = IPAD;
			} else if(1.4 < currentAspectRatio && currentAspectRatio < 1.6) {
				currentResolution = IPOD4;
			} else if(1.6 < currentAspectRatio && currentAspectRatio < 1.8) {
				currentResolution = IPOD5;
			} else {
				currentResolution = IPAD;
			}
			
			return currentResolution;
		}
		
		public static function docObjectToStarlingPosition(pObject:DisplayObject, pX:String, pXOffset:Number, pY:String, pYOffset:Number):void
		{
			var pointX:Number  = Starling.current.stage.stageWidth;
			var pointY:Number = Starling.current.stage.stageHeight;
			var objectWidthOffset:Number = 0;
			var objectHeightOffset:Number = 0;
			
			if(pX == LEFT)
			{
				pointX = 0;
				objectWidthOffset = pObject.width/2;
			}
			else if(pX == CENTER)
			{
				pointX = pointX/2;
			}
			else
			{
				objectWidthOffset = -pObject.width/2;
			}
			
			if(pY == TOP)
			{
				pointY = 0;
				objectHeightOffset = pObject.height/2;
			}
			else if(pY == CENTER)
			{
				pointY = pointY/2;
			}
			else
			{
				objectHeightOffset = -pObject.height/2;
			}
			
			var starlingPoint:Point = Starling.current.stage.localToGlobal(new Point(pointX, pointY));
			var objectPoint:Point = pObject.globalToLocal(starlingPoint);
			pObject.x = objectPoint.x + objectWidthOffset + pXOffset;
			pObject.y = objectPoint.y + objectHeightOffset + pYOffset;
		}
		
		public static function IsIPhone4Device():Boolean
		{
			return (Capabilities.os.indexOf("iPhone3") != -1 ||
				Capabilities.os.indexOf("iPod4") != -1 ||
				Capabilities.os.indexOf("iPod3") != -1 ||
				Capabilities.os.indexOf("iPad1") != -1);
		}
		
		public static function IsIPod3Device():Boolean
		{
			return (Capabilities.os.indexOf("iPod3") != -1);
		}
	}
}

class StaticKey{
	
}