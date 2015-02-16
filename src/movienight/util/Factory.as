package movienight.util
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import feathers.controls.TextInput;
	
	import fonts.PlutoSansLight;
	
	import movienight.enum.Constants;
	import movienight.view.ui.components.SignalButton;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Factory
	{
		
		////////////////////////////////////////////////////////////////
		
		public static function createDefaultButton( label : String, iconTextureName : String = null, fontName : String = null, fontSize : int = 25, fontColor : int = 0x333333, icon : Texture = null ) : SignalButton
		{
			if( !fontName ) fontName = new PlutoSansLight().fontName;
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			
			var btn : SignalButton = new SignalButton( atlas.getTexture( "default_button_bg_up" ), atlas.getTexture( "default_button_bg_down" ) );
			btn.setLabel( label, fontName, fontSize, fontColor );
			
			if( iconTextureName )
			{
				var iconImage : Image = new Image( atlas.getTexture(iconTextureName) );
				iconImage.x = btn.width - iconImage.width;
				btn.addChild( iconImage );
			}
			return btn
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function textureFromShape( s : Shape ) : Texture 
		{
			var bmd : BitmapData = new BitmapData( s.width, s.height, true, 0 );
			bmd.draw( s );
			return Texture.fromBitmapData( bmd );
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function createInputField( width : int = 100, height : int = 20, fontName : String = "Verdana", fontSize : int = 12, fontColor : uint = 0x000000 ) : TextInput
		{
			
			var input : TextInput = new TextInput();
			input.width = width;
			input.height = height;
			input.textEditorProperties.fontFamily = fontName;
			input.textEditorProperties.fontSize = fontSize * Assets.contentScaleFactor;
			input.textEditorProperties.color = fontColor;
			
			return input;
		}

		////////////////////////////////////////////////////////////////
		
		public static function createLinearGradientTexture( width : int, height : int, radians : Number = Math.PI * 0.5, 
															colors : Array = null, alphas : Array = null, ratios : Array = null ) : Texture
		{
			if( !colors ) colors = [0,0];
			if( !alphas ) alphas = [1,0];
			if( !ratios ) ratios = [0,255];
			
			var m : Matrix = new Matrix(); 
			m.createGradientBox( width, height, radians, 0, 0 );
			
			var s : Shape = new Shape(); 
			s.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, m); 
			s.graphics.drawRect( 0, 0, width, height ); 
			s.graphics.endFill();
			
			return textureFromShape( s );
			
		}
		
		////////////////////////////////////////////////////////////////
	}
}