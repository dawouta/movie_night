package movienight.view.game.component
{
	import movienight.enum.Constants;
	import movienight.util.DeviceTypes;
	import movienight.util.Utils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;
	
	public class GameScreenAvatarDisplay extends Sprite
	{
		
		
		////////////////////////////////////////////////////////////////
		
		public function GameScreenAvatarDisplay( avatarTexture : Texture )
		{
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			var border : Image = new Image( atlas.getTexture( "avatar_border" ) );
			var avatar : Image = new Image( avatarTexture );
			if( !DeviceTypes.isSimulator() )
			{
				Utils.centerPivot( avatar );
				avatar.rotation = deg2rad( -90 );
				avatar.scaleX = avatar.scaleY = ( border.width - 6 ) / avatar.width;
				avatar.x = avatar.width >> 1;
				avatar.y = avatar.height >> 1;
			}
			else
			{
				avatar.width = avatar.height = border.width - 6;
			}
			
			avatar.x += 3;
			avatar.y += 3
			addChild( avatar );
			addChild( border );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose() : void
		{
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}