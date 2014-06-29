package Assets
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AssetsManager
	{
		[Embed(source="../../media/textures/ButtonAtlas.png")]
		public static const ButtonAtlasTexture:Class;
		
		[Embed(source="../../media/textures/ButtonAtlas.xml", mimeType="application/octet-stream")]
		public static const ButtonAtlasXML:Class;
		
		[Embed(source="../../media/textures/maintexture.png")]
		public static const mainAtlasTexture:Class;
		
		[Embed(source="../../media/textures/maintexture.xml", mimeType="application/octet-stream")]
		public static const mainAtlasXML:Class;
		
		[Embed(source="../../media/textures/SquareAtlas.png")]
		public static const SquareAtlasTexture:Class;
		
		[Embed(source="../../media/textures/SquareAtlas.xml", mimeType="application/octet-stream")]
		public static const SquareAtlasXML:Class;
		
		[Embed(source="../../media/fonts/font.png")]
		public static const PixelSplitterTexture:Class;
		
		[Embed(source="../../media/fonts/font.fnt", mimeType="application/octet-stream")]
		public static const PixelSplitterXML:Class;
		
		[Embed(source="../../media/fonts/Segoe.png")]
		public static const SegoeUITexture:Class;
		
		[Embed(source="../../media/fonts/Segoe.fnt", mimeType="application/octet-stream")]
		public static const SegoeUIXML:Class;
		
		[Embed(source="../../media/fonts/Tekton.png")]
		public static const TektonPro_BoldTexture:Class;
		
		[Embed(source="../../media/fonts/Tekton.fnt", mimeType="application/octet-stream")]
		public static const TektonPro_BoldXML:Class;
		
		[Embed(source="../../media/fonts/Tekton_Small.png")]
		public static const TektonPro_SmallTexture:Class;
		
		[Embed(source="../../media/fonts/Tekton_Small.fnt", mimeType="application/octet-stream")]
		public static const TektonPro_SmallXML:Class;
		
		[Embed(source="../../media/fonts/Thonburi.png")]
		public static const ThonburiTexture:Class;
		
		[Embed(source="../../media/fonts/Thonburi.fnt", mimeType="application/octet-stream")]
		public static const ThonburiXML:Class;
		
		[Embed(source="../../media/fonts/Thonburi_Small.png")]
		public static const Thonburi_SmallTexture:Class;
		
		[Embed(source="../../media/fonts/Thonburi_Small.fnt", mimeType="application/octet-stream")]
		public static const Thonburi_SmallXML:Class;
		
		[Embed(source="../../config/BoardsConfig.xml", mimeType="application/octet-stream")]
		public static const BoardsConfigXML:Class;
		
		public static var gameTextures:Dictionary = new Dictionary();
		public static var gameXMLs:Dictionary = new Dictionary();
		public static var gameAtlas:Dictionary = new Dictionary();
		public static var fontAtlas:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture
		{
			if(gameTextures[name] == undefined) 
			{
				var bitmap:Bitmap = new AssetsManager[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		public static function getXML(name:String):XML
		{
			if(gameXMLs[name] == undefined)
			{
				var xml:XML = XML(new AssetsManager[name]());
				gameXMLs[name] = xml;
			}
			return gameXMLs[name];
		}
		
		public static function getAtlas(name:String):TextureAtlas
		{
			if(gameAtlas[name] == undefined)
			{
				var texture:Texture = getTexture(name + "Texture");
				var xml:XML = getXML(name + "XML");
				gameAtlas[name] = new TextureAtlas(texture, xml);
			}
			return gameAtlas[name];
		}
		
		public static function registerBitmapFont(name:String):void
		{
			if(fontAtlas[name] == undefined)
			{
				var texture:Texture = getTexture(name + "Texture");
				var xml:XML = getXML(name + "XML");
				
				TextField.registerBitmapFont(new BitmapFont(texture, xml));
				fontAtlas[name] = true;
			}
		}
	}
}